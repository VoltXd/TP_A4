#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include <math.h>
#include <string.h>
#include <sys/time.h>
#include "image_io.h"
#include "ShiTomasi.h"
#include <omp.h>
#include <sys/time.h>

float timedifference_msec(struct timeval t0, struct timeval t1)
{
	return (t1.tv_sec - t0.tv_sec) * 1000.0f + (t1.tv_usec - t0.tv_usec) / 1000.0f;
}

int main(int argc, char **argv)
{

	// path to the image to process
	char *filepath = NULL;

	// sigma of the gaussian distribution
	float sigma = 1.1;
	// size of a pixel 'neighborhood'
	int windowsize = 4;
	// # of features
	int max_features = 1024;

	// argument parsing logic
	if (argc == 4)
	{
		filepath = argv[1];
		windowsize = atof(argv[2]);
		max_features = atoi(argv[3]);
	}
	else
	{
		help(NULL);
	}

	printf("detecting features for %s\n", filepath);
	printf("sigma = %0.3f, windowsize = %d, max_features = %d\n", sigma, windowsize, max_features);

	int width;
	int height;
	int kernel_width;
	int a;

	// calculate kernel width based on sigma
	a = (int)round(2.5 * sigma - .5);
	kernel_width = 2 * a + 1;

	// malloc and read the image to be processed
	float *original_image;

	read_imagef(filepath, &original_image, &width, &height);

	printf("image_size: [%d x %d] px\n", width, height);

	// malloc and generate the kernels
	float *gkernel = (float *)malloc(sizeof(float) * kernel_width);
	float *dkernel = (float *)malloc(sizeof(float) * kernel_width);
	gen_kernel(gkernel, dkernel, sigma, a, kernel_width);

	// create hgrad and vgrad and temp
	float *hgrad = (float *)malloc(sizeof(float) * width * height);
	float *vgrad = (float *)malloc(sizeof(float) * width * height);
	float *tmp_image = (float *)malloc(sizeof(float) * width * height);

	double timer_start_conv = omp_get_wtime();
	// convolve to get the vgrad and hgrad
	convolve(gkernel, original_image, tmp_image, width, height, kernel_width, 1, a);
	convolve(dkernel, tmp_image, vgrad, width, height, 1, kernel_width, a);
	convolve(gkernel, original_image, tmp_image, width, height, 1, kernel_width, a);
	convolve(dkernel, tmp_image, hgrad, width, height, kernel_width, 1, a);
	double timer_elapsed_conv = omp_get_wtime() - timer_start_conv;

	free(tmp_image);
	free(gkernel);
	free(dkernel);

	// Compute the eigenvalues of each pixel's z matrix. After this we can free the gradients.
	data_wrapper_t *eigenvalues = (data_wrapper_t *)malloc(sizeof(data_wrapper_t) * width * height);

	struct timeval current_time, end_time;
	double timer_start_eigen = omp_get_wtime();
	gettimeofday(&current_time, NULL);
	compute_eigenvalues(hgrad, vgrad, height, width, windowsize, eigenvalues);
	double timer_elapsed_eigen = omp_get_wtime() - timer_start_eigen;
	gettimeofday(&end_time, NULL);
	// float elapsed = timedifference_msec(current_time, end_time);
	float elapsed = (end_time.tv_sec - current_time.tv_sec) * 1000.0f + (end_time.tv_usec - current_time.tv_usec) / 1000.0f;

	// long double elapsed_double = (float)elapsed / (float)1000000;
	printf("[gettimeofday] EigenValues Time %f\n", elapsed);
	// printf("[gettimeofday] EigenValues Time %ld\n", (long)elapsed_double);

	free(hgrad);
	free(vgrad);

	// Find the features based on the eigenvalues.
	data_wrapper_t *features;
	unsigned int features_count;

	features_count = find_features(eigenvalues, max_features, width, height, &features);

	free(eigenvalues);

	printf("%d features detected\n", features_count);

	printf("Convolution Time %f\n", timer_elapsed_conv);
	printf("EigenValues Time %f\n", timer_elapsed_eigen);

	// printf("\t");
	// print_features(features, features_count);

	// Mark the features in the output image.
	draw_features(features, features_count, original_image, width, height);

	free(features);

	// Now we write the output.
	char corner_image[30];
	sprintf(corner_image, "output_images/corners.pgm");

	write_imagef(corner_image, original_image, width, height);

	// Free stuff leftover.
	free(original_image);

	return 0;
}

