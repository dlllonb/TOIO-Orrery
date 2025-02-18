import oscP5.*;
import netP5.*;

//constants
//The soft limit on how many toios a laptop can handle is in the 10-12 range
//the more toios you connect to, the more difficult it becomes to sustain the connection
int nCubes = 2;
int cubesPerHost = 12;
int maxMotorSpeed = 115;
int xOffset;
int yOffset;
int xOffset2;
int yOffset2;

// rocket box coords
int rocketBoxX1 = 90;
int rocketBoxY1 = 100;
int rocketBoxX2 = 150;
int rocketBoxY2 = 160;

// center of orbit (ie. sun) coords
int sunX = 250;
int sunY = 250;

// simulation paused or playing variable
boolean isSimulationPaused = false;

// images of planet info
PImage planetImage; // just a singular image for now, but will be list of list of images in final version?


//// Instruction for Windows Users  (Feb 2. 2025) ////
// 1. Enable WindowsMode and set nCubes to the exact number of toio you are connecting.
// 2. Run Processing Code FIRST, Then Run the Rust Code. After running the Rust Code, you should place the toio on the toio mat, then Processing should start showing the toio position.
// 3. When you re-run the processing code, make sure to stop the rust code and toios to be disconnected (switch to Bluetooth stand-by mode [blue LED blinking]). If toios are taking time to disconnect, you can optionally turn off the toio and turn back on using the power button.
// Optional: If the toio behavior is werid consider dropping the framerate (e.g. change from 30 to 10)
// 
boolean WindowsMode = false; //When you enable this, it will check for connection with toio via Rust first, before starting void loop()

int framerate = 30;

int[] matDimension = {45, 45, 455, 455};
int[] matDimension2 = {45, 45, 455, 455};


//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;

//we'll keep the cubes here
Cube[] cubes;


// FROM CORNER PIN

// Set Up
import deadpixel.keystone.*;
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

// Colors
color backgroundBlue;
color lightBrown;
color darkBrown;
color whiteGrey;
color lightGrey;
color mediumGrey;
color darkGrey;
color lightTeal;
color darkTeal;
color lightOrange;
color darkOrange;

// Dimensions
int sideLength;
int xoffset1;
int yoffset1;
int xoffset2;
int yoffset2;
int smallSize;
int mediumSize;
int largeSize;

// Fonts
PFont basicFont;
PFont basicfontSmall;
PFont basicfontTiny;

// Images
PImage starsRect;
PImage starsCirc;
PImage orangeDial;
PImage greyDial;
PImage tealDial;
PImage orangeCirc;
PImage greyCirc;
PImage tealCirc;
PImage rocketPhoto;

// Mode
int mode;

//void settings() {
//  size(1000, 1000);
//}


