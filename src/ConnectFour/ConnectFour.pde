import java.util.Arrays;
Grid board;
int nTileSize, W, H;

void setup() {
  size(700, 700);
  W = 7;
  H = 6;
  nTileSize = width/W;
  board = new Grid(W, H);
  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);
}

void draw() {
  board.run();
}


class Grid {
  int nWidth, nHeight, nRedTiles, nBlueTiles, nRedWins, nBlueWins;
  TileState[][] board;
  boolean isPressed, win;
  String sWinner;
  boolean redTurn = true;


  Grid(int nWidth, int nHeight) {
    this.nWidth = nWidth;
    this.nHeight = nHeight;
    init();
  }

  void init() {
    win = false;
    isPressed = false;
    sWinner = "";
    nRedTiles = 0;
    nBlueTiles = 0;
    this.board = new TileState[nHeight][nWidth];
    for (TileState[] row : board) {
      Arrays.fill(row, TileState.Empty);
    }
  }

  void run() {
    if (win) {
      if (keyPressed && key=='r' || key== 'R') init();
      return;
    }
    update();
    win = checkWin();
    draw();
  }

  void update() {
    if (mousePressed && !isPressed) {
      isPressed = true;
      try {
        if (mouseY < height - 100) {
          int nRow = (int)Math.floor(mouseX / nTileSize);
          for (int i = board.length - 1; i >= 0; i--) {
            if (board[i][nRow] == TileState.Empty) {
              board[i][nRow] = (redTurn) ? TileState.Red : TileState.Blue;
              if (redTurn) nRedTiles++;
              else nBlueTiles++;
              redTurn = !redTurn;
              break;
            }
          }
        }
      } 
      catch (Exception e) {
      }
    } else if (!mousePressed) {
      isPressed = false;
    }
  }

  boolean checkWin() {
    TileState winColor = (!redTurn) ? TileState.Red : TileState.Blue; //!redTurn means red just went, so check for red win
    int nWinTiles = (!redTurn) ? nRedTiles : nBlueTiles, nTotal = nWinTiles, nConnected;
    if (nWinTiles < 4) return false;

    for (int y = board.length - 1; y >= 0; y--) {  //HORIZONTAL
      if (nTotal < 4) break;
      nConnected = 0;
      for (int x = 0; x < board[y].length; x++) {
        if (board[y][x] == winColor) {
          nConnected++;
          if (nConnected == 4) {
            sWinner = (!redTurn) ? "RED" : "BLUE";
            return true;
          }
        } else {
          nTotal -= nConnected;
          nConnected = 0;
        }
      }
    }

    nTotal = nWinTiles;
    for (int x = 0; x < board[0].length; x++) {  //VERTICAL
      if (nTotal < 4) break;
      nConnected = 0;
      for (int y = board.length - 1; y >= 0; y--) {
        if (board[y][x] == winColor) {
          nConnected++;
          if (nConnected == 4) {
            sWinner = (!redTurn) ? "RED" : "BLUE";
            return true;
          }
        } else {
          nTotal -= nConnected;
          nConnected = 0;
        }
      }
    }

    nTotal = nWinTiles;
    for (int x = 0; x < board[0].length - 3; x++) {  //NORTHEAST DIAGONAL
      if (nTotal < 4) break;
      nConnected = 0;
      for (int y = board.length - 1, x2 = x; y >= 0 && x2 < board[0].length; y--, x2++) {
        if (board[y][x2] == winColor) {
          nConnected++;
          if (nConnected == 4) {
            sWinner = (!redTurn) ? "RED" : "BLUE";
            return true;
          }
        } else {
          nTotal -= nConnected;
          nConnected = 0;
        }
      }
    }
    for (int y = board.length - 2; y >= 3; y--) {
      if (nTotal < 4) break;
      nConnected = 0;
      for (int y2 = y, x = 0; y2 >= 0 && x < board[0].length; y2--, x++) {
        if (board[y2][x] == winColor) {
          nConnected++;
          if (nConnected == 4) {
            sWinner = (!redTurn) ? "RED" : "BLUE";
            return true;
          }
        } else {
          nTotal -= nConnected;
          nConnected = 0;
        }
      }
    }

    nTotal = nWinTiles;
    for (int x = board[0].length - 1; x >= 3; x--) {  //NORTHWEST DIAGONAL
      if (nTotal < 4) break;
      nConnected = 0;
      for (int y = board.length - 1, x2 = x; y >= 0 && x2 >= 0; y--, x2--) {
        if (board[y][x2] == winColor) {
          nConnected++;
          if (nConnected == 4) {
            sWinner = (!redTurn) ? "RED" : "BLUE";
            return true;
          }
        } else {
          nTotal -= nConnected;
          nConnected = 0;
        }
      }
    }
    for (int y = board.length - 2; y >= 3; y--) {
      if (nTotal < 4) break;
      nConnected = 0;
      for (int y2 = y, x = board[0].length - 1; y2 >= 0 && x >= 0; y2--, x--) {
        if (board[y2][x] == winColor) {
          nConnected++;
          if (nConnected == 4) {
            sWinner = (!redTurn) ? "RED" : "BLUE";
            return true;
          }
        } else {
          nTotal -= nConnected;
          nConnected = 0;
        }
      }
    }

    return false;
  }

  void draw() {
    background(255);
    for (int y = 0; y < board.length; y++) {
      for (int x = 0; x < board[y].length; x++) {
        fill(#CCCCCC); 
        rect(x*nTileSize, y*nTileSize, nTileSize, nTileSize); 
        switch(board[y][x]) {
        case Blue : 
          fill(#1B7BF5); 
          break; 
        case Red : 
          fill(#F0453F); 
          break; 
        case Empty : 
          fill(255); 
          break;
        }
        ellipse(x*nTileSize+nTileSize/2, y*nTileSize+nTileSize/2, nTileSize * 7/8, nTileSize * 7/8);
      }
    }

    if (sWinner == "RED") {
      nRedWins++;
    } else if (sWinner == "BLUE") {
      nBlueWins++;
    }

    textSize(width/8);
    fill(#FF0000);
    text("RED:" + nRedWins, width * 1/4, height - 100/2 - 10);
    fill(#0000FF);
    text("BLUE:" + nBlueWins, width * 3/4, height - 100/2 - 10);


    if (win) {
      textSize(width/8);
      if (sWinner == "RED") {
        fill(#FF0000);
        text("RED WINS", width/2, height/2 - 100/2);
      } else if (sWinner == "BLUE") {
        fill(#0000FF);
        text("BLUE WINS", width/2, height/2 - 100/2);
      }
      textSize(width/16);
      text("Press 'R' to Restart", width/2, height/2 + height/10 - 100/2);
    }
  }
}

enum TileState {
  Blue, Red, Empty
}
