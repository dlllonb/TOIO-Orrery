import oscP5.*;
import netP5.*;

// cube 0 = rocket
// cube 1 = adjustment dial
// cube 2 = mode dial
// cube 3 = sun
// cubes 4-7 = planets

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

// angle of sun for rotation
int sunAngle = 0;

// angle of the mode changing dial
float prevModeAngle = 0;

// if planets' orbits are already set in sandbox mode
boolean[] orbiting = {false, false, false, false, false};

// default values for sandbox mode planets
// in case placed without customizing the planet
int radius = 100;
int temperature = 1000;
// type 0: ..., type 1: ..., type 2: ..., ...
int planetType = 0;
int size = 0;

// planet variables for sandbox mode
int[][] sandboxPlanets = {{size, temperature, planetType, radius}, {size, temperature, planetType, radius},
                          {size, temperature, planetType, radius}, {size, temperature, planetType, radius}};

// rocket box coords
int rocketBoxX1 = 90;
int rocketBoxY1 = 100;
int rocketBoxX2 = 150;
int rocketBoxY2 = 160;

// dial 1 box coords
int dial1BoxX1 = 10;
int dial1BoxY1 = 300;
int dial1BoxX2 = 20;
int dial1BoxY2 = 290;

// dial 2 box coords
int dial2BoxX1 = 30;
int dial2BoxY1 = 300;
int dial2BoxX2 = 40;
int dial2BoxY2 = 290;

// dial 3 box coords
int dial3BoxX1 = 50;
int dial3BoxY1 = 300;
int dial3BoxX2 = 60;
int dial3BoxY2 = 290;

// planet colors
// rocky, gas giant, icy, water
color[] planetColors  = {#db6400, #d72982, #1fddbd, #0042ff};

// variable controlled by dial
// 0: temperature, 1: type of planet, 2: eccentricity
int dialVariable = 0;

// previous dial position on slider
int prevSliderX = -1;

// slider box coords
int sliderBoxX1 = 10;
int sliderBoxY1 = 450;
int sliderBoxX2 = 300;
int sliderBoxY2 = 350;

// is slider toio being used to choose a System
boolean choosingSystems = false;

// the system currently being shown
int currSystem = 0;

// center of orbit (ie. sun) coords
int sunX = 250;
int sunY = 250;

// simulation paused or playing variable
boolean isSimulationPaused = false;

// images of planet info
PImage planetImage;

// list of systems, list of planets in each system, list of attributes in each planet
// first four values are identical for all planets within a system
//float(system.star_teff),          # star temp [0]
//float(system.star_mass),          # star mass [1]
//float(system.star_radius),        # star radius [2]
//int(system.num_planets),          # # of planets [3]
//float(planet.planet_mass),        # planet mass [4]
//float(planet.planet_radius),      # planet radius [5]
//float(planet.period),             # orbital period [6]
//float(planet.semi_major_axis)     # orbital radius [7]
double[][][] systems = {
   {
    {5553, 0.941, 1.098, 4, 1.4997668052981619, 1.15, 5.36375016, 0.0587643432801649},
    {5553, 0.941, 1.098, 4, 0.9712746732929188, 0.99, 7.9788198, 0.07657622703763443},
    {5553, 0.941, 1.098, 4, 2.598620862286507, 1.39, 12.0999065, 0.10107789827317307},
    {5553, 0.941, 1.098, 4, 0.4341878475320084, 0.75, 18.0811429, 0.13211499492880274}
  },
  {
    {5726, 1.066, 1.483, 3,  1.0591086087084456, 1.02, 6.33027476, 0.06841307230385374},
    {5726, 1.066, 1.483, 3, 14.758747796594959, 2.53, 14.97031664, 0.12143523325285126},
    {5726, 1.066, 1.483, 3, 11.336389044131788, 2.31, 32.2753853, 0.20266169820725852}
  },
  {
    {5680, 0.978, 1.016, 3, 0.40145446668453283, 0.73, 9.48814747, 0.08706405448203451},
    {5680, 0.978, 1.016, 3, 8.95985228849463, 2.13, 16.09196369, 0.12381995252473507},
    {5680, 0.978, 1.016, 3, 0.5825409609685035, 0.83, 25.5172744, 0.16837364991729797}
  },
  {
   {5854, 0.951, 1.012, 4, 0.5047990916354442, 0.79, 6.164876, 0.06470652170843269},
   {5854, 0.951, 1.012, 4, 16.697497531127837, 2.64, 13.57078281, 0.10949688335916519},
   {5854, 0.951, 1.012, 4, 2.188198708650173, 1.31, 23.9800854, 0.16004138760462955},
   {5854, 0.951, 1.012, 4,  21.274408815918402,  2.87,  43.84439721,  0.23929918911521614}
  },
  {
   {4499, 0.643, 0.639, 4, 0.6457218890324189, 0.86, 4.159816554, 0.04369094408355136},
   {4499, 0.643, 0.639, 4, 5.499082874351366, 1.8, 9.034190783, 0.07327145488816135},
   {4499, 0.643, 0.639, 4, 0.7367213866271994, 0.9, 28.1224393, 0.1562106484733413},
   {4499, 0.643, 0.639, 4, 1.6160612661228089, 1.18, 45.9029768, 0.216555495953447}
  }
};

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
  
  // changing systems and variables with the dial
  // assuming cubes[1] is the dial and cubes[2] is the slider toio
  Cube dial = cubes[1];
  Cube modeSwitcher = cubes[2];
  
  currSystem = systemChoice(dial, currSystem);
  double[][] system = systems[currSystem];
  // had to add images to an ArrayList then turn that into an array because the sizes vary, maybe there's a better way?
  ArrayList<PImage> systemImages = new ArrayList<PImage>();
  for (int i = 0; i < system.length; i++) {
    String systemCode = str ((int) system[i][0]);
    planetImage = loadImage(systemCode + "." + i + ".png");
    systemImages.add(planetImage);
  }
  PImage[] images = new PImage[systemImages.size()];
  images = systemImages.toArray(images);
  
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
  
  // exploration mode
  if (mode == 0) {
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
 
     mode1(cubes, system, images);
     
  // sandbox mode
  } else {
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
    
    for (int i = 4; i < 9; i++) {
      Cube planet = cubes[i];
      // if in the porthole
      if (planet.x > 50 && planet.y > 50 && planet.x < 100 && planet.y < 100) {
          // if dial being used to adjust a variable
          if (Math.abs(dial.y - dial1BoxY1) < 10) {
            // which variable the dial is controlling
            if (Math.abs(dial.x - dial1BoxX1) < 10) {
              // size, currently mapping 0-180 to 10-100 (label 0.5 to 5 times the size of earth)
              sandboxPlanets[i - 4][0] = (int)(10 + ((dial.theta * 90) / 180));
            } else if (Math.abs(dial.x - dial2BoxX1) < 10) {
              // temp, currently mapping 0-180 to 3000-11000
              int temp = (int)(3000 + ((dial.theta * 8000) / 180));
              sandboxPlanets[i - 4][1] = temp;
              // mapping temp to color, red always at 255, green goes up with temp, then blue
              int red = 255;
              int green = 0;
              int blue = 0;
              if (temp < 7000) {
                green = (int)((temp - 3000) * 255 / 4000);
              } else {
                blue = (int)((temp - 7000) * 255 / 4000);
              }
              fill(color(red, green, blue));
              ellipse(sunX, sunY, 100, 100);
            } else if (Math.abs(dial.x - dial3BoxX1) < 10) {
              // type, currently mapping 0-180 to 0-3
              sandboxPlanets[i - 4][2] = (int)((dial.theta * 3) / 180);
            }
          }
      // planet on map
      } else if (planet.x > 500 && planet.x < 1000){
        // if planet orbit already set
        if (orbiting[i - 4]) {
          // check if planet has been picked up and moved
          // set orbit with new radius
        // set planet orbit
        } else {
         // getting distace from sun
          sandboxPlanets[i - 4][0] = (int)Math.sqrt(Math.pow(sunX - planet.x, 2) + Math.pow(sunY - planet.y, 2));
          moveCircle(cubes[i], sunX, sunY, sandboxPlanets[i - 4][0]);
          orbiting[i - 4] = true;
          fill(planetColors[sandboxPlanets[i - 4][2]]);
          ellipse(cubes[i].x, cubes[i].y, sandboxPlanets[i - 4][0], sandboxPlanets[i - 4][0]);
        }
      } else {
        // if planet moved from orbit
        if (orbiting[i - 4] == true) {
          orbiting[i - 4] = false;
        }
      }
    }
  }
  
  offscreen.endDraw();
  
// most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);
 
  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
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
  
  // making the sun spin
  sunAngle += 1;
  motorTarget(cubes[3].id, 0, 5, 0, 80, 0, 0, 0, sunAngle % 360);
}