void setup() {
  //launch OSC sercer
  oscP5 = new OscP5(this, 3333);
  server = new NetAddress[1];
  server[0] = new NetAddress("127.0.0.1", 3334);

  //create cubes
  cubes = new Cube[nCubes];
  for (int i = 0; i< nCubes; ++i) {
    cubes[i] = new Cube(i);
  }

  xOffset = matDimension[0] - 45;
  yOffset = matDimension[1] - 45;
  xOffset2 = matDimension2[0] - 545;
  yOffset2 = matDimension2[1] - 45;

  //do not send TOO MANY PACKETS
  //we'll be updating the cubes every frame, so don't try to go too high
  frameRate(framerate);
  if(WindowsMode){
  check_connection();
  }
  
  // loads the planet info image
  planetImage = loadImage("space_background_circle.png"); // just one image for now
  
  // FROM CORNER PIN
  
  // put projector output size here
  size(2000, 1800, P3D);
  

  // put image size here
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(1000, 500, 20);
  offscreen = createGraphics(1000, 500, P3D);
  
  backgroundBlue = color(10,25,60);
  lightBrown = color(139,69,19);
  darkBrown = color(92, 45, 12);
  whiteGrey = color(225,255,237);
  lightGrey = color(101,116,147);
  mediumGrey = color(76, 90, 125);
  darkGrey = color(55, 66, 90);
  lightTeal = color(91, 205, 211);
  darkTeal = color(31, 161, 169);
  lightOrange = color(231, 97, 46);
  darkOrange = color(143, 35, 14);
  
  sideLength = 410;
  xoffset1 = 45;
  yoffset1 = 45;
  xoffset2 = 545;
  yoffset2 = 45;
  smallSize = 56; // scaled
  mediumSize = 65; // scaled
  largeSize = 75; // scaled
  
  basicFont = createFont("Courier", 30);
  basicfontSmall = createFont("Courier", 15);
  basicfontTiny = createFont("Courier", 10);
  
  starsRect = loadImage("space_background.jpg");
  starsRect.resize(410, 410);
  starsCirc = loadImage("space_background_circle.png");
  starsCirc.resize(132, 132);
  orangeDial = loadImage("orange_dial.png");
  orangeDial.resize(116, 84);
  greyDial = loadImage("grey_dial.png");
  greyDial.resize(116, 84);
  tealDial = loadImage("teal_dial.png");
  tealDial.resize(116, 84);
  orangeCirc = loadImage("orange_circle_hatched.png");
  orangeCirc.resize(75, 75);
  greyCirc = loadImage("grey_circle_hatched.png");
  greyCirc.resize(75, 75);
  tealCirc = loadImage("teal_circle_hatched.png");
  tealCirc.resize(75, 75);
  rocketPhoto = loadImage("rocket.png");
  rocketPhoto.resize(77,110);
  
  // for changing between sandbox and exploration - explore mode is 0 and sandbox is 1
  mode = 0;
  
}

