int  n=8; //<>//
int  xstep=400;
int  ystep=50;
int  radius=30;
int  mode=0;
int  traversal=0;
int  textcolor=0;
PFont font;

String numBuf = "";
int    searchKey = -1;
boolean searchFound = false;
ArrayList<Integer> searchPath = new ArrayList<Integer>();
String traversalResult = "";

BTree tree = new BTree();
 
void setup() {
  size(1200, 600);
  
  font = createFont("Arial", 16);
  textFont(font, 16);
  textAlign(LEFT, CENTER);
  stroke(192, 0, 0);
  newTree();
}

void mousePressed() {
  if(mouseButton == LEFT) {
    clearSearch();
    if(tree.value == -1) {
      int x=(int)(100.*mouseX/width);
      tree.insert(x);
      fill(255);
      ellipse(32, 32, radius, radius);
      fill(0);
      text(x, 32, 32);
    }  
    else {
      tree.remove(tree.value);
      fill(255);
      ellipse(32, 32, radius, radius);
      fill(0);
      text(tree.value, 32, 32);
    }  
  } 
}

void mouseReleased() {
  drawTree();
}

void mouseMoved() {
  tree.findNode();
  if(tree.value != -1) {
    fill(92);
    ellipse(tree.x, tree.y, radius, radius);
    fill(0);
    text(tree.value, tree.x, tree.y);
  } 
  else drawTree();
}

int getInputKey() {
  int k;
  if(numBuf.length() > 0) k = Integer.parseInt(numBuf);
  else k = (int)(100.*mouseX/width);
  numBuf = "";
  return k;
}

void clearSearch() {
  searchKey = -1;
  searchFound = false;
  searchPath.clear();
  traversalResult = "";
}

void keyPressed() {
  if(key=='c') {
    background(200);
    tree.clear();
    clearSearch();
  }
  else if(key=='v' || key ==' ') { 
    drawTree();
    tree.printTree();
  }  
  else if(key=='b') {  
    clearSearch();
    newTree();
  }  
  else if(key=='t') {  
    traversal++;
    if(traversal==3) traversal=0;
    drawTree();
    tree.printTree();
  }  
  else if(key=='d') {  
    if(textcolor==0) textcolor=1;
    else textcolor=0;
    drawTree();
  }
  else if(key>='0' && key<='9') {
    if(numBuf.length() < 2) numBuf += key;
    drawTree();
  }
  else if(key==BACKSPACE) {
    if(numBuf.length() > 0) numBuf = numBuf.substring(0, numBuf.length()-1);
    drawTree();
  }
  else if(key=='i') {
    int k = getInputKey();
    clearSearch();
    if(tree.insert(k)) println("insert " + k);
    else println("insert " + k + " : already exists");
    drawTree();
  }
  else if(key=='x') {
    int k = getInputKey();
    clearSearch();
    if(tree.contains(k)) {
      tree.remove(k);
      println("delete " + k);
    }
    else println("delete " + k + " : not found");
    drawTree();
  }
  else if(key=='s') {
    int k = getInputKey();
    tree.search(k);
    drawTree();
  }
}

void newTree() {
  tree.clear();
  for(int i=0; i<n; i++) 
    tree.insert((int)random(99));
  drawTree();
}
 
void draw() {
}

void drawMode() {
  int x=20, y=50;
  textFont(font, 24);
  textAlign(LEFT, CENTER);
  noStroke();
  fill(132);
  rect(10, height-y-12, 132, 26);
  fill(0);
  if(traversal==0) text("inorder(t)", x, height-y);
  else if(traversal==1) text("preorder(t)", x, height-y);
  else if(traversal==2) text("postorder(t)", x, height-y);

  String in = numBuf.length() > 0 ? numBuf : str((int)(100.*mouseX/width));
  text("key: " + in + "   (0-9 type, i:insert  x:delete  s:search)", x+140, height-y);
  text("clear:c  new tree:b  traverse:v or space  mode:t", x, height-24);

  if(searchKey != -1) {
    if(searchFound) fill(0, 130, 0);
    else fill(200, 0, 0);
    text("search " + searchKey + (searchFound ? " : FOUND" : " : NOT FOUND") + "   path: " + searchPath, x, height-y-40);
  }
  if(traversalResult.length() > 0) {
    fill(0, 0, 255);
    text(traversalResult, x, height-y-70);
  }

  stroke(192, 0, 0);
  textFont(font, 16);
  textAlign(CENTER, CENTER);
}

void drawTree() {
  background(200);
  tree.assignPosition();
  tree.drawTree();  
  drawMode();
}

class BTree {
  Node root;
  int  x, y, value, index;
   
  void clear() {
    root = null;
  }
 
  boolean contains(int in) {
    return contains(in, root);
  }

  boolean contains(int in, Node curr) {
    if (curr == null) return false;
    if (in < curr.val) return contains(in, curr.left);
    else if (in > curr.val) return contains(in, curr.right);
    else return true;
  }

  boolean search(int k) {
    searchPath.clear();
    searchKey = k;
    Node y = root;
    while (y != null) {
      searchPath.add(y.val);
      if (y.val == k) {
        searchFound = true;
        println("search " + k + " : found, path " + searchPath);
        return true;
      }
      else if (y.val < k) y = y.right;
      else y = y.left;
    }
    searchFound = false;
    println("search " + k + " : not found, path " + searchPath);
    return false;
  }
 
  int findMax() {
    if (isEmpty()) {
      println("The tree was empty! Returning 0 to avoid an error");
      return 0;
    }
    else return findMax(root).val;
  }

