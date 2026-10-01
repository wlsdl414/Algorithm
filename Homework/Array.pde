class Array {
  int[] arr;
  int len, i0, j0;

  // 처음 배열: 랜덤 값으로 생성
  Array(int len, int i0, int j0) {
    this.len = len;
    this.i0 = i0;
    this.j0 = j0;
    arr = new int[len];
    for (int k=0; k<len; k++) {
      arr[k] = (int) random(100);
    }
  }

  // 이전 단계 배열을 복사해서 생성
  Array(int len, int[] src, int i0, int j0) {
    this.len = len;
    this.i0 = i0;
    this.j0 = j0;
    arr = new int[len];
    for (int k=0; k<len; k++) {
      arr[k] = src[k];
    }
  }

  // 원 크기로 값 표현
  void draw() {
    float mx = 20;
    float dx = (width - 2*mx) / len;
    float cy = height / 2;
    int a = abs(j0);
    noStroke();
    for (int k=0; k<len; k++) {
      float d = map(arr[k], 0, 100, 6, dx - 4);
      if (k == a || (type == 1 && k == a-1 && a > 0)) fill(255, 80, 80);     // 비교 중
      else if (type == 1 && k >= len - i0 + 1) fill(80, 200, 120);            // 정렬 완료
      else fill(80, 140, 255);
      ellipse(mx + dx*k + dx/2, cy, d, d);
      fill(0);
      textSize(12);
      textAlign(CENTER);
      text(arr[k], mx + dx*k + dx/2, cy + dx/2 + 20);
    }
    stroke(0);
    textAlign(LEFT);
    textSize(24);
  }

  void printArray() {
    for (int k=0; k<len; k++) {
      print(arr[k] + " ");
    }
    println();
  }
}
