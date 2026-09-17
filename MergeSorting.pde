int[] arr;

void setup() {
  intArr(16);
  printArr();
  mergeSorting(0, arr.length-1);
  printArr();
}

void intArr(int n) {
  int i;
  arr = new int[n];
  for(i=0; i<arr.length; i++) {
    arr[i] = (int) random(100);
  }
}

void printArr() {
  int i;
  for(i=0; i<arr.length; i++) {
    print(arr[i], " ");
  }
  println();
}

void mergeSorting(int left, int right) {
  int mid;
  if(left<right) {
    mid = (left+right)/2;
    mergeSorting(left, mid);
    mergeSorting(mid+1, right);
    merge(left, mid, right);
  }
}

void merge(int left, int mid, int right) {
  int i, j, k, n1, n2;
  n1 = mid-left+1;
  n2 = right-mid;
  int[] L = new int[n1];
  int[] R = new int[n2];
  for(i=0; i<n1; i++) L[i] = arr[left+i];
  for(j=0; j<n2; j++) R[j] = arr[mid+1+j];
  i = 0; j = 0; k = left;
  while(i<n1 && j<n2) {
    if(L[i]<=R[j]) {
      arr[k] = L[i];
      i++;
    } else {
      arr[k] = R[j];
      j++;
    }
    k++;
  }
  while(i<n1) {
    arr[k] = L[i];
    i++; k++;
  }
  while(j<n2) {
    arr[k] = R[j];
    j++; k++;
  }
}

void swap(int i, int j) {
   int tmp;
   tmp = arr[j];
   arr[j] = arr[i];
   arr[i] = tmp;
}

void draw() {
}