  Node findMax(Node curr) {
    if (curr == null) return null;
    else if (curr.right == null) return curr;
    return findMax(curr.right);
  }
 
  int findMin() {
    if (isEmpty()) {
      println("The tree was empty! Returning 0 to avoid an error");
      return 0;
    }
    else return findMin(root).val;
  }

  Node findMin(Node curr) {
    if (curr == null) return null;
    else if (curr.left == null) return curr;
    return findMin(curr.left);
  }
   
  int treeHeight() {
    return treeHeight(root);
  }

  int treeHeight(Node curr) {
    if (curr == null) return -1;
    else return 1+max(treeHeight(curr.left), treeHeight(curr.right));
  }
 
  boolean isEmpty() {
    return root == null;
  }
 
  boolean insert(int in) {
    Node r = insert(in, root);
    if (r == null) return false;
    root = r;
    return true;
  }

  Node insert(int in, Node curr) {
    if (curr == null) return new Node(in);
    Node res = null;
    if (in < curr.val) {
      res = insert(in, curr.left);
      if (res != null)
        curr.left = res;
    }
    else if (in > curr.val) {
      res = insert(in, curr.right);
      if (res != null)
        curr.right = res;
    }
    return res == null ? null : curr;
  }
  
  void remove(int in) {
    root = remove(in, root);
  }

  Node remove(int in, Node curr) {
    if (curr == null) return curr;
    if (in < curr.val) curr.left = remove(in, curr.left);
    else if (in > curr.val) curr.right = remove(in, curr.right);
    else if (curr.left != null && curr.right != null) {
      curr.val = findMin(curr.right).val;
      curr.right = remove(curr.val, curr.right);
    }
    else curr = (curr.left != null) ? curr.left:curr.right;
    return curr;
  }

  void assignPosition() {
    if (!isEmpty()) assignPosition(root, 0, 0);
  }

  void assignPosition(Node curr, float dx, float dy) {
    if (curr != null) {
      assignPosition(curr.left, dx-1./pow(2.,(dy+1.)), dy+1);
      curr.x=dx;
      curr.y=dy;
      assignPosition(curr.right, dx+1./pow(2.,(dy+1.)), dy+1);
    }
  }

  void printTree() {
    index=0;
    if (traversal==0) traversalResult = "inorder: ";
    else if (traversal==1) traversalResult = "preorder: ";
    else traversalResult = "postorder: ";

    if (isEmpty()) println("The tree is empty");
    else {
      fill(0,0,255);
      printTree(root);
      println(traversalResult);
      drawMode();
    }
  }

  void printTree(Node curr) {
    if (curr == null) return;
    if (traversal == 1) visit(curr);
    printTree(curr.left);
    if (traversal == 0) visit(curr);
    printTree(curr.right);
    if (traversal == 2) visit(curr);
  }

  void visit(Node curr) {
    println(curr.val+" "+index+" ("+curr.x+","+curr.y+")");
    fill(0,0,255);
    text(index, (int)(curr.x*xstep+width/2-radius/2-2), 
      (int)(curr.y*ystep+radius-radius/2-2));
    traversalResult += curr.val + " ";
    index++;
  }

  void findNode() {
    x = y = value = -1;
    if (isEmpty()) return;
    else findNode(root);
  }

  void findNode(Node curr) {
    if (curr != null) {
      findNode(curr.left);
      int dx=mouseX-(int)(curr.x*xstep+width/2);
      int dy=mouseY-(int)(curr.y*ystep+radius);
      if((dx*dx+dy*dy)<radius*radius/4) {
        x=(int)(curr.x*xstep+width/2);
        y=(int)(curr.y*ystep+radius);
        value=curr.val;
        return;
      }  
      findNode(curr.right);
    }
  }

  void drawTree() {
    if (isEmpty()) println("The tree is empty");
    else {
      drawTreeLine(root);
      drawTree(root);
    }    
  }

  void drawTreeLine(Node curr) {
    if (curr != null) {
      drawTreeLine(curr.left);
      if(curr.left != null) line((int)(curr.x*xstep+width/2), (int)(curr.y*ystep+radius),
        (int)(curr.left.x*xstep+width/2), (int)(curr.left.y*ystep+radius));
      if(curr.right != null) line((int)(curr.x*xstep+width/2), (int)(curr.y*ystep+radius),
        (int)(curr.right.x*xstep+width/2), (int)(curr.right.y*ystep+radius));
      drawTreeLine(curr.right);
    }
  }

  void drawTree(Node curr) {
    if (curr != null) {
      drawTree(curr.left);
      if (searchFound && curr.val == searchKey) fill(80, 220, 80);
      else if (searchPath.contains(curr.val)) fill(255, 190, 60);
      else fill(255);
      ellipse(curr.x*xstep+width/2, curr.y*ystep+radius, radius, radius);
      if(textcolor==0) fill(0);
      else fill(255);
      text(curr.val, (int)(curr.x*xstep+width/2), (int)(curr.y*ystep+radius));
      drawTree(curr.right);
    }
  }
}
 
class Node {
  int   val;
  float x, y;
  Node left;
  Node right;
  Node(int v) {
    val = v;
  }

  Node(int v, Node l, Node r) {
    val = v;
    left = l;
    right = r;
  }

  public String toString() {
    if (left == null && right == null) return "N(" + val + ")";
    return "N(" + val + ", " + left + ", " + right + ")";
  }
}
