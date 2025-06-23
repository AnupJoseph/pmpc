#include <iostream>
#include <stdlib.h>

void conversionToGrayscale(int n, int m) {
  dim3 dimBlock(16, 16, 1);
  dim3 dimGrid(m / 16.0, n / 16.0, 1);
  grayscale<<<dimGrid, dimBlock>>>(Pin_d, Pout_d, m, n);
}
