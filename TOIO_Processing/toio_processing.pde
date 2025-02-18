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
int currSystem = -1;

// center of orbit (ie. sun) coords
int sunX = 250;
int sunY = 250;

// simulation paused or playing variable
boolean isSimulationPaused = false;

// images of planet info
PImage planetImage; // just a singular image for now, but will be list of list of images in final version?

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
    {5553.0, 0.941, 1.098, 4, 2.598620862286507, 1.39, 12.0999065, 0.10107789827317307},
    {5553.0, 0.941, 1.098, 4, 1.4997668052981619, 1.15, 5.36375016, 0.0587643432801649},
    {5553.0, 0.941, 1.098, 4, 0.9712746732929188, 0.99, 7.9788198, 0.07657622703763443},
    {5553.0, 0.941, 1.098, 4, 0.4341878475320084, 0.75, 18.0811429, 0.13211499492880274}
  },
  {
    {5726.0, 1.066, 1.483, 3, 14.758747796594959, 2.53, 14.97031664, 0.12143523325285126},
    {5726.0, 1.066, 1.483, 3, 11.336389044131788, 2.31, 32.2753853, 0.20266169820725852},
    {5726.0, 1.066, 1.483, 3,  1.0591086087084456, 1.02, 6.33027476, 0.06841307230385374}
  },
  {
    {5680.0, 0.978, 1.016, 3, 8.95985228849463, 2.13, 16.09196369, 0.12381995252473507},
    {5680.0, 0.978, 1.016, 3, 0.5825409609685035, 0.83, 25.5172744, 0.16837364991729797},
    {5680.0, 0.978, 1.016, 3, 0.40145446668453283, 0.73, 9.48814747, 0.08706405448203451}
  },
  {
   {5854.0, 0.951, 1.012, 4, 16.697497531127837, 2.64, 13.57078281, 0.10949688335916519},
   {5854.0, 0.951, 1.012, 4,  21.274408815918402,  2.87,  43.84439721,  0.23929918911521614},
   {5854.0, 0.951, 1.012, 4, 2.188198708650173, 1.31, 23.9800854, 0.16004138760462955},
   {5854.0, 0.951, 1.012, 4, 0.5047990916354442, 0.79, 6.164876, 0.06470652170843269}
  },
  {
   {4499.0, 0.643, 0.639, 4, 5.499082874351366, 1.8, 9.034190783, 0.07327145488816135},
   {4499.0, 0.643, 0.639, 4, 0.7367213866271994, 0.9, 28.1224393, 0.1562106484733413},
   {4499.0, 0.643, 0.639, 4, 1.6160612661228089, 1.18, 45.9029768, 0.216555495953447},
   {4499.0, 0.643, 0.639, 4, 0.6457218890324189, 0.86, 4.159816554, 0.04369094408355136}
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

void settings() {
  size(1000, 1000);
}


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
  // assuming cubes[1] is the dial
  Cube dial = cubes[1];

  // case when dial is working as a slider to choose a system to display
  if (!choosingSystems) {
    // check if dial in slider box if not choosing systems
    if (SliderInBox(dial)) {
        choosingSystems = true;
    }
  } else {
    // check if dial has been moved
    if (dial.x != prevSliderX) {
      isSimulationPaused = true;
      // wait to make sure the slider is done being moved
      while (dial.x != prevSliderX) {
        prevSliderX = dial.x;
        try {
          Thread.sleep(1000);
        } catch (InterruptedException e) {
            System.err.println("sleep failed");
        }
      }
      // check if need to update system
      int chosenSystem = dial.x % 50;
      if (chosenSystem != currSystem) {
        // getting data for new system
        currSystem = chosenSystem;
        double[][] system = systems[currSystem];
        // had to add images to an ArrayList then turn that into an array because the sizes vary, maybe there's a better way?
        ArrayList<PImage> systemImages = new ArrayList<PImage>();
        for (int i = 1; i < system.length + 1; i++) {
          planetImage = loadImage(system[0] + "." + i + ".png");
          systemImages.add(planetImage);
        }
        PImage[] images = new PImage[systemImages.size()];
        images = systemImages.toArray(images);
        // update system motion and display
        mode1(cubes, system, images);
      }
    }
  }
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
    for (int i = 2; i <= systemData.length + 2; i++) {
      Cube planet = cubes[i];
      if (rocket.distance(planet.x, planet.y) < 50) {
        isNearPlanet = true;
        image(imageData[i-2], sunX, sunY);
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