void draw_features(data_wrapper_t *features, unsigned int count, float *image, int image_width, int image_height)
{
	int radius = image_width * 0.0025;
	for (int i = 0; i < count; ++i)
	{
		int x = features[i].x;
		int y = features[i].y;
		for (int k = -1 * radius; k <= radius; k++)
		{
			for (int m = -1 * radius; m <= radius; m++)
			{
				if ((x + k) >= 0 && (x + k) < image_height && (y + m) >= 0 && (y + m) < image_width)
					image[(x + k) * image_width + (y + m)] = 0;
			}
		}
	}
}

unsigned int find_features(data_wrapper_t *eigenvalues, int max_features, int image_width, int image_height, data_wrapper_t **features)
{
	size_t image_size = image_height * image_width;

	// Sort eigenvalues in descending order while keeping their corresponding pixel index in the image.
	qsort(eigenvalues, image_height * image_width, sizeof *eigenvalues, sort_data_wrapper_value_desc);

	// Create the features buffer based on the max_features value (acts as a percentage of the image size).
	*features = (data_wrapper_t *)malloc(sizeof(data_wrapper_t) * max_features);

	// Fill the features buffer!
	unsigned int features_count = 0;
	const int ignore_x = 3; // ignore this many pixels rows from top/bottom of image
	const int ignore_y = 3; // ignore this many pixels columns from left/right of image
	for (int i = 0; i < image_size && features_count < max_features; ++i)
	{
		// Ignore top left, top right, bottom right, bottom left edges of image.
		if (eigenvalues[i].x <= ignore_x || eigenvalues[i].y <= ignore_y ||
			eigenvalues[i].x >= image_width - 1 - ignore_x || eigenvalues[i].y >= image_height - 1 - ignore_y)
		{
			continue;
		}

		// Have to seed the first feature so we have a place to start.
		if (features_count == 0)
		{
			(*features)[0] = eigenvalues[i];
			features_count++;
		}

		// Check if prospective feature is more than 8 manhattan distance away from any existing feature.
		int is_good = 1;
		for (int j = 0; j < features_count; ++j)
		{
			int manhattan = abs((*features)[j].x - eigenvalues[i].x) + abs((*features)[j].y - eigenvalues[i].y);
			if (manhattan <= 8)
			{
				is_good = 0;
				break;
			}
		}

		// If the prospective feature was at least 8 manhattan distance from all existing features, then we can add it.
		if (is_good)
		{
			(*features)[features_count] = eigenvalues[i];
			features_count++;
		}
	}

	return features_count;
}

int sort_data_wrapper_value_desc(const void *a, const void *b)
{
	const data_wrapper_t *aa = (const data_wrapper_t *)a;
	const data_wrapper_t *bb = (const data_wrapper_t *)b;
	return (aa->data < bb->data) - (aa->data > bb->data);
}

int sort_data_wrapper_index_asc(const void *a, const void *b)
{
	const data_wrapper_t *aa = (const data_wrapper_t *)a;
	const data_wrapper_t *bb = (const data_wrapper_t *)b;

	if (aa->x == bb->x)
		return ((aa->y > bb->y) - (aa->y < bb->y));
	else
		return ((aa->x > bb->x) - (aa->x < bb->x));
}

void compute_eigenvalues(float *hgrad, float *vgrad, int image_height, int image_width, int windowsize, data_wrapper_t *eigenvalues)
{
	int w = floor(windowsize / 2);

	int i, j, k, m, offseti, offsetj;
	float ixx_sum, iyy_sum, ixiy_sum;

	#pragma omp parallel for collapse(2)
	for (i = 0; i < image_height; i++)
	{
		for (j = 0; j < image_width; j++)
		{
			ixx_sum = 0;
			iyy_sum = 0;
			ixiy_sum = 0;

			for (k = 0; k < windowsize; k++)
			{
				for (m = 0; m < windowsize; m++)
				{
					offseti = -1 * w + k;
					offsetj = -1 * w + m;
					if (__builtin_expect(i + offseti >= 0 && i + offseti < image_height && j + offsetj >= 0 && j + offsetj < image_width, 1))
					{
						ixx_sum += hgrad[(i + offseti) * image_width + (j + offsetj)] * hgrad[(i + offseti) * image_width + (j + offsetj)];
						iyy_sum += vgrad[(i + offseti) * image_width + (j + offsetj)] * vgrad[(i + offseti) * image_width + (j + offsetj)];
						ixiy_sum += hgrad[(i + offseti) * image_width + (j + offsetj)] * vgrad[(i + offseti) * image_width + (j + offsetj)];
					}
				}
			}

			eigenvalues[i * image_width + j].x = i;
			eigenvalues[i * image_width + j].y = j;
			eigenvalues[i * image_width + j].data = min_eigenvalue(ixx_sum, ixiy_sum, ixiy_sum, iyy_sum);
		}
	}
}

