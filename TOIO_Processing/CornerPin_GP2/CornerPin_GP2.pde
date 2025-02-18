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

// Fonts
PFont basicFont;

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
  smallSize = 56; // scaled
  mediumSize = 65; // scaled
  largeSize = 75; // scaled
  
  basicFont = createFont("Courier", 30); 
  
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
    // bottom bar
  offscreen.fill(lightGrey);
  offscreen.rect(xoffset2, yoffset2+(sideLength*4/5), sideLength, sideLength*1/5);
  offscreen.fill(mediumGrey);
    // planet spots
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
  offscreen.rect(xoffset1, yoffset1, sideLength*2/3, sideLength*1/6);
  if (mode == 0) {
    // EXPLORE MODE
  } else if (mode == 1) {
    // SANDBOX MODE
    offscreen.fill(mediumGrey);
    offscreen.rect(xoffset1+sideLength*1/24, yoffset1+sideLength*2/7, sideLength*1/4, sideLength*1/6, 6);
    offscreen.rect(xoffset1+sideLength*9/24, yoffset1+sideLength*2/7, sideLength*1/4, sideLength*1/6, 6);
    offscreen.rect(xoffset1+sideLength*17/24, yoffset1+sideLength*2/7, sideLength*1/4, sideLength*1/6, 6);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*3/4, largeSize*2.25, largeSize*2.25);
    offscreen.fill(backgroundBlue);
    offscreen.ellipse(xoffset1+sideLength*1/2, yoffset1+sideLength*3/4, largeSize*1.75, largeSize*1.75);
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
