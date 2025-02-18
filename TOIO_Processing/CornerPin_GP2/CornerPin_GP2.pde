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
  lightGrey = color(101,116,147);
  mediumGrey = color(76, 90, 125);
  darkGrey = color(33, 37, 46);
  lightTeal = color(91, 205, 211);
  darkTeal = color(31, 161, 169);
  lightOrange = color(231, 97, 46);
  darkOrange = color(143, 35, 14);
  
  sideLength = 410;
  xoffset1 = 45;
  yoffset1 = 45;
  xoffset2 = 545;
  yoffset2 = 45;
  smallSize = 20;
  mediumSize = 30;
  largeSize = 40;
  
  mode = 1;
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
  
  // Right Board (Orbit)
  offscreen.fill(lightGrey);
  offscreen.rect(xoffset2, yoffset2+(sideLength*4/5), sideLength, sideLength*1/5);
  offscreen.fill(mediumGrey);
  offscreen.ellipse(xoffset2+sideLength*1/7, yoffset2+sideLength*9/10, smallSize, smallSize);
  offscreen.ellipse(xoffset2+sideLength*2/7, yoffset2+sideLength*9/10, smallSize, smallSize);
  offscreen.ellipse(xoffset2+sideLength*3/7, yoffset2+sideLength*9/10, mediumSize, mediumSize);
  offscreen.ellipse(xoffset2+sideLength*4/7, yoffset2+sideLength*9/10, mediumSize, mediumSize);
  offscreen.ellipse(xoffset2+sideLength*5/7, yoffset2+sideLength*9/10, largeSize, largeSize);
  offscreen.ellipse(xoffset2+sideLength*6/7, yoffset2+sideLength*9/10, largeSize, largeSize);
  
  // Left Board (Control)
  offscreen.fill(mediumGrey);
  offscreen.arc(xoffset1+sideLength,yoffset1+sideLength,200,200,PI,PI*1.5);
  offscreen.rect(xoffset1, yoffset1, sideLength*2/3, sideLength*1/6);
  if (mode == 0) {
    // EXPLORE MODE
  } else if (mode == 1) {
    // SANDBOX MODE
    offscreen.fill(mediumGrey);
    offscreen.rect(xoffset1+sideLength*1/24, yoffset1+sideLength*2/7, sideLength*1/4, sideLength*1/6, 6);
    offscreen.rect(xoffset1+sideLength*9/24, yoffset1+sideLength*2/7, sideLength*1/4, sideLength*1/6, 6);
    offscreen.rect(xoffset1+sideLength*17/24, yoffset1+sideLength*2/7, sideLength*1/4, sideLength*1/6, 6);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*3/4, largeSize*4, largeSize*4);
    offscreen.fill(backgroundBlue);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*3/4, largeSize*3.5, largeSize*3.5);
    offscreen.fill(lightTeal);
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