// helper function to move toio in  circle. Speed is determined based on T^2 = R^3 formula
void moveCircle(Cube cube, int centerX, int centerY, float radius) {
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
void mode1(Cube[] cubes, double[][] systemData, PImage[] imageData) {
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
    for (int i = 4; i <= systemData.length + 4; i++) {
      Cube planet = cubes[i];
      if (rocket.distance(planet.x, planet.y) < 50) {
        isNearPlanet = true;
        image(imageData[i-4], sunX, sunY);
        break;
      }
    }
    if (!isNearPlanet) {
      clear();
    }
  }

  // case for when rocket is in box (simulation resumes normally)
  if (!isSimulationPaused) {
    for (int i = 0; i <= systemData.length; i++) {
      double[] planetData = systemData[i];
      double radius = planetData[7];
      float floatRadius = (float) radius;
      moveCircle(cubes[i], sunX, sunY, floatRadius);
    }
  }
}

// helper function to determine if slider in box
boolean SliderInBox(Cube slider) {
  return (slider.x >= sliderBoxX1 && slider.x <= sliderBoxX2 &&
          slider.y >= sliderBoxY1 && slider.y <= sliderBoxY2 &&
          slider.isActive);
}

// helper function to determine which option the dial is pointing to
int dialChoice(Cube dial) {
  return (dial.theta % 30);
}

int systemChoice (Cube slider, int currentSystem) {
  if (slider.x >= 95 && slider.x <= 115 && slider.y >= 250 && slider.y <= 250) {
    return 0;
  } else if (slider.x >= 170 && slider.x <= 190 && slider.y >= 240 && slider.y <=265) {
    return 1;
  } else if (slider.x >= 235 && slider.x <= 255 && slider.y >= 240 && slider.y <=265) {
    return 2;
  } else if (slider.x >= 305 && slider.x <= 325 && slider.y >= 240 && slider.y <=265) {
    return 3;
  } else if (slider.x >= 370 && slider.x <= 390 && slider.y >= 240 && slider.y <=265) {
    return 4;
  } else {
    return currentSystem;
  }
}
