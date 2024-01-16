#include <stdio.h>
#include <omp.h>

int main()
{
    printf("Number of cores: %d\nMax number of threads: %d\n", omp_get_num_procs(), omp_get_max_threads());
    return 0;
}