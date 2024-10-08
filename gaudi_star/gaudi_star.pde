//guadi star
//sandra davis
//july 24 2024


int minLines = 40; 
int maxLines = 80; 
int numLines; 
float startX, endX;
float[] startY, endY;
float speed = 2;
int currentLine = 0;
boolean lineDrawn = false;

void setup() {
  size(1920, 1080); 
  startX = width / 2;
  endX = width / 4;
  chooseNumberOfLines();
  initializePositions();
  background(209, 161, 77); 
  stroke(#403305); 
  strokeWeight(0.05);
}

void draw() {
  for (int i = 0; i <= currentLine; i++) {
    float lineEndX = startX - i * ((width / 2.0 - width / 4.0) / (numLines - 1));
    line(startX, startY[i], lineEndX, endY[i]);
    line(width - startX, startY[i], width - lineEndX, endY[i]);
    line(startX, height - startY[i], lineEndX, height - endY[i]);
    line(width - startX, height - startY[i], width - lineEndX, height - endY[i]);
  }

  if (!lineDrawn) {
    delay(100); 
    lineDrawn = true; 
  } else if (currentLine < numLines - 1) {
    currentLine++; 
    lineDrawn = false; 
  } else if (currentLine >= numLines - 1) {
    chooseNumberOfLines();
    initializePositions();
    currentLine = 0; 
    lineDrawn = false;

  }
}

void chooseNumberOfLines() {
  numLines = int(random(minLines, maxLines + 1)); 
}

void initializePositions() {
  startY = new float[numLines];
  endY = new float[numLines];

  float startYIncrement = (height / 2.0) / (numLines - 1);
  for (int i = 0; i < numLines; i++) {
    startY[i] = i * startYIncrement; 
    endY[i] = height / 2; 
  }
}
