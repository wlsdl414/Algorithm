// Kruskal MST 애니메이션
int n = 7;
PVector[] pos = {
  new PVector(100, 100), new PVector(300, 60), new PVector(500, 100),
  new PVector(130, 260), new PVector(330, 250), new PVector(200, 400),
  new PVector(460, 400)
};
// {u, v, 가중치}
int[][] E = {
  {0, 1, 7}, {0, 3, 5}, {1, 2, 8}, {1, 3, 9}, {1, 4, 7}, {2, 4, 5},
  {3, 4, 15}, {3, 5, 6}, {4, 5, 8}, {4, 6, 9}, {5, 6, 11}
};
int[] state;      // 0 아직, 1 선택, 2 사이클이라 버림
int[] p;          // union-find 부모
int[] deg;        // MST 간선 연결 수 (0이면 아직 혼자)
int idx, taken, total, wait;
boolean checking;
String msg;
int interval = 45;
color[] pal;

void setup() {
  size(600, 520);
  textFont(createFont("Malgun Gothic", 16));  // 맥: "AppleSDGothicNeo-Regular"
  textAlign(CENTER, CENTER);
  pal = new color[] {
    color(255, 120, 120), color(255, 190, 80), color(120, 200, 120),
    color(90, 170, 240), color(180, 130, 230), color(240, 140, 200),
    color(120, 210, 210)
  };
  // 가중치 오름차순 정렬
  for (int i = 0; i < E.length; i++)
    for (int j = i + 1; j < E.length; j++)
      if (E[j][2] < E[i][2]) { int[] t = E[i]; E[i] = E[j]; E[j] = t; }
  reset();
}

void reset() {
  state = new int[E.length];
  p = new int[n];
  deg = new int[n];
  for (int i = 0; i < n; i++) p[i] = i;
  idx = 0; taken = 0; total = 0; wait = 0;
  checking = false;
  msg = "가벼운 간선부터 검사 시작";
}

int find(int x) {
  while (p[x] != x) x = p[x];
  return x;
}

void step() {
  if (taken == n - 1 || idx >= E.length) {
    msg = "MST 완성!";
    wait++;
    if (wait > 4) reset();
    return;
  }
  int[] e = E[idx];
  if (!checking) {                       // 1단계: 검사 표시
    checking = true;
    msg = e[0] + "-" + e[1] + " (가중치 " + e[2] + ") 검사 중";
    return;
  }
  int a = find(e[0]), b = find(e[1]);    // 2단계: 결과
  if (a != b) {
    p[a] = b;
    state[idx] = 1;
    taken++;
    total += e[2];
    deg[e[0]]++; deg[e[1]]++;
    msg = e[0] + "-" + e[1] + " 선택";
  } else {
    state[idx] = 2;
    msg = e[0] + "-" + e[1] + " 사이클이라 버림";
  }
  checking = false;
  idx++;
}

void draw() {
  if (frameCount % interval == 0) step();
  background(255);

  // 간선
  for (int i = 0; i < E.length; i++) {
    int[] e = E[i];
    if (checking && i == idx) { stroke(255, 150, 30); strokeWeight(7); }
    else if (state[i] == 1)   { stroke(50, 90, 200);  strokeWeight(5); }
    else if (state[i] == 2)   { stroke(225);          strokeWeight(1.5); }
    else                      { stroke(190);          strokeWeight(2); }
    line(pos[e[0]].x, pos[e[0]].y, pos[e[1]].x, pos[e[1]].y);
  }

  // 가중치
  textSize(14);
  for (int i = 0; i < E.length; i++) {
    int[] e = E[i];
    float mx = (pos[e[0]].x + pos[e[1]].x) / 2, my = (pos[e[0]].y + pos[e[1]].y) / 2;
    noStroke(); fill(255);
    rect(mx - 12, my - 10, 24, 20, 4);
    fill(state[i] == 2 ? 170 : 0);
    text(e[2], mx, my - 1);
  }

  // 정점 (같은 색 = 같은 그룹)
  for (int i = 0; i < n; i++) {
    fill(deg[i] > 0 ? pal[find(i)] : color(255));
    stroke(0); strokeWeight(2);
    circle(pos[i].x, pos[i].y, 44);
    fill(0); textSize(18);
    text(i, pos[i].x, pos[i].y - 2);
  }

  // 하단
  fill(0);
  textSize(18);
  text(msg, width/2, 460);
  textSize(15);
  fill(90);
  text("총 가중치 = " + total, width/2, 492);
}
