/**
 * This is a simple example of how to use the Keystone library.
 *
 * To use this example in the real world, you need a projector
 * and a surface you want to project your Processing sketch onto.
 *
 * Simply drag the corners of the CornerPinSurface so that they
 * match the physical surface's corners. The result will be an
 * undistorted projection, regardless of projector position or 
 * orientation.
 *
 * You can also create more than one Surface object, and project
 * onto multiple flat surfaces using a single projector.
 *
 * This extra flexbility can comes at the sacrifice of more or 
 * less pixel resolution, depending on your projector and how
 * many surfaces you want to map. 
 */

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

// Images
PImage starsRect;
PImage starsCirc;
PImage orangeDial;
PImage greyDial;
PImage tealDial;
PImage orangeCirc;
PImage greyCirc;
PImage tealCirc;

// Mode
int mode;

void setup() {
  // put projector output size here
  size(800, 600, P3D);

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
  
  starsRect = loadImage("../space_background_fourtofive.jpg");
  starsRect.resize(410, 328);
  starsCirc = loadImage("../space_background_circle.png");
  starsCirc.resize(132, 132);
  orangeDial = loadImage("../orange_dial.png");
  orangeDial.resize(116, 84);
  greyDial = loadImage("../grey_dial.png");
  greyDial.resize(116, 84);
  tealDial = loadImage("../teal_dial.png");
  tealDial.resize(116, 84);
  orangeCirc = loadImage("../orange_circle_hatched.png");
  orangeCirc.resize(75, 75);
  greyCirc = loadImage("../grey_circle_hatched.png");
  greyCirc.resize(75, 75);
  tealCirc = loadImage("../teal_circle_hatched.png");
  tealCirc.resize(75, 75);
  
  mode = 0;
  
}

void draw() {
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
    // bottom bar
  offscreen.fill(lightGrey);
  offscreen.rect(xoffset2, yoffset2+(sideLength*4/5), sideLength, sideLength*1/5);
  // planet spots
  offscreen.fill(mediumGrey);
  offscreen.ellipse(xoffset2+30.749999981, yoffset2+sideLength*9/10, smallSize, smallSize);
  offscreen.ellipse(xoffset2+89.268181764, yoffset2+sideLength*9/10, smallSize, smallSize);
  offscreen.ellipse(xoffset2+152.445454453, yoffset2+sideLength*9/10, mediumSize, mediumSize);
  offscreen.ellipse(xoffset2+220.281818048, yoffset2+sideLength*9/10, mediumSize, mediumSize);
  offscreen.ellipse(xoffset2+292.777272549, yoffset2+sideLength*9/10, largeSize, largeSize);
  offscreen.ellipse(xoffset2+369.931817956, yoffset2+sideLength*9/10, largeSize, largeSize);
  offscreen.fill(lightGrey);
  offscreen.ellipse(xoffset2+30.749999981, yoffset2+sideLength*9/10+10, smallSize, smallSize);
  offscreen.ellipse(xoffset2+89.268181764, yoffset2+sideLength*9/10+10, smallSize, smallSize);
  offscreen.ellipse(xoffset2+152.445454453, yoffset2+sideLength*9/10+10, mediumSize, mediumSize);
  offscreen.ellipse(xoffset2+220.281818048, yoffset2+sideLength*9/10+10, mediumSize, mediumSize);
  offscreen.ellipse(xoffset2+292.777272549, yoffset2+sideLength*9/10+10, largeSize, largeSize);
  offscreen.ellipse(xoffset2+369.931817956, yoffset2+sideLength*9/10+10, largeSize, largeSize);
  offscreen.noFill();
  offscreen.stroke(mediumGrey);
  offscreen.strokeWeight(2);
  offscreen.ellipse(xoffset2+30.749999981, yoffset2+sideLength*9/10, smallSize, smallSize);
  offscreen.ellipse(xoffset2+89.268181764, yoffset2+sideLength*9/10, smallSize, smallSize);
  offscreen.ellipse(xoffset2+152.445454453, yoffset2+sideLength*9/10, mediumSize, mediumSize);
  offscreen.ellipse(xoffset2+220.281818048, yoffset2+sideLength*9/10, mediumSize, mediumSize);
  offscreen.ellipse(xoffset2+292.777272549, yoffset2+sideLength*9/10, largeSize, largeSize);
  offscreen.ellipse(xoffset2+369.931817956, yoffset2+sideLength*9/10, largeSize, largeSize);
  offscreen.noStroke();
  offscreen.fill(255);
  offscreen.rect(xoffset2, yoffset2+410, sideLength, 45);
    // labels 
  offscreen.fill(mediumGrey);
  offscreen.textFont(basicFont);
  offscreen.textAlign(CENTER, CENTER);
  offscreen.text("S",xoffset2+30.749999981, yoffset2+sideLength*9/10);
  offscreen.text("S",xoffset2+89.268181764, yoffset2+sideLength*9/10);
  offscreen.text("M",xoffset2+152.445454453, yoffset2+sideLength*9/10);
  offscreen.text("M",xoffset2+220.281818048, yoffset2+sideLength*9/10);
  offscreen.text("L",xoffset2+292.777272549, yoffset2+sideLength*9/10);
  offscreen.text("L",xoffset2+369.931817956, yoffset2+sideLength*9/10);
  
  // Left Board (Control)
  offscreen.fill(mediumGrey);
  offscreen.arc(xoffset1+sideLength,yoffset1+sideLength,200,200,PI,PI*1.5);

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
    offscreen.ellipse(xoffset1+sideLength*1/2-137, yoffset1+sideLength*1/2, 30, 30);
    offscreen.ellipse(xoffset1+sideLength*1/2-68, yoffset1+sideLength*1/2, 30, 30);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*1/2, 30, 30);
    offscreen.ellipse(xoffset1+sideLength*1/2+68, yoffset1+sideLength*1/2, 30, 30);
    offscreen.ellipse(xoffset1+sideLength*1/2+137, yoffset1+sideLength*1/2, 30, 30);
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
    offscreen.line(xoffset1+sideLength*1/2-137,yoffset1+sideLength*7/24+80,xoffset1+sideLength*1/2-137,yoffset1+sideLength*18/48);
    offscreen.line(xoffset1+sideLength*1/2-68,yoffset1+sideLength*17/24-80,xoffset1+sideLength*1/2-68,yoffset1+sideLength*7/12);
    offscreen.line(xoffset1+sideLength*1/2,yoffset1+sideLength*7/24+80,xoffset1+sideLength*1/2,yoffset1+sideLength*18/48);
    offscreen.line(xoffset1+sideLength*1/2+68,yoffset1+sideLength*17/24-80,xoffset1+sideLength*1/2+68,yoffset1+sideLength*7/12);
    offscreen.line(xoffset1+sideLength*1/2+137,yoffset1+sideLength*7/24+80,xoffset1+sideLength*1/2+137,yoffset1+sideLength*18/48);
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

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;

  }
}
