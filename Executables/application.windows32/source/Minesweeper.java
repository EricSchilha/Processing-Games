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

public class Minesweeper extends PApplet {

final int X = 15, Y = 15;
int arnField[][] = new int[Y][X];//0 for unrevealed, 1 for revealed, 2 for flagged
int arnMines[][] = new int[Y][X];//0 for mine, 1-8 for # of mines nearby, 10 for blank
int nMines = X+Y;//Undecided, was originally (X+Y)/2
boolean gameOver = false, isHeld = false, drewNum = false, win = false, firstPress = true;
ArrayList<PVector> alCheckedSpots = new ArrayList<PVector>();//Using this to store all the previously checked blank spots in reveal()
public void setup() {
  
  init();
  textAlign(CENTER, CENTER);
}

public void draw() {
  GAME();
}

public void GAME() { //Main method
  background(0xffCCCCCC);
  drawGrid();
  if (mousePressed && !isHeld && !gameOver) {
    checkPress();
    isHeld = true;
  } else if (!mousePressed) {
    isHeld = false;
  }
  if (gameOver) {
    if (win) {
      textSize(width/8);
      fill(0xff00FF00);
      text("YOU WIN", width/2, height/2);
      textSize(width/16);
      text("Press 'R' to Restart", width/2, height/2 + height/10);
    } else {
      textSize(width/8);
      fill(0xffFF0000);
      text("YOU LOSE", width/2, height/2);
      textSize(width/16);
      text("Press 'R' to Restart", width/2, height/2 + height/10);
    }
    if (keyPressed && (key == 'r' || key == 'R')) {
      init();
      gameOver = false;
      win = false;
    }
  }
  if (checkWin()&&!gameOver) {
    gameOver = win = true;
  }
}

public void init() { //Initializes all the mines to be randomly placed, and then sets all values for each spot based on how many mines surround it
  gameOver = false;
  isHeld = false;
  drewNum = false;
  win = false;
  firstPress = true;
  alCheckedSpots.clear();
  for (int i = 0; i < Y; i++) {
    for (int j = 0; j < X; j++) {
      arnField[i][j] = 0;
      arnMines[i][j] = 10;
    }
  }
  int nRandomMineX, nRandomMineY;
  for (int i = 0; i < nMines; i++) {
    do {
      nRandomMineX = PApplet.parseInt(random(X));
      nRandomMineY = PApplet.parseInt(random(Y));
    } while (arnMines[nRandomMineY][nRandomMineX] == 0);
    arnMines[nRandomMineY][nRandomMineX] = 0;
  }
  for (int i = 0; i < Y; i++) {
    for (int j = 0; j < X; j++) {
      if (arnMines[i][j]!=0) {
        setNum(j, i);
      }
    }
  }
}

public void drawGrid() { //Draws the grid
  for (int i = 0; i < Y; i++) {
    for (int j = 0; j < X; j++) {
      drewNum = false;
      switch(arnField[i][j]) {
      case 0:
        fill(200);
        rect(j*(width/X), i*(height/Y), width/X, height/Y);
        break;
      case 1:
        switch(arnMines[i][j]) {
        case 0:
          fill(0);
          break;
        case 10:
          fill(255);
          break;
        default:
          drawNum(j, i, arnMines[i][j]);
          drewNum = true;
          break;
        }
        break;
      case 2:
        fill(255, 0, 0);
      }
      if (!drewNum)
        rect(j*(width/X), i*(height/Y), width/X, height/Y);
    }
  }
}

public void checkPress() { //Check which button was pressed and respond accordingly
  if (mouseButton==LEFT) {
    checkPosition(mouseX/(width/X), mouseY/(height/Y));
  } else if (mouseButton == RIGHT) {
    flag(mouseX/(width/X), mouseY/(height/Y));
  }
}

public void checkPosition(int nX, int nY) {  //Check what the value at the spot clicked was and do things
  if (firstPress) {
    while (arnMines[nY][nX]!=10) {
      init();//Keep repositioning mines to guaruntee first click is safe
    }
    firstPress = false;
  }
  if (arnMines[nY][nX] == 0) {
    gameOver = true;
    for (int i = 0; i < Y; i++) {
      for (int j = 0; j < X; j++) {
        if (arnMines[i][j] == 0)arnField[i][j] = 1;//Reveals all the mines
      }
    }
  } else {
    reveal(nX, nY);
  }
}

public void reveal(int nX, int nY) {//Reveal the spot that was clicked, recursively reveal all connected adjacent blank spots if the spot clicked was blank
  arnField[nY][nX] = 1;
  if (arnMines[nY][nX] == 10) {
    for (int i = nY-1; i <= nY+1; i++) {
      for (int j = nX-1; j <= nX+1; j++) {
        if (i>=0 && i<Y && j>=0 && j<X) {//Bounds checking
          if (i!=nX || j!=nY) {
            boolean alreadyChecked = false;
            for (int k = 0; k < alCheckedSpots.size(); k++) {
              if (j==alCheckedSpots.get(k).x && i==alCheckedSpots.get(k).y)alreadyChecked = true;
            }
            if (!alreadyChecked) {
              alCheckedSpots.add(new PVector(nX, nY));
              reveal(j, i);
            }
          }
        }
      }
    }
  }
}

public void flag(int nX, int nY) { //Used to flag a square
  if (arnField[nY][nX] == 0) {
    arnField[nY][nX] = 2;
  } else if (arnField[nY][nX] == 2) {
    arnField[nY][nX] = 0;
  }
}

public void setNum(int nX, int nY) { //Used to set the values in arnMines for how many nearby mines there are
  int nNearbyMines = 0;
  if (nX>0&&nX<X-1&&nY>0&&nY<Y-1) {//Middle
    if (arnMines[nY-1][nX-1]==0)nNearbyMines++;
    if (arnMines[nY-1][nX]==0)nNearbyMines++;
    if (arnMines[nY-1][nX+1]==0)nNearbyMines++;
    if (arnMines[nY][nX-1]==0)nNearbyMines++;
    if (arnMines[nY][nX+1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX-1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX]==0)nNearbyMines++;
    if (arnMines[nY+1][nX+1]==0)nNearbyMines++;
  } else if (nX>0&&nY>0&&nY<Y-1) {//Right Middle
    if (arnMines[nY-1][nX-1]==0)nNearbyMines++;
    if (arnMines[nY-1][nX]==0)nNearbyMines++;
    if (arnMines[nY][nX-1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX-1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX]==0)nNearbyMines++;
  } else if (nX<X-1&&nY>0&&nY<Y-1) {//Left Middle
    if (arnMines[nY-1][nX]==0)nNearbyMines++;
    if (arnMines[nY-1][nX+1]==0)nNearbyMines++;
    if (arnMines[nY][nX+1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX]==0)nNearbyMines++;
    if (arnMines[nY+1][nX+1]==0)nNearbyMines++;
  } else if (nX>0&&nX<X-1&&nY>0) {//Bottom Middle
    if (arnMines[nY-1][nX-1]==0)nNearbyMines++;
    if (arnMines[nY-1][nX]==0)nNearbyMines++;
    if (arnMines[nY-1][nX+1]==0)nNearbyMines++;
    if (arnMines[nY][nX-1]==0)nNearbyMines++;
    if (arnMines[nY][nX+1]==0)nNearbyMines++;
  } else if (nX>0&&nX<X-1&&nY<Y-1) {//Top Middle
    if (arnMines[nY][nX-1]==0)nNearbyMines++;
    if (arnMines[nY][nX+1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX-1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX]==0)nNearbyMines++;
    if (arnMines[nY+1][nX+1]==0)nNearbyMines++;
  } else if (nX>0&&nY>0) {//Bottom Right
    if (arnMines[nY-1][nX-1]==0)nNearbyMines++;
    if (arnMines[nY-1][nX]==0)nNearbyMines++;
    if (arnMines[nY][nX-1]==0)nNearbyMines++;
  } else if (nX>0&&nY<Y-1) {//Top Right
    if (arnMines[nY][nX-1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX-1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX]==0)nNearbyMines++;
  } else if (nX<X-1&&nY>0) {//Bottom Left
    if (arnMines[nY-1][nX]==0)nNearbyMines++;
    if (arnMines[nY-1][nX+1]==0)nNearbyMines++;
    if (arnMines[nY][nX+1]==0)nNearbyMines++;
  } else if (nX<X-1&&nY<Y-1) {//Top Left
    if (arnMines[nY][nX+1]==0)nNearbyMines++;
    if (arnMines[nY+1][nX]==0)nNearbyMines++;
    if (arnMines[nY+1][nX+1]==0)nNearbyMines++;
  }
  if (nNearbyMines>0)arnMines[nY][nX]=nNearbyMines;
}

public void drawNum(int nX, int nY, int nNum) {//Draws the number on a revealed spot if there is more than 0 mines surrounding it
  fill(255);
  rect(nX*(width/X), nY*(height/Y), width/X, height/Y);
  textSize(40);
  switch(nNum) {
  case 1:
    fill(0xff0000FF);
    break;
  case 2:
    fill(0xff00FF00);
    break;
  case 3:
    fill(0xffFF0000);
    break;
  case 4:
    fill(0xff0F1490);
    break;
  case 5:
    fill(0xff833131);
    break;
  case 6:
    fill(0xff4D88A2);
    break;
  case 7:
    fill(0xff000000);
    break;
  case 8:
    fill(0xff9B9B9B);
    break;
  }
  text(nNum, nX*(width/X)+(width/X/2), nY*(height/Y)+(height/Y/2)-width/150);
}

public boolean checkWin() {//Check to see if there are only mines left covered or flagged
  for (int i = 0; i < Y; i++) {
    for (int j = 0; j < X; j++) {
      if ((arnField[i][j]==0 || arnField[i][j]==2) && arnMines[i][j]!=0)return false;
    }
  }
  return true;
}
  public void settings() {  size(495, 495); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Minesweeper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
