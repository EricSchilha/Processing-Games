Player player;
Level lvl1;

void setup() {
  size(900,600);
  rectMode(CORNERS);
  player = new Player();
  lvl1 = new Level();
}

void draw() {
  background(#FFFFFF);
  player.run();
  lvl1.run();
}

void keyReleased() {
  
}

class Player {
  int nWidth = 50, nHeight = 100;
  boolean isJumping = false, keyA, keyD, keySpace;
  float fX, fY, fStartY, fStartV = -7, fV, fA = 0.25, fSpeed = 2f;
  
  Player() {
    this.fX = 100;
    this.fY = height - 100 - nHeight;
  }
  
  void run() {
    update();
    draw();
  }
  
  void update() {
    if(isJumping) {
      jump();
    }
    if(keyPressed) {
      keyA = (key == 'a' || key == 'A') ? true : false;
      keyD = (key == 'd' || key == 'D') ? true : false;
      keySpace = (key == ' ') ? true : false;
      if(keyA) fX -= fSpeed;
      if(keyD) fX += fSpeed;
      if(keySpace) if(!isJumping) jump();
    }
      
  }
  
  void draw() {
    fill(#000000);
    rect(fX, fY, fX + nWidth, fY + nHeight);
  }
  
  void jump() {
    if(!isJumping) {
      fV = fStartV;
      fStartY = fY;
      isJumping = true;
    }
    fY += fV;
    fV += fA;
    if(fV > -1 && fV < 1) {
      fV += fA;
    }
    if(fY >= fStartY) {
      isJumping = false;
      fY = fStartY;
      fV = fStartV;
    }
  }
}

class Level {
  ArrayList<Wall> alWalls = new ArrayList<Wall>();
  Level() {
    createWalls();
  }
  
  void createWalls() {
    alWalls.add(new Wall(0, height - 100, width, height));
  }
  
  void run() {
    draw();
  }
  
  void draw() {
    for(Wall wall : alWalls) {
      wall.draw();
    }
  }
}

class Wall {
  int nSx, nSy, nEx, nEy; //Start (TL), End (BR)
  Wall(int nSx, int nSy, int nEx, int nEy) {
    this.nSx = nSx;
    this.nSy = nSy;
    this.nEx = nEx;
    this.nEy = nEy;
  } 
  
  void draw() {
    fill(#CCCCCC);
    rect(nSx, nSy, nEx, nEy);
  }
}
  
