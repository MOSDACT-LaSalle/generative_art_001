import ddf.minim.*;  // Import the Minim library for audio analysis
Minim minim;
AudioPlayer song;

float circlesize = 200;
int scene = 1;
PGraphics pg;
float threshold = 0.1;  // Set a threshold for amplitude to trigger the drawing
PImage img;

//scene5
int cols, rows;  // Number of columns and rows in the flow field
int scl = 20;    // Scale of each grid cell
float zOff = 0;  // Z-offset for Perlin noise, adds time-based variation

PVector[] flowfield;   // Array to hold flow vectors for each cell
Particle[] particles;  // Array to hold particles
int particleCount = 1000; // Number of particles

void setup() {
  //size(800,800,P3D);
  fullScreen(P3D);
  noCursor();
  frameRate(20);
  background(0);
  img = loadImage("3dhemafrodite1.png");
  img.resize(1920, 1080);
  
  // Initialize Minim and load audio file
  minim = new Minim(this);
  song = minim.loadFile("Ame Rej 125.wav", 1024);  // Replace with your song file
  song.play();
  
  //scene5
  cols = width / scl;
  rows = height / scl;
  
  // Create an array to hold the flow field vectors
  flowfield = new PVector[cols * rows];
  
  // Create particles
  particles = new Particle[particleCount];
  for (int i = 0; i < particleCount; i++) {
    particles[i] = new Particle();
  }
  
  background(0);  // Set background to black once, trails will fade
}

void draw() {
  draw2D();
}

void draw2D() {
  hint(DISABLE_DEPTH_TEST);
  
  if (scene == 2) {
    stroke(random(0), random(0), random(0));
    noFill();
    strokeWeight(random(5, 7));
    circlesize = circlesize + 10;
    circle(width / 2, height / 2, circlesize);
    if (circlesize > 800) {
      circlesize = 0;
    }
    filter(BLUR, 2);
  }

  if (scene == 1) {
    float amplitude = song.mix.level();
    if (amplitude > threshold) {
      noFill();
      strokeWeight(random(5, 5));
      stroke(255);
      rect(mouseX, mouseY, random(0, width), random(0, height));
      filter(BLUR, 1);
    }
  }

  //scene5
  if (scene == 3) {
    fill(0, 10);
    noStroke();
    rect(0, 0, width, height);  // Fade effect
    
    float yOff = 0;
    
    // Create flow field
    for (int y = 0; y < rows; y++) {
      float xOff = 0;
      for (int x = 0; x < cols; x++) {
        int index = x + y * cols;
        float angle = noise(xOff, yOff, zOff) * TWO_PI * 4;
        PVector v = PVector.fromAngle(angle);
        v.setMag(1);
        flowfield[index] = v;
        xOff += 0.1;
      }
      yOff += 0.1;
    }

    // Update and display particles
    for (Particle p : particles) {
      p.follow(flowfield);
      p.update();
      p.edges();
      p.show();
    }

    zOff += 0.01;
  }
}

// Particle class to represent each moving point
class Particle {
  PVector pos, vel, acc;
  float maxSpeed;
  
  Particle() {
    pos = new PVector(random(width), random(height));  // Random start position
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    maxSpeed = 5;
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void follow(PVector[] flowfield) {
    int x = int(constrain(pos.x / scl, 0, cols - 1));  // Ensure x is within bounds
    int y = int(constrain(pos.y / scl, 0, rows - 1));  // Ensure y is within bounds
    int index = x + y * cols;
    PVector force = flowfield[index];  // Get the vector from the flow field
    applyForce(force);  // Apply the vector's direction as a force
  }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  void edges() {
    if (pos.x > width) pos.x = 0;
    if (pos.x < 0) pos.x = width;
    if (pos.y > height) pos.y = 0;
    if (pos.y < 0) pos.y = height;
  }

  void show() {
    stroke(255, 600);  // White stroke with very low opacity
    strokeWeight(1);
    point(pos.x, pos.y);  // Draw the particle as a point
  }
}



void stop() {
  song.close();
  minim.stop();
  super.stop();
}

void keyPressed() {
  if (key == 'b') {
    background(0, 0, 0);
    circlesize = 0;
  }

  if (key == 'i') {
    filter(INVERT);
  }

  if (key == '1') {
    scene = 1;
  }

  if (key == '2') {
    scene = 2;
  }

  if (key == '3') {
    scene = 3;
  }

  if (key == '4') {
    scene = 4;
  }

  if (key == '5') {
    scene = 5;
  }
}
