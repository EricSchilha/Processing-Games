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

public class Picross extends PApplet {

Grid grid;
public void setup() {
  
  surface.setResizable(true);
  grid = new Grid(10);
  textAlign(CENTER, CENTER);
}

public void draw() {
  background(255);
  grid.update();
  grid.draw();
}

class Grid {
  private int nGridSize, nTileSize;
  float fTextSize, fSideTiles;
  boolean[][] arbFilled;
  boolean leftPress = false, rightPress = false, isWon;
  TileState[][] arTileStates;
  PVector vCurSquare = new PVector(), vPrevSquare = new PVector();
  ArrayList<Integer>[] arlTop, arlLeft;
  Grid(int nGridSize) {
    this.nGridSize = nGridSize;
    init();
  }

  public void init() {
    fSideTiles = 1.5f;
    isWon = false;
    nTileSize = (int)(width/(nGridSize+fSideTiles));
    arbFilled = new boolean[nGridSize][nGridSize];
    arTileStates = new TileState[nGridSize][nGridSize];
    arlTop = new ArrayList[nGridSize];
    arlLeft = new ArrayList[nGridSize];
    fTextSize = (fSideTiles*nTileSize/ceil(nGridSize/2)/1.5f);
    textSize(fTextSize);

    for (int y = 0; y < nGridSize; y++) {
      for (int x = 0; x < nGridSize; x++) {
        //*
        arbFilled[y][x] = random(10) < 5; 
        /*/
        arbFilled[y][x] = (y%2==0 && x%2 != 0) || x%2 == 0 && y%2!= 0) ? true : false; 
        //*/
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
    /*
    print("\t");
    for (int i = 0; i < nGridSize; i++) {
      print(arlTop[i] + "\t");
    }
    println();
    for (int i = 0; i < nGridSize; i++) {
      println(arlLeft[i]);
    }
    /*///*/
  }

  public void update() {
      vCurSquare.set(floor((mouseX - fSideTiles * nTileSize)/nTileSize), floor((mouseY - fSideTiles * nTileSize)/nTileSize));
      if (!mousePressed || !vPrevSquare.equals(vCurSquare)) leftPress = rightPress = false;
      if (mouseButton != LEFT) leftPress = false;
      if (mouseButton != RIGHT) rightPress = false;
      vPrevSquare = vCurSquare.copy();

    if (mousePressed && mouseButton == LEFT && mouseX < fSideTiles * nTileSize && mouseY < fSideTiles * nTileSize && !leftPress) {
      init();
      leftPress = true;
    }
    if (!isWon)
      isWon = checkWin();
    if (!isWon) {
      if (mousePressed && mouseButton == LEFT) {
        if (!leftPress) {
          try {
            arTileStates[(int)vCurSquare.y][(int)vCurSquare.x] = (arTileStates[(int)vCurSquare.y][(int)vCurSquare.x] == TileState.FILLED) ? TileState.EMPTY : TileState.FILLED;
          } 
          catch (Exception e) {
          }
          leftPress = true;
        }
      } else if (mousePressed && mouseButton == RIGHT) {
        if (!rightPress) {
          try {
            arTileStates[(int)vCurSquare.y][(int)vCurSquare.x] = (arTileStates[(int)vCurSquare.y][(int)vCurSquare.x] == TileState.MARKED) ? TileState.EMPTY : TileState.MARKED;
          } 
          catch (Exception e) {
          }
          rightPress = true;
        }
      }
    }
    if (keyPressed && isWon) {
      if(key == 'r' || key == 'R') {
        init();
      }
    }
  }

  public void draw() {
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
          rect((x+fSideTiles)*nTileSize, (y+fSideTiles)*nTileSize, nTileSize, nTileSize);
          line((x+fSideTiles)*nTileSize, (y+fSideTiles)*nTileSize, (x+fSideTiles+1)*nTileSize, (y+fSideTiles+1)*nTileSize);
          line((x+fSideTiles)*nTileSize, (y+fSideTiles+1)*nTileSize, (x+fSideTiles+1)*nTileSize, (y+fSideTiles)*nTileSize);
          continue;
        }
        rect((x+fSideTiles)*nTileSize, (y+fSideTiles)*nTileSize, nTileSize, nTileSize);
      }
    }
    /*/
     for (int y = 0; y < nGridSize; y++) {
     for (int x = 0; x < nGridSize; x++) {
     fill((arbFilled[y][x]) ? 20 : 245);
     rect((x+fSideTiles)*nTileSize + fSideTiles, (y+fSideTiles)*nTileSize, nTileSize, nTileSize);
     }
     }
     //*/

    for (int i = 0; i < nGridSize; i++) {
      for (int j = arlTop[i].size() - 1; j >= 0; j--) {
        fill((arlTop[i].get(j)<10)?20:0xffFF661A);
        text(arlTop[i].get(j).toString(), (i+fSideTiles) * nTileSize + nTileSize / 2, nTileSize * fSideTiles - (arlTop[i].size() - j) * fTextSize);
      }
    }
    for (int i = 0; i < nGridSize; i++) {
      for (int j = arlLeft[i].size() - 1; j >= 0; j--) {
        fill((arlLeft[i].get(j)<10)?20:0xffFF661A);
        text(arlLeft[i].get(j).toString(), nTileSize * fSideTiles - (arlLeft[i].size() - j) * fTextSize, (i+fSideTiles) * nTileSize + nTileSize / 2);
      }
    }

    if (isWon) {
      textSize(width/8);
      fill(0xff00FF00);
      text("YOU WIN", width/2, height/2);
      textSize(width/16);
      text("Press 'R' to Restart", width/2, height/2 + height/10);
      textSize(fTextSize);
    }
  }


  public boolean checkWin() {
    for (int y = 0; y < nGridSize; y++) {
      for (int x = 0; x < nGridSize; x++) {
        if (arbFilled[y][x] && arTileStates[y][x] != TileState.FILLED) return false;
        if (!arbFilled[y][x] && arTileStates[y][x] == TileState.FILLED) return false;
      }
    }
    println("WON");
    return true;
  }
}

enum TileState {
  FILLED, EMPTY, MARKED;
}
  public void settings() {  size(966, 966); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Picross" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