void draw() {
  //START TEMPLATE/DEBUG VIEW
  background(255);
  stroke(0);
  long now = System.currentTimeMillis();

  //draw the "mat"
  fill(255);
  rect(matDimension[0] - xOffset, matDimension[1] - yOffset, matDimension[2] - matDimension[0], matDimension[3] - matDimension[1]);
  rect(matDimension2[0] - xOffset2, matDimension2[1] - yOffset2, matDimension2[2] - matDimension2[0], matDimension2[3] - matDimension2[1]);

  //draw the cubes
  pushMatrix();
  translate(xOffset, yOffset);
  
  for (int i = 0; i < nCubes; i++) {
    cubes[i].checkActive(now);
    
    if (cubes[i].isActive) {
      pushMatrix();
      translate(cubes[i].x, cubes[i].y);
      fill(0);
      textSize(15);
      text(i, 0, -20);
      noFill();
      rotate(cubes[i].theta * PI/180);
      rect(-10, -10, 20, 20);
      line(0, 0, 20, 0);
      popMatrix();
    }
  }
  popMatrix();
  //END TEMPLATE/DEBUG VIEW
  
  //INSERT YOUR CODE HERE!
  
  // example usage for moving toio in circle
  // Version 1: setting radius size
  /*moveCircle(cubes[0], 250, 250, 80);
  // Version 2: setting radius size based on placed position (make sure to modify mat center in onPositionUpdate in Cube class)
  int radius = (int) cubes[0].radius;
  moveCircle(cubes[0], 250, 250, radius);*/
  
  ArrayList<int[]> system1 = new ArrayList<>();
  system1.add(new int[]{80});
  
  planetImage = loadImage("space_background_circle.png");
  PImage[] systemImage1 = {planetImage};
  
  mode1(cubes, system1, systemImage1);
  /*// rocket pausing & info display part (kind of skeleton code for now)
  // assuming cubes[0] is the rocket
  Cube rocket = cubes[0];
  
  // check if the rocket is in its box and is active
  if (RocketInBox(rocket)) {
    isSimulationPaused = false;
  // case for if rocket is not in box or is not active
  } else {
    isSimulationPaused = true;

    // check if the rocket is near a planet
    boolean isNearPlanet = false;
    for (int i = 1; i < nCubes; i++) {
      Cube planet = cubes[i];
      if (rocket.distance(planet.x, planet.y) < 50) {
        isNearPlanet = true;
        image(planetImage, sunX, sunY);
        break;
      }
    }
    if (!isNearPlanet) {
      clear();
    }
  }

  // case for when rocket is in box (simulation resumes normally)
  if (!isSimulationPaused) {
    for (int i = 1; i < nCubes; i++) {
      moveCircle(cubes[i], sunX, sunY, 80);
    }
  }*/
  
  // FROM CORNER PIN
  // Draw the scene, offscreen
  offscreen.beginDraw();
  offscreen.background(255);
  
  // Two Boards
  offscreen.noStroke();
  offscreen.fill(lightGrey);
  offscreen.rect(xoffset1,yoffset1,sideLength,sideLength);
  offscreen.fill(backgroundBlue);
  offscreen.rect(xoffset2,yoffset2,sideLength,sideLength);
  offscreen.imageMode(CORNER);
  offscreen.image(starsRect,xoffset2,yoffset2); 
  
  // Right Board (Orbit)
  noStroke();
  offscreen.fill(mediumGrey);
  offscreen.ellipse(xoffset2+sideLength*1/12, yoffset2+sideLength*1/12, smallSize, smallSize);
  offscreen.ellipse(xoffset2+sideLength*1/12, yoffset2+sideLength*11/12, smallSize, smallSize);
  offscreen.ellipse(xoffset2+sideLength*11/12, yoffset2+sideLength*1/12, smallSize, smallSize);
  offscreen.ellipse(xoffset2+sideLength*11/12, yoffset2+sideLength*11/12, smallSize, smallSize);
  
  // Left Board (Control)
    // mode control
  offscreen.fill(mediumGrey);
  offscreen.arc(xoffset1+sideLength,yoffset1+sideLength,200,200,PI,PI*1.5);
    // rocket storage
  offscreen.imageMode(CORNER);
  offscreen.image(rocketPhoto, xoffset1+10, yoffset2+280);
  offscreen.fill(whiteGrey);
  offscreen.textMode(MODEL);
  offscreen.textFont(basicfontTiny);
  offscreen.textAlign(LEFT, CENTER);
  offscreen.text("Rocket Storage", xoffset1+10, yoffset1+400);
    
  if (mode == 0) {
    // EXPLORE MODE
    
    // upper bar
    offscreen.fill(mediumGrey);
    offscreen.rect(xoffset1, yoffset1, sideLength*9/12, sideLength*1/6);
    offscreen.ellipse(xoffset1+sideLength*9/12, yoffset1+sideLength*1/12, sideLength*1/6, sideLength*1/6);
    
    // text
    offscreen.fill(whiteGrey);
    offscreen.textFont(basicFont);
    offscreen.textAlign(LEFT, CENTER);
    offscreen.textMode(SHAPE);
    offscreen.stroke(10);
    offscreen.text("EXPLORATION MODE", xoffset1+sideLength*1/32, yoffset1+sideLength*2/28);
    offscreen.textMode(MODEL);
    offscreen.noStroke();
    
    // slider bar
    offscreen.rectMode(CENTER);
    offscreen.fill(mediumGrey);
    offscreen.rect(xoffset1+sideLength*1/2, yoffset1+sideLength*1/2, sideLength*5/6, sideLength*1/6);
    offscreen.fill(darkGrey);
    offscreen.rect(xoffset1+sideLength*1/2, yoffset1+sideLength*1/2, sideLength*4/6, sideLength*1/24);
    offscreen.ellipse(xoffset1+sideLength*1/2-137, yoffset1+sideLength*1/2, 40, 40);
    offscreen.ellipse(xoffset1+sideLength*1/2-68, yoffset1+sideLength*1/2, 40, 40);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*1/2, 40, 40);
    offscreen.ellipse(xoffset1+sideLength*1/2+68, yoffset1+sideLength*1/2, 40, 40);
    offscreen.ellipse(xoffset1+sideLength*1/2+137, yoffset1+sideLength*1/2, 40, 40);
    offscreen.rectMode(CORNER);
    
    // bubbles
    offscreen.ellipse(xoffset1+sideLength*1/2-137, yoffset1+sideLength*7/24, 80, 80);
    offscreen.ellipse(xoffset1+sideLength*1/2-68, yoffset1+sideLength*17/24, 80, 80);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*7/24, 80, 80);
    offscreen.ellipse(xoffset1+sideLength*1/2+68, yoffset1+sideLength*17/24, 80, 80);
    offscreen.ellipse(xoffset1+sideLength*1/2+137, yoffset1+sideLength*7/24, 80, 80);
    offscreen.imageMode(CENTER);
    offscreen.image(orangeCirc,xoffset1+sideLength*1/2-137, yoffset1+sideLength*7/24); 
    offscreen.image(tealCirc,xoffset1+sideLength*1/2-68, yoffset1+sideLength*17/24); 
    offscreen.image(greyCirc,xoffset1+sideLength*1/2, yoffset1+sideLength*7/24);
    offscreen.image(orangeCirc,xoffset1+sideLength*1/2+68, yoffset1+sideLength*17/24);
    offscreen.image(tealCirc,xoffset1+sideLength*1/2+137, yoffset1+sideLength*7/24);
    
    // lines
    offscreen.stroke(darkGrey);
    offscreen.line(xoffset1+sideLength*1/2-137,yoffset1+sideLength*7/24+80,xoffset1+sideLength*1/2-137,yoffset1+160);
    offscreen.line(xoffset1+sideLength*1/2-68,yoffset1+sideLength*17/24-80,xoffset1+sideLength*1/2-68,yoffset1+250);
    offscreen.line(xoffset1+sideLength*1/2,yoffset1+sideLength*7/24+80,xoffset1+sideLength*1/2,yoffset1+160);
    offscreen.line(xoffset1+sideLength*1/2+68,yoffset1+sideLength*17/24-80,xoffset1+sideLength*1/2+68,yoffset1+250);
    offscreen.line(xoffset1+sideLength*1/2+137,yoffset1+sideLength*7/24+80,xoffset1+sideLength*1/2+137,yoffset1+160);
    offscreen.noStroke();
    
  } else if (mode == 1) {
    // SANDBOX MODE
    
    // upper bar
    offscreen.fill(mediumGrey);
    offscreen.rect(xoffset1, yoffset1, sideLength*7/12, sideLength*1/6);
    offscreen.ellipse(xoffset1+sideLength*7/12, yoffset1+sideLength*1/12, sideLength*1/6, sideLength*1/6);
    
    // text
    offscreen.fill(whiteGrey);
    offscreen.textFont(basicFont);
    offscreen.textAlign(LEFT, CENTER);
    offscreen.textMode(SHAPE);
    offscreen.stroke(10);
    offscreen.text("SANDBOX MODE", xoffset1+sideLength*1/32, yoffset1+sideLength*2/28);
    offscreen.textMode(MODEL);
    offscreen.stroke(1);
    offscreen.textFont(basicfontSmall);
    offscreen.textAlign(CENTER, CENTER);
    offscreen.text("Temperature", xoffset1+sideLength*3/16, yoffset1+sideLength*3/14);
    offscreen.text("Planet Type", xoffset1+sideLength*2/4, yoffset1+sideLength*3/14);
    offscreen.text("Eccentricity", xoffset1+sideLength*13/16, yoffset1+sideLength*3/14);
    offscreen.noStroke();
    
    // lines
    //offscreen.stroke(3);
    offscreen.stroke(lightOrange);
    offscreen.line(xoffset1+sideLength*3/16, yoffset1+(sideLength*5/14)+42, xoffset1+sideLength*3/16, yoffset1+(sideLength*5/14)+53);
    offscreen.line(xoffset1+sideLength*7/16, yoffset1+(sideLength*5/14)+53, xoffset1+sideLength*7/16, yoffset1+(sideLength*5/14)+76);
    offscreen.line(xoffset1+sideLength*3/16, yoffset1+(sideLength*5/14)+53, xoffset1+sideLength*7/16, yoffset1+(sideLength*5/14)+53);
    offscreen.stroke(whiteGrey);
    offscreen.line(xoffset1+sideLength*1/2, yoffset1+(sideLength*5/14)+42, xoffset1+sideLength*1/2, yoffset1+(sideLength*5/14)+73);
    offscreen.stroke(lightTeal);
    offscreen.line(xoffset1+sideLength*13/16, yoffset1+(sideLength*5/14)+42, xoffset1+sideLength*13/16, yoffset1+(sideLength*5/14)+53);
    offscreen.line(xoffset1+sideLength*9/16, yoffset1+(sideLength*5/14)+53, xoffset1+sideLength*9/16, yoffset1+(sideLength*5/14)+76);
    offscreen.line(xoffset1+sideLength*13/16, yoffset1+(sideLength*5/14)+53, xoffset1+sideLength*9/16, yoffset1+(sideLength*5/14)+53);
    offscreen.noStroke();
    
    // dial boxes
    offscreen.imageMode(CENTER);
    offscreen.image(orangeDial,xoffset1+sideLength*3/16,yoffset1+sideLength*5/14); 
    offscreen.image(greyDial,xoffset1+sideLength*2/4,yoffset1+sideLength*5/14); 
    offscreen.image(tealDial,xoffset1+sideLength*13/16,yoffset1+sideLength*5/14);
    
    // window
    offscreen.fill(mediumGrey);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*3/4, largeSize*2.35, largeSize*2.35);
    offscreen.fill(darkGrey);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*3/4, largeSize*2, largeSize*2);
    offscreen.fill(backgroundBlue);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*3/4, largeSize*1.75, largeSize*1.75);
    offscreen.imageMode(CORNER);
    offscreen.image(starsCirc, xoffset1+sideLength*1/2-largeSize*1.75/2, yoffset1+sideLength*3/4-largeSize*1.75/2);
    
}
  
  offscreen.endDraw();

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);
 
  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
}


