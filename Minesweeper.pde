final int X = 15, Y = 15;
int arnField[][] = new int[Y][X];//0 for unrevealed, 1 for revealed, 2 for flagged
int arnMines[][] = new int[Y][X];//0 for mine, 1-8 for # of mines nearby, 10 for blank
int nMines = X+Y;//Undecided, was originally (X+Y)/2
boolean gameOver = false, isHeld = false, drewNum = false, win = false, firstPress = true;
ArrayList<PVector> alCheckedSpots = new ArrayList<PVector>();//Using this to store all the previously checked blank spots in reveal()
void setup() {
  size(495, 495);
  init();
  textAlign(CENTER, CENTER);
}

void draw() {
  GAME();
}

void GAME() { //Main method
  background(#CCCCCC);
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
      fill(#00FF00);
      text("YOU WIN", width/2, height/2);
    } else {
      textSize(width/8);
      fill(#FF0000);
      text("YOU LOSE", width/2, height/2);
    }
  }
  if (checkWin()&&!gameOver) {
    gameOver = win = true;
  }
}

void init() { //Initializes all the mines to be randomly placed, and then sets all values for each spot based on how many mines surround it
  for (int i = 0; i < Y; i++) {
    for (int j = 0; j < X; j++) {
      arnField[i][j] = 0;
      arnMines[i][j] = 10;
    }
  }
  int nRandomMineX, nRandomMineY;
  for (int i = 0; i < nMines; i++) {
    do {
      nRandomMineX = int(random(X));
      nRandomMineY = int(random(Y));
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

void drawGrid() { //Draws the grid
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

void checkPress() { //Check which button was pressed and respond accordingly
  if (mouseButton==LEFT) {
    checkPosition(mouseX/(width/X), mouseY/(height/Y));
  } else if (mouseButton == RIGHT) {
    flag(mouseX/(width/X), mouseY/(height/Y));
  }
}

void checkPosition(int nX, int nY) {  //Check what the value at the spot clicked was and do things
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

void reveal(int nX, int nY) {//Reveal the spot that was clicked, recursively reveal all connected adjacent blank spots if the spot clicked was blank
  arnField[nY][nX] = 1;
  if (arnMines[nY][nX] == 10) {
    for (int i = nY-1; i <= nY+1; i++) {
      for (int j = nX-1; j <= nX+1; j++) {
        if (i>=0 && i<Y && j>=0 && j<X) {//Bounds checking
          if (i!=nX || j!=nY) {
            boolean alreadyChecked = false;
            for(int k = 0; k < alCheckedSpots.size(); k++){
              if(j==alCheckedSpots.get(k).x && i==alCheckedSpots.get(k).y)alreadyChecked = true;
            }
            if(!alreadyChecked){
              alCheckedSpots.add(new PVector(nX, nY));
              reveal(j, i);
            }
          }
        }
      }
    }
  }
}

void flag(int nX, int nY) { //Used to flag a square
  if (arnField[nY][nX] == 0) {
    arnField[nY][nX] = 2;
  } else if (arnField[nY][nX] == 2) {
    arnField[nY][nX] = 0;
  }
}

void setNum(int nX, int nY) { //Used to set the values in arnMines for how many nearby mines there are
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

void drawNum(int nX, int nY, int nNum) {//Draws the number on a revealed spot if there is more than 0 mines surrounding it
  fill(255);
  rect(nX*(width/X), nY*(height/Y), width/X, height/Y);
  textSize(40);
  switch(nNum) {
  case 1:
    fill(#0000FF);
    break;
  case 2:
    fill(#00FF00);
    break;
  case 3:
    fill(#FF0000);
    break;
  case 4:
    fill(#0F1490);
    break;
  case 5:
    fill(#833131);
    break;
  case 6:
    fill(#4D88A2);
    break;
  case 7:
    fill(#000000);
    break;
  case 8:
    fill(#9B9B9B);
    break;
  }
  text(nNum, nX*(width/X)+(width/X/2), nY*(height/Y)+(height/Y/2)-width/150);
}

boolean checkWin() {//Check to see if there are only mines left covered or flagged
  for (int i = 0; i < Y; i++) {
    for (int j = 0; j < X; j++) {
      if ((arnField[i][j]==0 || arnField[i][j]==2) && arnMines[i][j]!=0)return false;
    }
  }
  return true;
}