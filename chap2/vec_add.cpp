#include <iostream>
#include <vector>

using namespace std;

void print_vector(vector<int> &vec) {
  for (auto &&i : vec) {
    cout << i << ",";
  }
  cout<<"\n";
}

void vecAdd(vector<int> &A, vector<int> &B, vector<int> &C) {
  for (size_t i = 0; i < A.size(); i++) {
    C[i] = A[i] + B[i];
  }
}

int main(int argc, char const *argv[]) {
  vector<int> A = {1, 2, 3, 4};
  vector<int> B = {1, 2, 3, 4};
  vector<int> C(4, 0);
  print_vector(A);
  print_vector(B);
  vecAdd(A, B, C);
  print_vector(C);
  return 0;
}
