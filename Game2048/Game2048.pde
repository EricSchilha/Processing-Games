int W = 4, H = 4;
int nScale;
int[][] arnGrid = new int[H][W]; 
color colRect, colNum;
void setup() {
  size(600, 600);
  textAlign(CENTER, CENTER);
  nScale = width/W;
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      arnGrid[j][i] = 0;
    }
  }
  newTile();
  newTile();
}

void draw() {
  background(#CCCCCC);
  drawGrid();
}

void drawGrid() {
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      switch(arnGrid[j][i]) {
      case 0:
        colRect = colNum = #FFFFFF;
        textSize(1);
        break;
      case 2:
        colRect = #E0E0E0;
        colNum = #6F6F6F;
        textSize(100);
        break;
      case 4:
        colRect = #D3CDCD;
        colNum = #484848;
        textSize(100);
        break;
      case 8:
        colRect = #FAA95D;
        colNum = #FFFFFF;
        textSize(100);
        break;
      }
      fill(colRect);
      rect(j*nScale, i*nScale, nScale, nScale);
      fill(colNum);
      text(arnGrid[j][i], (j*nScale)+(nScale/2), (i*nScale)+(nScale/2));
    }
  }
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    move("up");
  } else if (key == 'a' || key == 'A') {
    move("left");
  } else if (key == 's' || key == 'S') {
    move("down");
  } else if (key == 'd' || key == 'D') {
    move("right");
  }
}

void move(String direction) {
  ArrayList<Integer> alNewGrid = new ArrayList<Integer>();
  if (direction == "up") {
    for (int i = 0; i < H; i++) {
      for (int j = 0; j < W; j++) {
      }
    }
  } else if (direction == "left") {
    for (int i = 0; i < H; i++) {
      for (int j = 0; j < W; j++) {
        if (arnGrid[j][i]!=0) alNewGrid.add(arnGrid[j][i]);
      }
      for (int j = 0; j < W; j++) {
        if (j<alNewGrid.size()) {
          arnGrid[j][i] = alNewGrid.get(j);
        } else {
          arnGrid[j][i] = 0;
        }
      }
      alNewGrid.clear();
    }
  } else if (direction == "down") {
    for (int i = 0; i < H; i++) {
      for (int j = 0; j < W; j++) {
        if (arnGrid[j][i]!=0) alNewGrid.add(arnGrid[j][i]);
      }
      for (int j = 0; j < W; j++) {
        if (j<alNewGrid.size()) {
          arnGrid[j][i] = alNewGrid.get(j);
        } else {
          arnGrid[j][i] = 0;
        }
      }
      alNewGrid.clear();
    }
  } else {
  }
}

void combine(){
  
}

void newTile() {
  int nX, nY;
  if (isGridFull()) return;
  do {
    nX = (int)random(W);
    nY = (int)random(H);
  } while (arnGrid[nY][nX] != 0);
  arnGrid[nY][nX] = (random(3)>1)?2:4;
}

boolean isGridFull() {
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      if (arnGrid[j][i]==0) {
        return false;
      }
    }
  }
  return true;
}