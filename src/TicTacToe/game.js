let W, H, winNum, tileSize, gridSize = 3;
let grid = [H];
let gameover, win, turn; // turn -> TRUE for X, FALSE for O

function setup() {
  createCanvas(600, 600);
  textAlign(CENTER, CENTER);
  W = H = winNum = gridSize;
  tileSize = width/W; // Assume square grid
  
  init();
}

function draw() {
  background(255);
  drawGrid();
  if(!gameover) {
    if(mouseIsPressed && mouseButton == LEFT) placeMove();
    checkWin();
  } else {
    displayRestartScreen();
  }
}

function init() {
  for(let i = 0; i < H; i++) {
    (arr = []).length = W; // Fastest way to fill array according to stackoverflow
    arr.fill(' ');
    grid[i] = arr;
  }
  gameover = false;
  win = true;
  turn = true;
}

function drawGrid() {
  // Draw Grid Lines
  strokeWeight(4);
  stroke(turn*255, 0, !turn*255); // red on X turn, blue on O turn
  for (let i = 1; i < H; i++)
    line(0, i * tileSize, width, i * tileSize);
  for (let j = 1; j < W; j++)
    line(j * tileSize, 0, j * tileSize, height);
  
  // Draw X's and O's
  strokeWeight(2);
  offset = tileSize/8;
  for (let i = 0; i < H; i++) {
    for (let j = 0; j < W; j++) {
      if (grid[i][j] == 'X') {
        stroke(255, 0, 0);
        line((j*tileSize) + offset, (i*tileSize) + offset, 
             ((j+1)*tileSize) - offset, ((i+1)*tileSize) - offset);
        line(((j+1)*tileSize) - offset, (i*tileSize) + offset, 
             (j*tileSize) + offset, ((i+1)*tileSize) - offset);
      }
      
      if (grid[i][j] == 'O') {
        fill(255);
        stroke(0, 0, 255);
        ellipse((j + 1/2) * tileSize, (i + 1/2) * tileSize, tileSize - offset * 2);
      }
    }
  }  
}

function placeMove() {
  // if (!mouseIsPressed && mouseButton == LEFT) return;
  let locX = floor(mouseX/tileSize), locY = floor(mouseY/tileSize);
  if (grid[locY][locX] == ' ') {
    grid[locY][locX] = turn ? 'X' : 'O';
    if (checkWin()) {
      gameover = true;
      return;
    }
    turn = !turn;
  }
}
           
function checkWin() {
  win = false;
  
  let len = [(gridSize * 2) + 2];
  (winPaths = []).length = len; // rows, columns, left/right diags
  winPaths.fill(' ');
  for (let i = 0; i < gridSize; i++) { // init firsts
    winPaths[i] = grid[i][0];
    winPaths[i+gridSize] = grid[0][i];
  }
  winPaths[len-2] = grid[0][0]; // left diagonal
  winPaths[len-1] = grid[0][gridSize-1]; // right diagonal
  
  for (let i = 0; i < gridSize; i++) { 
    // Needs O(n^2) runtime for 4x4+ extensibility
    for(let j = 0; j < gridSize; j++) {
      win = grid[i][j] == ' ' ? true : win;
      if (grid[i][j] != winPaths[i])
        winPaths[i] = ' ';
      if (grid[j][i] != winPaths[i+gridSize])
        winPaths[i+gridSize] = ' ';
    }
    if (grid[i][i] != winPaths[len-2]) 
      winPaths[len-2] = ' ';
    if (grid[i][gridSize-i-1] != winPaths[len-1]) 
      winPaths[len-1] = ' ';
  }
  if (winPaths.includes('X') || winPaths.includes('O')) win = true;
  return winPaths.includes('X') || winPaths.includes('O') || !win;
}

function displayRestartScreen() {
  textSize(width/8);
  c = color(win ? (turn ? "#FF0000" : "#0000FF") : 0);
  fill(c);
  stroke(c);
  text(win ? ((turn ? "X" : "O") + " WINS!") : "DRAW!", width/2, height/2);
  textSize(width/16);
  text("Press 'R' to Restart", width/2, height/2 + height/10);
  if (keyIsPressed && (key == 'r' || key == 'R')) {
    init();
  }
}
  
           
           