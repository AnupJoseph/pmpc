#include <iostream>
#include <stdlib.h>

void printFloatArray(const float arr[], int size) {
  // std::cout << size;
  for (int i = 0; i < size; i++) {
    std::cout << arr[i];
    if (i < size - 1) {
      std::cout << ", ";
    }
  }
  std::cout << std::endl;
}

void vecadd(float *A_h, float *B_h, float *C_h, int N) {
  for (size_t i = 0; i < N; i++) {
    C_h[i] = A_h[i] + B_h[i];
  }
}

// The __global__ is a function identifier which says to CUDA that this is a
// kernal function and it can be called to generate a grid of threads on a
// device
__global__ void vec_add_kernal(float *A, float *B, float *C, int N) {
  /*
  blockDim : For a given grid of threads, the number of threads in a block is
  available in a built-in variable named blockDim .

  threadIdx : The threadIdx variable gives each thread a unique coordinate
  within a block. The first thread in each block has value 0 in its threadIdx.x
  variable, the second thread has value 1, the third thread has value 2, and so
  on.

  blockIdx : The blockIdx  variable gives all threads in a block a common block
  coordinate. All threads in the first block have value 0 in their blockIdx.x
  variables, those in the second thread block value 1, and so on.
  */
  int i = threadIdx.x + blockIdx.x * blockDim.x;
  if (i < N) {
    C[i] = A[i] + B[i];
  }
}

void vecadd_gpu(float *A_h, float *B_h, float *C_h, int N) {
  int size = N * sizeof(float);
  float *A_d, *B_d, *C_d;

  // cudaMalloc is used to allocate memory on the device
  cudaMalloc((void **)&A_d, size);
  cudaMalloc((void **)&B_d, size);
  cudaMalloc((void **)&C_d, size);

  // Function to copy data to and from device and host. Uses either
  // cudaMemcpyHostToDevice or cudaMemcpyDeviceToHost to inidicate direction
  cudaMemcpy(A_d, A_h, size, cudaMemcpyHostToDevice);
  cudaMemcpy(B_d, B_h, size, cudaMemcpyHostToDevice);

  // Mechanism to declare execution parameters more formally
  dim3 threads(256, 1, 1);
  dim3 blocks(ceil(N / 256.0), 1, 1);

  // The tripe quote thingy is an execution parameter
  vec_add_kernal<<<blocks, threads>>>(A_d, B_d, C_d, N);

  cudaMemcpy(C_h, C_d, size, cudaMemcpyDeviceToHost);

  // Use yer imagination
  // printFloatArray(C_d,N);
  cudaFree(A_d);
  cudaFree(B_d);
  cudaFree(C_d);
}

int main(int argc, char const *argv[]) {
  cudaDeviceSynchronize();
  int N = argc > 1 ? atoi(argv[1]) : 100;
  // int N = atoi(argv[1]);
  float *A = new float[N];
  float *B = new float[N];
  float *C = new float[N];
  std::fill(A, A + N, 1.0 * 14);
  std::fill(B, B + N, 1.0 * 16);
  // printFloatArray(A, N);
  // printFloatArray(B, N);

  // vecadd(A, B, C, N);
  vecadd_gpu(A, B, C, N);
  printFloatArray(C, N);
  return 0;
}
// nvcc simple_add.cu -o simple_add_gpu & ./simple_add_gpu 10