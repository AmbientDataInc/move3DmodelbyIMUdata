PImage front, back, right, left, top, bottom;

void setup() {
  size(800, 600, P3D);
  front = loadImage("front.jpg");
  back = loadImage("back.jpg");
  right = loadImage("right.jpg");
  left = loadImage("left.jpg");
  top = loadImage("top.jpg");
  bottom = loadImage("bottom.jpg");
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

  beginShape();
  texture(back);
  vertex( 350,  113, -350,   0,   0); //V1
  vertex(-350,  113, -350, 700,   0); //V2
  vertex(-350,  113,  350, 700, 700); //V3
  vertex( 350,  113,  350,   0, 700); //V4
  endShape();

  beginShape();
  texture(right);
  vertex( 350,  -112, -350,   0,   0); //V1
  vertex( 350,   113, -350, 225,   0); //V2
  vertex( 350,   113,  350, 225, 700); //V3
  vertex( 350,  -112,  350,   0, 700); //V4
  endShape();

  beginShape();
  texture(left);
  vertex(-350,   113, -350,   0,   0); //V1
  vertex(-350,  -112, -350, 225,   0); //V2
  vertex(-350,  -112,  350, 225, 700); //V3
  vertex(-350,   113,  350,   0, 700); //V4
  endShape();

  beginShape();
  texture(top);
  vertex( 350,  -112, -350,   0,   0); //V1
  vertex(-350,  -112, -350, 700,   0); //V2
  vertex(-350,   113, -350, 700, 225); //V3
  vertex( 350,   113, -350,   0, 225); //V4
  endShape();

  beginShape();
  texture(bottom);
  vertex(-350,  -112,  350,   0,   0); //V1
  vertex( 350,  -112,  350, 700,   0); //V2
  vertex( 350,   113,  350, 700, 225); //V3
  vertex(-350,   113,  350,   0, 225); //V4
  endShape();
}