// helper function to move toio in  circle. Speed is determined based on T^2 = R^3 formula
void moveCircle(Cube cube, int centerX, int centerY, int radius) {
  float orbitalPeriod = pow(radius, 3/2) * 200;
  float angle = (millis() % orbitalPeriod) / orbitalPeriod * TWO_PI;

  int targetX = centerX + (int)(radius * cos(angle));
  int targetY = centerY + (int)(radius * sin(angle));

  cube.velocityTarget(targetX, targetY);
}

// helper function to determine if rocket is in box
boolean RocketInBox(Cube rocket) {
  return (rocket.x >= rocketBoxX1 && rocket.x <= rocketBoxX2 &&
          rocket.y >= rocketBoxY1 && rocket.y <= rocketBoxY2 &&
          rocket.isActive);
}

// helper function where mode 1 runs when inputted a solar system data list
void mode1(Cube[] cubes, ArrayList<int[]> systemData, PImage[] imageData) {
  // assuming cubes[0] is the rocket
  Cube rocket = cubes[0];
  
  // check if the rocket is in its box and is active
  if (RocketInBox(rocket)) {
    isSimulationPaused = false;
  // case for if rocket is not in box or is not active
  } else {
    isSimulationPaused = true;

    // check if the rocket is near a planet
    boolean isNearPlanet = false;
    for (int i = 1; i <= systemData.size(); i++) {
      Cube planet = cubes[i];
      if (rocket.distance(planet.x, planet.y) < 50) {
        isNearPlanet = true;
        image(imageData[i-1], sunX, sunY);
        break;
      }
    }
    if (!isNearPlanet) {
      clear();
    }
  }

  // case for when rocket is in box (simulation resumes normally)
  if (!isSimulationPaused) {
    for (int i = 1; i <= systemData.size(); i++) {
      int[] planetData = systemData.get(i-1);
      int radius = planetData[0];
      // can add more variables here but only raidus for now

      moveCircle(cubes[i], sunX, sunY, radius);
    }
  }
}
