#ifndef IMAGE_IO_H
#define IMAGE_IO_H

void read_image(char *name, double **image, int *im_width, int *im_height);
void read_imagef(char *name, float **image, int *im_width, int *im_height);
void read_imagec(char *name, unsigned char **image, int *im_width, int *im_height);
void write_image(char *name, double *image, int im_width, int im_height);
void write_imagef(char *name, float *image, int im_width, int im_height);
void write_imagec(char *name, unsigned char *image, int im_width, int im_height);

#endif
