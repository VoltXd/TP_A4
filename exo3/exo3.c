#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <omp.h>

#define LENGTH_INDEX 1
#define NUM_THREAD_INDEX 2

int getArgumentValueInt(int index, char* argString);
void fillArrayWithRandomValues(float* array, int length);
void testSum(float* array, int length);

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
    printf("N; Num_threads; tsum_seq [ms]; tsum_para [ms]; tsum_para_dyn [ms]; tsum_para_ato [ms]; tsum_para_crit [ms];\n");
    printf("%d;%d;", arrayLength, numberOfThreads);
    testSum(fArray, arrayLength);

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
    // ********************* Test sum begin ********************* //
    double start, stop;
    double elapsedTimeSequential, elapsedTimeParallel, elapsedTimeParallelDynamic, elapsedTimeParallelAtomic, elapsedTimeParallelCritical;

    float sum;

    // Sequential version
    start = omp_get_wtime();

    sum = 0.0f;
    for (int i = 0; i < length; i++)
        sum += array[i];
        
    stop = omp_get_wtime();
    elapsedTimeSequential = stop - start;


    // Parallel version
    start = omp_get_wtime();

    sum = 0.0f;
#   pragma omp parallel for reduction(+:sum)
    for (int i = 0; i < length; i++)
        sum += array[i];

    stop = omp_get_wtime();
    elapsedTimeParallel = stop - start;

    
    // Parallel dynamic version
    start = omp_get_wtime();

    sum = 0.0f;
#   pragma omp parallel for reduction(+:sum) schedule(static, 128)
    for (int i = 0; i < length; i++)
        sum += array[i];

    stop = omp_get_wtime();
    elapsedTimeParallelDynamic = stop - start;

    
    // Parallel atomic version
    start = omp_get_wtime();

    sum = 0.0f;
#   pragma omp parallel for
    for (int i = 0; i < length; i++)
#       pragma omp atomic
        sum += array[i];

    stop = omp_get_wtime();
    elapsedTimeParallelAtomic = stop - start;

    
    // Parallel critical version
    start = omp_get_wtime();

    sum = 0.0f;
#   pragma omp parallel for
    for (int i = 0; i < length; i++)
#       pragma omp critical
        sum += array[i];

    stop = omp_get_wtime();
    elapsedTimeParallelCritical = stop - start;


    // Renew values
    fillArrayWithRandomValues(array, length);


    // Print results
    printf("%lf;%lf;%lf;%lf;%lf;\n", elapsedTimeSequential * 1e3, elapsedTimeParallel * 1e3, elapsedTimeParallelDynamic * 1e3, elapsedTimeParallelAtomic * 1e3, elapsedTimeParallelCritical * 1e3);
}
