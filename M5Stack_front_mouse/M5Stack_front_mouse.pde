PImage front;

void setup() {
  size(800, 600, P3D);
  front = loadImage("front.jpg");
  textureMode(IMAGE);
}

void draw() {
  background(0);
  translate(width / 2, height / 2);
  scale(0.4);

  pushMatrix();
  float rotationX = map(mouseY, 0, height, PI, -PI);
  float rotationY = map(mouseX, 0, width, -PI, PI);
  rotateX(rotationX);
  rotateY(rotationY);
  drawM5StickC();
  popMatrix();
}

void drawM5StickC() {
  beginShape();
  texture(front);
  vertex(-350, -112, -350,   0,   0); //V1
  vertex( 350, -112, -350, 700,   0); //V2
  vertex( 350, -112,  350, 700, 700); //V3
  vertex(-350, -112,  350,   0, 700); //V4
  endShape();
}
