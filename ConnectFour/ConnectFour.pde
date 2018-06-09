Grid board;

void setup() {
  board = new Grid(6, 7);
}

void draw() {
}


class Grid {
  int nWidth, nHeight;
  TileState[][] board;

    Grid(int nWidth, int nHeight) {
    this.nWidth = nWidth;
    this.nHeight = nHeight;
    this.board = new TileState[nHeight][nWidth];
  }
}

enum TileState {
  Blue, Red, Empty
}
