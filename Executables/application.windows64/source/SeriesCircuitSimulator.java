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

public class SeriesCircuitSimulator extends PApplet {

float nEr1, nEr2, nEr3, nEt, nIt, nR1, nR2, nR3, nRt, nSpriteCount = 0, nDelay;
PImage Circuit, Electron, PlusAndMinus;
PFont font;
ArrayList<PImage> alElectronSprites = new ArrayList<PImage>();
ArrayList<Electron> alElectrons = new ArrayList<Electron>();
public void setup() {
  
  nEr1 = nEr2 = nEr3 = nEt = nIt = nR1 = nR2 = nR3 = nRt = 0;
  Electron = loadImage("img\\ElectronSpritesheet.png");
  Circuit = loadImage("img\\Circuit.png");
  PlusAndMinus = loadImage("img\\PlusAndMinus.jpg");
  PlusAndMinus.resize(80, 20);
  Circuit.resize(800, 800);
  Electron.resize(Electron.width*2, Electron.height*2);
  font = createFont("Courier", 16, true);
  createAnimation();
}

public void draw() {
  background(255);
  strokeWeight(5);
  textFont(font);
  fill(0);
  if (mousePressed) {
    if (mouseButton == LEFT) {
      isHit();
    }
  }
  /*************************************************************************************************************************/  //THIS IS THE MATH

  nRt = nR1 + nR2 + nR3; 
  nIt = (nRt > 0) ? nEt/nRt : nEt; 
  nEr1 = nR1*nIt; 
  nEr2 = nR2*nIt; 
  nEr3 = nR3*nIt; 

  /*************************************************************************************************************************/

  checkElectronBalance();


  image(Circuit, -25, -100);
  for (int v = 0; v < alElectrons.size(); v++) {
    if (alElectrons.get(v).scheduledForRemoval && alElectrons.get(v).nX == 95 && alElectrons.get(v).nY >= 185 && alElectrons.get(v).nY < 190) {
      alElectrons.remove(v);
    } else {
      alElectrons.get(v).moveElectron();
      imageMode(CENTER);
      image(alElectrons.get(v).getElectron(alElectronSprites), alElectrons.get(v).nX, alElectrons.get(v).nY);
      imageMode(CORNER);
    }
  }
  text("Potential:" + nEt, 200, 200);
  image(PlusAndMinus, 350, 185);
  text("Resistance:" + nRt, 200, 250);
  text("Current:" + nIt, 200, 300);
  text("R1:" + nR1, 430, 40);
  image(PlusAndMinus, 505, 25);
  text("ER1:" + nEr1, 175, 40);
  text("R2:" + nR2, 595, 145);
  image(PlusAndMinus, 595, 165);
  text("ER2:" + nEr2, 610, 395);
  text("R3:" + nR3, 435, 560);
  image(PlusAndMinus, 515, 545);
  text("ER3:" + nEr3, 165, 565);

  /*line(75, 75, 425, 75);
   line(425, 75, 425, 425);
   line(425, 425, 75, 425);
   line(75, 75, 75, 175);
   line(75, 425, 75, 325);*/
  //println(mouseX + " " +mouseY);
}

public void isHit() {
  if (mouseX >= 350 && mouseY >= 185 && mouseX <= 390 && mouseY <= 205) {
    if (nEt<9999) {
      nEt++;
    }
  } else if (mouseX >=390 && mouseY >= 185 && mouseX <= 430 && mouseY <= 205) {
    if (nEt >0) {
      nEt--;
    }
  }

  if (mouseX >= 505 && mouseY >= 25 && mouseX <= 545 && mouseY <= 45) {
    if (nR1<9999) {
      nR1++;
    }
  } else if (mouseX >=545 && mouseY >= 25 && mouseX <= 585 && mouseY <= 45) {
    if (nR1 >0) {
      nR1--;
    }
  }

  if (mouseX >= 595 && mouseY >= 165 && mouseX <= 635 && mouseY <= 185) {
    if (nR2<9999) {
      nR2++;
    }
  } else if (mouseX >=635 && mouseY >= 165 && mouseX <= 675 && mouseY <= 185) {
    if (nR2 >0) {
      nR2--;
    }
  }

  if (mouseX >= 515 && mouseY >= 545 && mouseX <= 555 && mouseY <= 565) {
    if (nR3<9999) {
      nR3++;
    }
  } else if (mouseX >=555 && mouseY >= 545 && mouseX <= 595 && mouseY <= 565) {
    if (nR3 >0) {
      nR3--;
    }
  }
}

public void checkElectronBalance() {
  if (floor(nEt/20) != alElectrons.size()) {
    if (floor(nEt/20) > alElectrons.size()) {
      alElectrons.add(new Electron());
    } else {
      for (int v = 0; v < alElectrons.size()-floor(nEt/20)-1; v++) {
        alElectrons.get(v).scheduledForRemoval = true;
      }
    }
  }
}

public void createAnimation() {
  PImage img; 
  int w, h, x, y; 

  w = Electron.width/8; 
  h = Electron.height/5; 
  for (int v = 0; v < 5; v++) {
    for (int vv = 0; vv < 8; vv++) {
      x = vv*w; 
      y = v*h; 
      img = Electron.get(x, y, w, h); 
      alElectronSprites.add(img);
    }
  }
}

class Electron {
  boolean scheduledForRemoval = false; 
  int nSpriteCount = 0, nX = 95, nY = 400;
  Electron() {
  }
  public PImage getElectron(ArrayList<PImage> alElectronSprites) {
    nSpriteCount = (nSpriteCount == alElectronSprites.size() - 1) ? 0 : nSpriteCount + 1; 
    return alElectronSprites.get(nSpriteCount);
  }
  public void moveElectron() {
    if(nX == 95 && nY >= 65 && nY < 520){
      nY+=5;
    } else if(nY == 520 && nX >= 95 && nX < 585){
      nX+=5;
    } else if(nX == 585 && nY <= 520 && nY > 65){
      nY-=5;
    } else if(nY == 65 && nX <= 585 && nX > 95){
      nX-=5;
    }
  }
}
  public void settings() {  size(700, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SeriesCircuitSimulator" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