float min_eigenvalue(float a, float b, float c, float d)
{
	float ev_one = (a + d) / 2 + sqrtf(((a + d) * (a + d)) / 4 - (a * d - b * c));
	float ev_two = (a + d) / 2 - sqrtf(((a + d) * (a + d)) / 4 - (a * d - b * c));
	if (ev_one >= ev_two)
	{
		return ev_two;
	}
	else
	{
		return ev_one;
	}
}

void convolve(float *kernel, float *image, float *resultimage, int image_width, int image_height, int kernel_width, int kernel_height, int half)
{
	float sum;
	int i, j, k, m, offsetj, offseti;
	// assign the kernel to the new array
	#pragma omp parallel for collapse(2)
	for (i = 0; i < image_height; i++)
	{
		for (j = 0; j < image_width; j++)
		{

			// reset tracker
			sum = 0.0;
			// for each item in the kernel
			for (k = 0; k < kernel_height; k++)
			{
				for (m = 0; m < kernel_width; m++)
				{
					offseti = -1 * (kernel_height / 2) + k;
					offsetj = -1 * (kernel_width / 2) + m;
					if (__builtin_expect(i + offseti >= 0 && i + offseti < image_height && j + offsetj >= 0 && j + offsetj < image_width, 1)) 
					{
						sum += (float)(image[(i + offseti) * image_width + (j + offsetj)]) * kernel[k * kernel_width + m];
					}
				}
			}
			// copy it back
			resultimage[i * image_width + j] = sum;
		}
	}
}

void gen_kernel(float *gkernel, float *dkernel, float sigma, int a, int w)
{
	int i;
	float sum_gkern;
	float sum_dkern;
	sum_gkern = 0;
	sum_dkern = 0;
	for (i = 0; i < w; i++)
	{
		gkernel[i] = (float)exp((float)(-1.0 * (i - a) * (i - a)) / (2 * sigma * sigma));
		dkernel[i] = (float)(-1 * (i - a)) * (float)exp((float)(-1.0 * (i - a) * (i - a)) / (2 * sigma * sigma));
		sum_gkern = sum_gkern + gkernel[i];
		sum_dkern = sum_dkern - (float)i * dkernel[i];
	}

	// reverse the kernel by creating a new kernel, yes not ideal
	float *newkernel = (float *)malloc(sizeof(float) * w);
	for (i = 0; i < w; i++)
	{
		dkernel[i] = dkernel[i] / sum_dkern;
		gkernel[i] = gkernel[i] / sum_gkern;
		newkernel[w - i] = dkernel[i];
	}

	// copy new kernel back in
	for (i = 0; i < w; i++)
	{
		dkernel[i] = newkernel[i + 1];
	}
	free(newkernel);
}

void help(const char *err)
{
	if (err != NULL)
		printf("%s\n", err);
	printf("Utilisation: ./ShiTomasi <chemin vers l'image> [Taille de la fenêtre] [Nombre de primitives] \n");
	printf("arguments:\n");
	printf("\tTaille de la fenêtre: taille du voisinage d'un pixel dans l'image\n");
	printf("\tNombre de primitives: nombre de primitives à extraire\n");
	exit(0);
}

void print_features(data_wrapper_t *features, unsigned int count)
{
	// Sort the features by
	qsort(features, count, sizeof *features, sort_data_wrapper_index_asc);
	for (unsigned int i = 0; i < count; ++i)
	{
		if (i % 15 != 0 || i == 0)
			printf("(%d,%d) ", features[i].x, features[i].y);
		else
			printf("(%d,%d)\n\t", features[i].x, features[i].y);
	}
	printf("\n");
}
