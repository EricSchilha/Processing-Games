Grid grid;
void setup() {
  size(800, 800);
  grid = new Grid(10);
}

void draw() {
  grid.update();
  grid.draw();
}

class Grid {
  private int nGridSize, nScale;
  boolean[][] arbFilled, arbUncovered;
  boolean leftPress = false, rightPress = false;
  TileState[][] arTileStates;
  PVector vCurSquare = new PVector(), vPrevSquare = new PVector();
  ArrayList<Integer>[] arlTop, arlLeft;
  Grid(int nGridSize) {
    this.nGridSize = nGridSize;
    this.nScale = (int)width/nGridSize;
    init();
  }

  void init() {
    arbFilled = new boolean[nGridSize][nGridSize];
    arTileStates = new TileState[nGridSize][nGridSize];
    arlTop = new ArrayList[nGridSize];
    arlLeft = new ArrayList[nGridSize];

    for (int y = 0; y < nGridSize; y++) {
      for (int x = 0; x < nGridSize; x++) {
        arbFilled[y][x] = random(10) < 3; 
        arTileStates[y][x] = TileState.EMPTY;
      }
    }

    for (int i = 0; i < nGridSize; i++) {
      arlTop[i] = new ArrayList<Integer>();
      for (int j = 0; j < nGridSize; j++) { //Top
        int nConsecutive = j;
        while (nConsecutive < nGridSize && arbFilled[nConsecutive][i]) {
          nConsecutive++;
        }
        if (nConsecutive - j != 0) {
          arlTop[i].add(nConsecutive - j);
        }
        j = nConsecutive;
      }

      arlLeft[i] = new ArrayList<Integer>();
      for (int j = 0; j < nGridSize; j++) { //Left
      int nConsecutive = j;
        while (nConsecutive < nGridSize && arbFilled[i][nConsecutive]) {
          nConsecutive++;
        }
        if (nConsecutive - j != 0) {
          arlLeft[i].add(nConsecutive - j);
        }
        j = nConsecutive;
      }
    }
    //*
    print("\t");
    for(int i = 0; i < nGridSize; i++) {
      print(arlTop[i] + "\t");
    }
    println();
    for(int i = 0; i < nGridSize; i++) {
      println(arlLeft[i]);
    }
    /*///*/
  }

  void update() {
    vCurSquare.set(floor(mouseX/nScale), floor(mouseY/nScale));
    if (!mousePressed || !vPrevSquare.equals(vCurSquare)) leftPress = rightPress = false;
    if (mouseButton != LEFT) leftPress = false;
    if (mouseButton != RIGHT) rightPress = false;
    vPrevSquare = vCurSquare.copy();

    if (mousePressed && mouseButton == LEFT) {
      if (!leftPress) {
        try {
          arTileStates[int(mouseY/nScale)][int(mouseX/nScale)] = (arTileStates[int(mouseY/nScale)][int(mouseX/nScale)] != TileState.FILLED) ? TileState.FILLED : TileState.EMPTY;
        } 
        catch (Exception e) {
        }
        leftPress = true;
      }
    } else if (mousePressed && mouseButton == RIGHT) {
      if (!rightPress) {
        try {
          arTileStates[int(mouseY/nScale)][int(mouseX/nScale)] = (arTileStates[int(mouseY/nScale)][int(mouseX/nScale)] != TileState.MARKED) ? TileState.MARKED : TileState.EMPTY;
        } 
        catch (Exception e) {
        }
        rightPress = true;
      }
    }
  }

  void draw() {
    /*
    for (int y = 0; y < nGridSize; y++) {
      for (int x = 0; x < nGridSize; x++) {
        switch(arTileStates[y][x]) {
        case EMPTY:
          fill(245);
          break;
        case FILLED:
          fill(20);
          break;
        case MARKED:
          line(x*nScale, y*nScale, (x+1)*nScale, (y+1)*nScale);
          line(x*nScale, (y+1)*nScale, (x+1)*nScale, y*nScale);
          continue;
        }
        rect(x*nScale, y*nScale, nScale, nScale);
      }
    }
    /*/
    for (int y = 0; y < nGridSize; y++) {
      for (int x = 0; x < nGridSize; x++) {
        fill((arbFilled[y][x]) ? 20 : 245);
        rect(x*nScale, y*nScale, nScale, nScale);
      }
    }
    //*/
  }
}

enum TileState {
  FILLED, EMPTY, MARKED;
}