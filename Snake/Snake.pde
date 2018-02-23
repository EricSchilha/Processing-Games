int nTileSize, nFoodX, nFoodY, nDx, nDy, nDelayMovement, nGamePace;
final int W = 100, H = 100;
int[][] arnMap = new int[W][H];
boolean gameOver = false;
ArrayList<PVector> alvSnake = new ArrayList<PVector>();
PVector vPrevSpot = new PVector();
void setup() {
  //fullScreen();
  alvSnake.add(new PVector(W / 2, H / 2));
  nGamePace = 1;
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
  strokeWeight(0.5);
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
    if (nDelayMovement >= nGamePace) {
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
    } else {
      nDelayMovement++;
    }
    
    for (int i = 0; i < alvSnake.size(); i++) {
      if (nFoodX == alvSnake.get(i).x && nFoodY == alvSnake.get(i).y) {
        alvSnake.add(new PVector(vPrevSpot.x, vPrevSpot.y));
        if (nGamePace >= 1) {
          nGamePace--;
        }
        for (int ii = 0; ii < alvSnake.size(); ii++) {
          nFoodX = (int)random(W);
          nFoodY = (int)random(H);
          if (nFoodX == alvSnake.get(ii).x && nFoodY == alvSnake.get(ii).y)ii = 0;
        }
        break;
      }
    }

    if (keyPressed) {
      if (keyCode == UP) {
        nDx = nDy = 0;
        nDy = -1;
      } else if (keyCode == DOWN) {
        nDx = nDy = 0;
        nDy = 1;
      } else if (keyCode == LEFT) {
        nDx = nDy = 0;
        nDx = -1;
      } else if (keyCode == RIGHT) {
        nDx = nDy = 0;
        nDx = 1;
      }
    }
  } else {
    if(mousePressed)gameOver = false;
  }
}


boolean isGameOver() {
  for (int i = 0; i < alvSnake.size(); i++) {
    for (int ii = 0; ii < alvSnake.size(); ii++) {
      if (i != ii) {
        if (alvSnake.get(i).x == alvSnake.get(ii).x && alvSnake.get(i).y == alvSnake.get(ii).y) {
          alvSnake.clear();
          alvSnake.add(new PVector(W/2, H/2));
          return true;
        }
      }
    }
  }
  if (alvSnake.get(0).x > W || alvSnake.get(0).x < 0 || alvSnake.get(0).y > H || alvSnake.get(0).y < 0) {
    alvSnake.clear();
    alvSnake.add(new PVector(W/2, H/2));
    return true;
  }

  return false;
}