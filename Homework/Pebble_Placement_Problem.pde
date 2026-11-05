// 3 x N 테이블 조약돌 놓기 (DP) - Processing 버전

int[][] table = {
  {  6,  7, 12, -5,  5,  3, 11,  3 },
  { -8, 10, 14,  9,  7, 13,  8,  5 },
  { 11, 12,  7,  4,  8, -2,  9,  4 }
};

int n;            // 열 개수
int[][] value;    // 패턴별 값 (패턴1~4)
int[][] dp;       // dp[p][i] : i번째 열이 패턴 p일 때 0~i열까지 최대합
int[][] from;     // 역추적용 : 직전 열의 패턴
int[] chosen;     // 최종적으로 고른 열별 패턴
int maxSum;

// 각 패턴 앞에 올 수 있는 패턴 (0:1행, 1:2행, 2:3행, 3:1+3행)
// Case1 <- 2,3 / Case2 <- 1,3,4 / Case3 <- 1,2 / Case4 <- 2
int[][] prevOf = {
  {1, 2},
  {0, 2, 3},
  {0, 1},
  {1}
};

int cellW = 80, cellH = 70, marginX = 40, marginY = 40;

void setup() {
  size(720, 340);
  n = table[0].length;

  value = new int[4][n];
  dp    = new int[4][n];
  from  = new int[4][n];

  // Value 배열 초기화 (패턴1~3)
  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < n; c++) {
      value[r][c] = table[r][c];
    }
  }
  // 1, 3번째 행에 동시에 놓을 때 (패턴4)
  for (int c = 0; c < n; c++) {
    value[3][c] = value[0][c] + value[2][c];
  }

  // 첫 번째 열 초기화
  for (int p = 0; p < 4; p++) {
    dp[p][0] = value[p][0];
    from[p][0] = -1;
  }

  // DP 배열 채우기
  for (int i = 1; i < n; i++) {
    for (int p = 0; p < 4; p++) {
      int best = Integer.MIN_VALUE;
      for (int q : prevOf[p]) {
        if (dp[q][i - 1] > best) {
          best = dp[q][i - 1];
          from[p][i] = q;
        }
      }
      dp[p][i] = best + value[p][i];
    }
  }

  // 마지막 열에서 최대값 찾기
  int last = 0;
  for (int p = 1; p < 4; p++) {
    if (dp[p][n - 1] > dp[last][n - 1]) last = p;
  }
  maxSum = dp[last][n - 1];

  // 역추적해서 열마다 고른 패턴 찾기
  chosen = new int[n];
  int p = last;
  for (int i = n - 1; i >= 0; i--) {
    chosen[i] = p;
    p = from[p][i];
  }

  println("최대 합: " + maxSum);
  noLoop();
}

// (row, col)에 조약돌이 놓였는지
boolean isSelected(int row, int col) {
  int p = chosen[col];
  if (p == 3) return row == 0 || row == 2;
  return row == p;
}

void draw() {
  background(255);
  textAlign(CENTER, CENTER);
  textSize(20);

  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < n; c++) {
      float x = marginX + c * cellW;
      float y = marginY + r * cellH;

      stroke(0);
      fill(245);
      rect(x, y, cellW, cellH);

      // 조약돌 표시
      if (isSelected(r, c)) {
        noStroke();
        fill(255, 180, 60);
        ellipse(x + cellW / 2, y + cellH / 2, cellH * 0.8, cellH * 0.8);
      }

      fill(0);
      text(table[r][c], x + cellW / 2, y + cellH / 2);
    }
  }

  textSize(24);
  fill(0);
  text("Max Sum = " + maxSum, width / 2, marginY + 3 * cellH + 40);
}
