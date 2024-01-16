#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <omp.h>

#define LENGTH_INDEX 1
#define NUM_THREAD_INDEX 2

#define F_1(x) (2.17f * x)
#define F_2(x) (2.17f * logf(x) * cosf(x))

int getArgumentValueInt(int index, char* argString);
void fillArrayWithRandomValues(float* array, int length);
void testSum(float* array, int length);
void test2(float* array, int length);

int main(int argc, char* argv[])
{
    // Random seed
    srand(time(NULL));

    // Verify the presence of all the arguments
    if (argc != 3)
    {
        printf("ERROR:\tYou must specify the length and the number of threads!\n");
        return EXIT_FAILURE;
    }

    // Convert arguments to integers
    int arrayLength = getArgumentValueInt(LENGTH_INDEX, argv[LENGTH_INDEX]);
    int numberOfThreads = getArgumentValueInt(NUM_THREAD_INDEX, argv[NUM_THREAD_INDEX]);

    // Set the number of threads
    omp_set_num_threads(numberOfThreads);

    // Allocate array + put random values
    float* fArray = (float*)malloc(arrayLength * sizeof(float));
    fillArrayWithRandomValues(fArray, arrayLength);

    // Tests
    printf("N; Num_threads; tt1_seq [ms]; tt1_para [ms]; tt2_seq [ms]; tt2_para [ms]\n");
    printf("%d;%d;", arrayLength, numberOfThreads);
    testSum(fArray, arrayLength);
    test2(fArray, arrayLength);

    // Free array
    free(fArray);
    return EXIT_SUCCESS;
}

int getArgumentValueInt(int index, char* argString)
{
    // Get value from argument string
    int value = atoi(argString);
    
    // Verify value
    if (value <= 0)
    {
        printf("ERROR:\tArguments must be non-zero positive integers\n");
        printf("\t\tBad argument index: %d\n", index);
        exit(EXIT_FAILURE);
    }

    return value;
}

void fillArrayWithRandomValues(float *array, int length)
{
    // Put random value (interval [-5, 5])
    for (int i = 0; i < length; i++)
        array[i] = 10.0f * ((float)(rand() / RAND_MAX) - 0.5f);
}

void testSum(float *array, int length)
{
    // ********************* Test 1 begin ********************* //
    double start, stop;
    double elapsedTimeSequential, elapsedTimeParallel;

    // Sequential version
    start = omp_get_wtime();

    for (int i = 0; i < length; i++)
        array[i] = F_1(array[i]);
        
    stop = omp_get_wtime();
    elapsedTimeSequential = stop - start;


    // Renew values
    fillArrayWithRandomValues(array, length);


    // Parallel version
    start = omp_get_wtime();

#   pragma omp parallel for 
    for (int i = 0; i < length; i++)
        array[i] = F_1(array[i]);

    stop = omp_get_wtime();
    elapsedTimeParallel = stop - start;


    // Renew values
    fillArrayWithRandomValues(array, length);


    // Print results
    printf("%lf;%lf;", elapsedTimeSequential * 1e3, elapsedTimeParallel * 1e3);
}

void test2(float *array, int length)
{
    // ********************* Test 2 begin ********************* //
    double start, stop;
    double elapsedTimeSequential, elapsedTimeParallel;

    // Sequential version
    start = omp_get_wtime();

    for (int i = 0; i < length; i++)
        array[i] = F_2(array[i]);
        
    stop = omp_get_wtime();
    elapsedTimeSequential = stop - start;


    // Renew values
    fillArrayWithRandomValues(array, length);


    // Parallel version
    start = omp_get_wtime();

#   pragma omp parallel for 
    for (int i = 0; i < length; i++)
        array[i] = F_2(array[i]);

    stop = omp_get_wtime();
    elapsedTimeParallel = stop - start;


    // Renew values
    fillArrayWithRandomValues(array, length);


    // Print results
    printf("%lf;%lf\n", elapsedTimeSequential * 1e3, elapsedTimeParallel * 1e3);
}
