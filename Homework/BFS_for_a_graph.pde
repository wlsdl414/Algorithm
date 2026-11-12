// BFS 애니메이션 (GeeksforGeeks 예제 그래프) - 끝나면 자동 재시작
int n = 5;
int src = 0;
ArrayList<Integer>[] adj = new ArrayList[n];
PVector[] pos = {
  new PVector(150, 130), new PVector(450, 130), new PVector(300, 260),
  new PVector(170, 400), new PVector(430, 400)
};

boolean[] visited, done;
boolean[][] tree;               // BFS 트리 간선
ArrayList<Integer> queue, result;
int curr, ni, checkV;           // 현재 정점, 이웃 인덱스, 지금 확인 중인 이웃
boolean finished, paused = false;
String msg;
int interval = 50;              // 몇 프레임마다 한 단계 (작을수록 빠름)
int waitSteps = 0;              // 끝난 뒤 기다린 단계 수
int restartDelay = 3;           // 몇 단계 쉬고 재시작할지

color WHITE = color(255), YELLOW = color(255, 225, 90),
      ORANGE = color(255, 150, 60), GREEN = color(120, 200, 120);

void setup() {
  size(600, 700);
  textFont(createFont("Malgun Gothic", 16));  // 한글 폰트 (맥: "AppleSDGothicNeo-Regular")
  textAlign(CENTER, CENTER);
  for (int i = 0; i < n; i++) adj[i] = new ArrayList<Integer>();
  addEdge(1, 2); addEdge(1, 0); addEdge(2, 0); addEdge(2, 3); addEdge(2, 4);
  reset();
}

void addEdge(int u, int v) { adj[u].add(v); adj[v].add(u); }

void reset() {
  visited = new boolean[n];
  done = new boolean[n];
  tree = new boolean[n][n];
  queue = new ArrayList<Integer>();
  result = new ArrayList<Integer>();
  curr = -1; ni = 0; checkV = -1; finished = false;
  waitSteps = 0;
  visited[src] = true;
  queue.add(src);
  msg = "시작: " + src + " 방문 표시 후 enqueue";
}

// BFS 한 단계 진행
void step() {
  if (finished) {                         // 끝났으면 잠깐 쉬었다가 재시작
    waitSteps++;
    msg = "BFS 종료 → 다시 시작까지 " + (restartDelay - waitSteps + 1);
    if (waitSteps > restartDelay) reset();
    return;
  }
  if (curr == -1) {                       // 큐에서 꺼낼 차례
    checkV = -1;
    if (queue.isEmpty()) { finished = true; msg = "큐가 비었음 → BFS 종료"; return; }
    curr = queue.remove(0);
    result.add(curr);
    ni = 0;
    msg = "dequeue " + curr + " → 결과에 추가";
  } else if (ni < adj[curr].size()) {     // 이웃 하나씩 확인
    int x = adj[curr].get(ni++);
    checkV = x;
    if (!visited[x]) {
      visited[x] = true;
      queue.add(x);
      tree[curr][x] = tree[x][curr] = true;
      msg = curr + "의 이웃 " + x + ": 미방문 → 방문 표시, enqueue";
    } else {
      msg = curr + "의 이웃 " + x + ": 이미 방문 → 건너뜀";
    }
  } else {                                // 이웃 다 봤음
    done[curr] = true;
    msg = curr + "의 이웃 확인 끝";
    curr = -1; checkV = -1;
  }
}

void draw() {
  if (!paused && frameCount % interval == 0) step();
  background(255);

  // 간선
  for (int u = 0; u < n; u++) {
    for (int v : adj[u]) {
      if (u > v) continue;
      boolean checking = (u == curr && v == checkV) || (v == curr && u == checkV);
      if (checking)        { stroke(230, 50, 50); strokeWeight(5); }
      else if (tree[u][v]) { stroke(60, 110, 230); strokeWeight(5); }
      else                 { stroke(180); strokeWeight(2); }
      line(pos[u].x, pos[u].y, pos[v].x, pos[v].y);
    }
  }

  // 정점
  for (int i = 0; i < n; i++) {
    fill(nodeColor(i));
    if (i == checkV) { stroke(230, 50, 50); strokeWeight(4); }
    else             { stroke(0); strokeWeight(2); }
    circle(pos[i].x, pos[i].y, 50);
    fill(0);
    textSize(20);
    text(i, pos[i].x, pos[i].y - 2);
  }

  // 설명 메시지
  fill(0);
  textSize(17);
  text(msg, width/2, 480);

  // 큐
  textAlign(LEFT, CENTER);
  textSize(16);
  text("Queue", 40, 540);
  drawBoxes(queue, 120, 540, YELLOW);

  // 결과
  fill(0);
  text("Result", 40, 600);
  drawBoxes(result, 120, 600, GREEN);
  textAlign(CENTER, CENTER);

  // 범례 & 조작법
  drawLegend(40, 650);
  fill(120);
  textSize(13);
  text("SPACE: 일시정지   →: 한 단계   R: 다시 시작", width/2, 685);
}

color nodeColor(int i) {
  if (i == curr) return ORANGE;
  if (done[i] || result.contains(i)) return GREEN;
  if (visited[i]) return YELLOW;
  return WHITE;
}

void drawBoxes(ArrayList<Integer> list, float x, float y, color c) {
  for (int k = 0; k < list.size(); k++) {
    fill(c); stroke(0); strokeWeight(1.5);
    rect(x + k * 50, y - 20, 44, 40, 6);
    fill(0);
    textAlign(CENTER, CENTER);
    text(list.get(k), x + k * 50 + 22, y - 2);
  }
  textAlign(LEFT, CENTER);
}

void drawLegend(float x, float y) {
  String[] names = {"미방문", "큐에 있음", "현재 정점", "꺼낸 정점"};
  color[] cs = {WHITE, YELLOW, ORANGE, GREEN};
  textSize(13);
  textAlign(LEFT, CENTER);
  for (int k = 0; k < 4; k++) {
    fill(cs[k]); stroke(0); strokeWeight(1);
    circle(x + k * 135, y, 16);
    fill(0);
    text(names[k], x + k * 135 + 14, y - 1);
  }
  textAlign(CENTER, CENTER);
}

void keyPressed() {
  if (key == ' ') paused = !paused;
  if (key == 'r' || key == 'R') reset();
  if (keyCode == RIGHT) step();
}
