int nTileSize, nFoodX, nFoodY, nDx, nDy, nDelayMovement, nGamePace, nStartPace, nDifficulty, nCurDir;
final int W = 25, H = 25;
int[][] arnMap = new int[W][H];
boolean gameOver = false, hasMoved = true;
ArrayList<PVector> alvSnake = new ArrayList<PVector>();
PVector vPrevSpot = new PVector();
void setup() {
  //fullScreen();
  textAlign(CENTER, CENTER);
  alvSnake.add(new PVector(W / 2, H / 2));
  nDifficulty = 30;
  nStartPace = 3;
  nGamePace = nStartPace;
  size(800, 800);
  nDx = 0;
  nDy = 0;
  nDelayMovement = 0;
  nTileSize = width/W;
  nFoodX = (int)random(W);
  nFoodY = (int)random(H);
  while (nFoodX == alvSnake.get(0).x && nFoodY == alvSnake.get(0).y) {
    nFoodX = (int)random(W);
    nFoodY = (int)random(H);
  }
  strokeWeight((float)nTileSize/80);
  stroke(255);
}


void draw() {
  background(20);

  //Draw the Horizontal Lines
  for (int i = 0; i < W; i++) {
    line(0, i*nTileSize, width, i*nTileSize);
  }

  //Draw the Vertical Lines
  for (int ii = 0; ii < H; ii++) {
    line(ii*nTileSize, 0, ii*nTileSize, height);
  }

  //Draw Each Snake Rectangle
  fill(#00FF00);
  for (int i = 0; i < alvSnake.size(); i++) {
    rect(alvSnake.get(i).x * nTileSize, alvSnake.get(i).y * nTileSize, nTileSize, nTileSize);
  }

  //Draw the Food Rectangle
  fill(#FF0000);
  rect(nFoodX * nTileSize, nFoodY * nTileSize, nTileSize, nTileSize);

  if (!gameOver)gameOver = isGameOver();
  if (!gameOver) {
    if (nDelayMovement >= nDifficulty/nGamePace) {
      nDelayMovement = 0;
      vPrevSpot.x = alvSnake.get(alvSnake.size()-1).x;
      vPrevSpot.y = alvSnake.get(alvSnake.size()-1).y;
      for (int i = alvSnake.size() - 1; i >= 0; i--) {
        if (i != 0) {
          alvSnake.get(i).x=alvSnake.get(i-1).x;
          alvSnake.get(i).y=alvSnake.get(i-1).y;
        } else {
          alvSnake.get(i).x+=nDx;
          alvSnake.get(i).y+=nDy;
          
        }
      }
      hasMoved = true;
    } else {
      nDelayMovement++;
    }

    for (int i = 0; i < alvSnake.size(); i++) {
      if (nFoodX == alvSnake.get(i).x && nFoodY == alvSnake.get(i).y) {
        alvSnake.add(new PVector(vPrevSpot.x, vPrevSpot.y));
        if (nGamePace < nDifficulty/2) {
          nGamePace++;
        }
        for (int ii = 0; ii < alvSnake.size(); ii++) {
          nFoodX = (int)random(W);
          nFoodY = (int)random(H);
          if (nFoodX == alvSnake.get(ii).x && nFoodY == alvSnake.get(ii).y)ii = 0;
        }
        break;
      }
    }
  } else {
    textSize(width/8);
      fill(#FF0000);
      text("YOU LOSE", width/2, height/2);
      textSize(width/16);
      text("Press 'R' to Restart", width/2, height/2 + height/10);
    if (keyPressed && (key == 'r' || key == 'R')) {
      gameOver = false;
      nGamePace = nStartPace;
      nDx = nDy = 0;
    }
  }
}

void keyPressed() {
  if(hasMoved){
    if (keyCode == UP && nCurDir != 40) {
      nDx = nDy = 0;
      nDy = -1;
    } else if (keyCode == DOWN && nCurDir != 38) {
      nDx = nDy = 0;
      nDy = 1;
    } else if (keyCode == LEFT && nCurDir != 39) {
      nDx = nDy = 0;
      nDx = -1;
    } else if (keyCode == RIGHT && nCurDir != 37) {
      nDx = nDy = 0;
      nDx = 1;
    } else {
      return;
    }
    hasMoved = false;
  }
  nCurDir = keyCode;
}

boolean isGameOver() {
  for (int i = 0; i < alvSnake.size(); i++) {
    for (int ii = 0; ii < alvSnake.size(); ii++) {
      if (i == ii) continue;
      if (alvSnake.get(i).x == alvSnake.get(ii).x && alvSnake.get(i).y == alvSnake.get(ii).y) {
        alvSnake.clear();
        alvSnake.add(new PVector(W/2, H/2));
        return true;
      }
    }
  }
  if (alvSnake.get(0).x >= W || alvSnake.get(0).x < 0 || alvSnake.get(0).y >= H || alvSnake.get(0).y < 0) {
    alvSnake.clear();
    alvSnake.add(new PVector(W/2, H/2));
    return true;
  }

  return false;
}