import java.util.Stack;

PFont myFont;
String inputText = "";
String infix = "";
String postfix = "";
String resultText = "";

void setup() {
  size(600, 350);
  // 한글 폰트 설정 (맥이면 "AppleSDGothicNeo-Regular")
  myFont = createFont("Malgun Gothic", 16);
  textFont(myFont);
}

void draw() {
  background(245);

  fill(0);
  textSize(16);
  text("수식을 입력하고 Enter를 누르세요 (예: 3 + 5 * ( 2 - 8 ) )", 30, 40);
  text("※ 숫자, 연산자, 괄호 사이에 공백을 꼭 넣어주세요", 30, 65);

  // 입력창
  fill(255);
  stroke(200);
  rect(30, 85, 540, 40, 5);
  fill(0);
  String cursor = (frameCount / 30 % 2 == 0) ? "_" : "";
  text(inputText + cursor, 40, 112);

  stroke(180);
  line(30, 150, 570, 150);

  fill(80);
  text("입력한 중위 표기식 (Infix): " + infix, 30, 190);

  fill(30, 110, 210);
  text("변환된 후위 표기식 (Postfix): " + postfix, 30, 230);

  fill(220, 30, 30);
  textSize(20);
  text("최종 계산 결과: " + resultText, 30, 285);
}

void keyPressed() {
  if (key == ENTER || key == RETURN) {
    calculate();
  } else if (key == BACKSPACE) {
    if (inputText.length() > 0) {
      inputText = inputText.substring(0, inputText.length() - 1);
    }
  } else if (key != CODED) {
    inputText += key;
  }
}

void calculate() {
  infix = inputText;
  try {
    String[] tokens = splitTokens(inputText, " ");
    postfix = toPostfix(tokens);
    float result = evalPostfix(splitTokens(postfix, " "));
    resultText = str(result);
  } catch (Exception e) {
    postfix = "";
    resultText = "수식 오류";
  }
}

boolean isOperator(String t) {
  return t.equals("+") || t.equals("-") || t.equals("*") || t.equals("/");
}

int prec(String op) {
  if (op.equals("+") || op.equals("-")) return 1;
  if (op.equals("*") || op.equals("/")) return 2;
  return 0;  // "("
}

// 중위 → 후위
String toPostfix(String[] tokens) {
  Stack<String> st = new Stack<String>();
  String out = "";

  for (String t : tokens) {
    if (t.equals("(")) {
      st.push(t);
    } else if (t.equals(")")) {
      while (!st.peek().equals("(")) out += st.pop() + " ";
      st.pop();  // "(" 제거
    } else if (isOperator(t)) {
      // top 우선순위가 같거나 높으면 먼저 꺼냄
      // 뒤에 나온 연산자가 더 높으면 위에 쌓여서 먼저 나옴 (LIFO)
      while (!st.isEmpty() && prec(st.peek()) >= prec(t)) {
        out += st.pop() + " ";
      }
      st.push(t);
    } else {
      out += t + " ";  // 피연산자
    }
  }
  while (!st.isEmpty()) out += st.pop() + " ";
  return out.trim();
}

// 피연산자 값 (숫자는 그대로, A=1, B=2, C=3 ...)
float value(String t) {
  char c = t.charAt(0);
  if (Character.isLetter(c)) return Character.toUpperCase(c) - 'A' + 1;
  return float(t);
}

// 후위식 계산
float evalPostfix(String[] tokens) {
  Stack<Float> st = new Stack<Float>();

  for (String t : tokens) {
    if (isOperator(t)) {
      float b = st.pop();  // 나중에 들어간 값 = 오른쪽 피연산자
      float a = st.pop();
      if (t.equals("+")) st.push(a + b);
      else if (t.equals("-")) st.push(a - b);
      else if (t.equals("*")) st.push(a * b);
      else if (t.equals("/")) st.push(a / b);
    } else {
      st.push(value(t));
    }
  }
  return st.pop();
}
