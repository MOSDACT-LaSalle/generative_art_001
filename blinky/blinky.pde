//blinky
//by Sandra Davis, 2024

int f = 0;  
int b = 255; 

void setup() {
  size(800, 800);
  rectMode(CENTER);
  strokeCap(RECT);
  frameRate(2.5);
}

void draw() {
  
  //random inversion
  if (random(1) < 0.5) {
    f = 0;  
    b = 255;  
  } else {
    f = 255;  
    b = 0;   
  }
  if (random(1) < 0.5) {
    f = 0;    
    b = 255;  
    f = 255;  
    b = 0;    
  }
  
  background(b);  
  fill(f);       
  noStroke();     
  
  //random circle or square
  if (random(1) < 0.5) {
    circle(width / 2, height / 2, 450);  
  } else {
    square(width / 2, height / 2, 450);  
  }
  
  //line that looks like a rectangle
  float linex1 = random(width);
  float liney1 = random(height);
  float linex2 = random(width);
  float liney2 = random(height);
  stroke (f);
  strokeWeight(random(100,500));
  line(linex1, liney1, linex2, liney2);
  
  //red circle
  float x = random(width);
  float y = random(height);
  float diameter = random(20,400);
  noStroke();
  fill (#E80A02);
  circle(x,y,diameter);
  
  applyGrain();
}

//Alba G. Corral's grain effect
void applyGrain() {
  // Colores base
  color baseColor = color(230, 230, 255); // Un color muy claro, casi blanco
  float noiseScale = 0.5; // Escala del noise para granularidad más fina
  
  loadPixels(); // Prepara los píxeles para ser modificados
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float noiseValue = noise(x * noiseScale, y * noiseScale); // Valor de noise
      float brightnessOffset = map(noiseValue, 0, 1, -10, 10); // Ajuste de brillo más sutil
      
      // Calcula el color ajustado por noise
      color newColor = color(
        red(baseColor) + brightnessOffset,
        green(baseColor) + brightnessOffset,
        blue(baseColor) + brightnessOffset
      );
      
      pixels[x + y * width] = lerpColor(pixels[x + y * width], newColor, 0.1); // Mezcla el color original con el ruido
    }
  }
  updatePixels(); // Actualiza la pantalla con los nuevos píxeles
}
