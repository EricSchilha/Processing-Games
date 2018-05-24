Grid grid;
void setup() {
  size(800, 800);
  surface.setResizable(true);
  grid = new Grid(10);
}

void draw() {
  background(255);
  grid.update();
  grid.draw();
}

class Grid {
  private int nGridSize, nTileSize;
  boolean[][] arbFilled, arbUncovered;
  boolean leftPress = false, rightPress = false;
  TileState[][] arTileStates;
  PVector vCurSquare = new PVector(), vPrevSquare = new PVector();
  ArrayList<Integer>[] arlTop, arlLeft;
  Grid(int nGridSize) {
    this.nGridSize = nGridSize;
    this.nTileSize = (int)width/(nGridSize+1);
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
    vCurSquare.set(floor(mouseX/nTileSize), floor(mouseY/nTileSize));
    if (!mousePressed || !vPrevSquare.equals(vCurSquare)) leftPress = rightPress = false;
    if (mouseButton != LEFT) leftPress = false;
    if (mouseButton != RIGHT) rightPress = false;
    vPrevSquare = vCurSquare.copy();

    if (mousePressed && mouseButton == LEFT) {
      if (!leftPress) {
        try {
          arTileStates[int(mouseY/nTileSize)][int(mouseX/nTileSize)] = (arTileStates[int(mouseY/nTileSize)][int(mouseX/nTileSize)] == TileState.FILLED) ? TileState.EMPTY : TileState.FILLED;
        } 
        catch (Exception e) {
        }
        leftPress = true;
      }
    } else if (mousePressed && mouseButton == RIGHT) {
      if (!rightPress) {
        try {
          arTileStates[int(mouseY/nTileSize)][int(mouseX/nTileSize)] = (arTileStates[int(mouseY/nTileSize)][int(mouseX/nTileSize)] == TileState.MARKED) ? TileState.EMPTY : TileState.MARKED;
        } 
        catch (Exception e) {
        }
        rightPress = true;
      }
    }
  }

  void draw() {
    //*
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
          fill(245);
          rect(x*nTileSize, y*nTileSize, nTileSize, nTileSize);
          line(x*nTileSize, y*nTileSize, (x+1)*nTileSize, (y+1)*nTileSize);
          line(x*nTileSize, (y+1)*nTileSize, (x+1)*nTileSize, y*nTileSize);
          continue;
        }
        rect(x*nTileSize, y*nTileSize, nTileSize, nTileSize);
      }
    }
    /*/
    for (int y = 0; y < nGridSize; y++) {
      for (int x = 0; x < nGridSize; x++) {
        fill((arbFilled[y][x]) ? 20 : 245);
        rect(x*nTileSize, y*nTileSize, nTileSize, nTileSize);
      }
    }
    //*/
  }
}

enum TileState {
  FILLED, EMPTY, MARKED;
}