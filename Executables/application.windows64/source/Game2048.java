import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Game2048 extends PApplet {

int W = 4, H = 4;
int nTileSize;
int[][] arnGrid = new int[H][W]; 
int colRect, colNum;
boolean gameOver = false;
public void setup() {
  
  textAlign(CENTER, CENTER);
  nTileSize = width/W;
  init();
}


public void draw() {
  background(0xffCCCCCC);
  drawGrid();
  isGridFull();
  if (gameOver) {
    textSize(width/8);
    fill(20);
    text("YOU LOSE", width/2, height/2);
    textSize(width/16);
    text("Press 'R' to Restart", width/2, height/2 + height/10);
  }
}

public void init() {
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      arnGrid[j][i] = 0;
    }
  }
  newTile(2);
  newTile();
}

public void drawGrid() {
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      switch(arnGrid[j][i]) {
      case 0:
        colRect = colNum = 0xffFFFFFF;
        textSize(1);
        break;
      case 2:
        colRect = 0xffE0E0E0;
        colNum = 0xff6F6F6F;
        textSize(100);
        break;
      case 4:
        colRect = 0xffD3CDCD;
        colNum = 0xff484848;
        textSize(100);
        break;
      case 8:
        colRect = 0xffFAA95D;
        colNum = 0xffFFFFFF;
        textSize(100);
        break;
      case 16:
        colRect = 0xffEA842F;
        colNum = 0xffFFFFFF;
        textSize(100);
        break;
      case 32:
        colRect = 0xffEA5E2F;
        colNum = 0xffFFFFFF;
        textSize(100);
        break;
      case 64:
        colRect = 0xffEA2F2F;
        colNum = 0xffFFFFFF;
        textSize(100);
        break;
      case 128:
        colRect = 0xffEDE371;
        colNum = 0xffFFFFFF;
        textSize(75);
        break;
      case 256:
        colRect = 0xffF0E24B;
        colNum = 0xffFFFFFF;
        textSize(75);
        break;
      case 512:
        colRect = 0xffDED033;
        colNum = 0xffFFFFFF;
        textSize(75);
        break;
      case 1024:
        colRect = 0xffF0DC00;
        colNum = 0xffFFFFFF;
        textSize(50);
        break;
      case 2048:
        colRect = 0xffFFED24;
        colNum = 0xffFFFFFF;
        textSize(50);
        break;
      default:
        colRect = (20);
        colNum = 0xffFFFFFF;
        textSize(40);
      }
      fill(colRect);
      rect(j*nTileSize, i*nTileSize, nTileSize, nTileSize);
      fill(colNum);
      text(arnGrid[j][i], (j*nTileSize)+(nTileSize/2), (i*nTileSize)+(nTileSize/2));
    }
  }
}

public void keyPressed() {
  if (!gameOver) {
    if (key == 'w' || key == 'W' || keyCode == UP) {
      move("up");
    } else if (key == 'a' || key == 'A' || keyCode == LEFT) {
      move("left");
    } else if (key == 's' || key == 'S' || keyCode == DOWN) {
      move("down");
    } else if (key == 'd' || key == 'D' || keyCode == RIGHT) {
      move("right");
    }
  } else if (key == 'r' || key == 'R'){
    gameOver = false;
    init();
  }
}

public void move(String direction) {
  int[][] arnOldGrid = new int[H][W];
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      arnOldGrid[j][i] = arnGrid[j][i];
    }
  }
  ArrayList<Integer> alNewGrid = new ArrayList<Integer>();
  if (direction == "up") {
    for (int x = 0; x < W; x++) {
      for (int y = 0; y < H; y++) {
        if (arnGrid[x][y]!=0) alNewGrid.add(arnGrid[x][y]);
      }
      alNewGrid = combine(alNewGrid);
      for (int y = 0; y < H; y++) {
        if (y<alNewGrid.size()) {
          arnGrid[x][y] = alNewGrid.get(y);
        } else {
          arnGrid[x][y] = 0;
        }
      }
      alNewGrid.clear();
    }
  } else if (direction == "left") {
    for (int y = 0; y < H; y++) {
      for (int x = 0; x < W; x++) {
        if (arnGrid[x][y]!=0) alNewGrid.add(arnGrid[x][y]);
      }
      alNewGrid = combine(alNewGrid);
      for (int x = 0; x < W; x++) {
        if (x<alNewGrid.size()) {
          arnGrid[x][y] = alNewGrid.get(x);
        } else {
          arnGrid[x][y] = 0;
        }
      }
      alNewGrid.clear();
    }
  } else if (direction == "down") {
    for (int x = 0; x < W; x++) {
      for (int y = H - 1; y >= 0; y--) {
        if (arnGrid[x][y]!=0) alNewGrid.add(arnGrid[x][y]);
      }
      alNewGrid = combine(alNewGrid);
      for (int y = H - 1, i = 0; y >= 0; y--, i++) {
        if (i<alNewGrid.size()) {
          arnGrid[x][y] = alNewGrid.get(i);
        } else {
          arnGrid[x][y] = 0;
        }
      }
      alNewGrid.clear();
    }
  } else if (direction == "right") {
    for (int y = 0; y < H; y++) {
      for (int x = W - 1; x >= 0; x--) {
        if (arnGrid[x][y]!=0) alNewGrid.add(arnGrid[x][y]);
      }
      alNewGrid = combine(alNewGrid);
      for (int x = W - 1, i = 0; x >= 0; x--, i++) {
        if (i<alNewGrid.size()) {
          arnGrid[x][y] = alNewGrid.get(i);
        } else {
          arnGrid[x][y] = 0;
        }
      }
      alNewGrid.clear();
    }
  }
loop:
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      if (arnOldGrid[j][i] != arnGrid[j][i]) {
        newTile();
        break loop;
      }
    }
  }
}

public ArrayList<Integer> combine(ArrayList<Integer> alGrid) {
  for (int i = 0; i < alGrid.size(); i++) {
    try {
      int nNum = alGrid.get(i); //comparing Integers doesn't appear to work when the number is larger than 64?
      if (nNum==alGrid.get(i-1)) {
        alGrid.set(i, alGrid.get(i)*2);
        alGrid.remove(i-1);
        continue;
        //we don't subtract 1 from i because we want to skip the next one
      }
    }
    catch(Exception e) {
    }
  }

  return alGrid;
}

public void newTile() {
  int nX, nY;
  if (isGridFull()) return;
  do {
    nX = (int)random(W);
    nY = (int)random(H);
  } while (arnGrid[nY][nX] != 0);
  arnGrid[nY][nX] = (random(3)>1)?2:4;
}

public void newTile(int nNum) {
  int nX, nY;
  if (isGridFull()) return;
  do {
    nX = (int)random(W);
    nY = (int)random(H);
  } while (arnGrid[nY][nX] != 0);
  arnGrid[nY][nX] = nNum;
}

public boolean isGridFull() {
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      if (arnGrid[j][i]==0) {
        return false;
      }
    }
  }
  gameOver = canMove();
  return true;
}

public boolean canMove() {
  int nNum;
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      nNum = arnGrid[i][j];
      try {
        if (nNum == arnGrid[i-1][j]) return false;
      } 
      catch (Exception e) {
      }
      try {
        if (nNum == arnGrid[i][j-1]) return false;
      } 
      catch (Exception e) {
      }
    }
  }
  return true;
}
  public void settings() {  size(495, 495); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Game2048" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
