PImage front, back, right, left, top, bottom;
import processing.serial.*;

Serial port;

void setup() {
  size(1460, 860, P3D);
  front = loadImage("front.jpg");
  back = loadImage("back.jpg");
  right = loadImage("right.jpg");
  left = loadImage("left.jpg");
  top = loadImage("top.jpg");
  bottom = loadImage("bottom.jpg");
  textureMode(IMAGE);

  String[] ports = Serial.list();
  
  for (int i = 0; i < ports.length; i++) {
    println(i + ": " + ports[i]);
  }
  port = new Serial(this, ports[1], 115200);
}

void draw() {
  if (port.available() == 0) return;

  String str = port.readStringUntil('\n');
  if (str == null) return;

  String toks[] = split(trim(str), ",");
  if (toks.length != 3) return;

  float roll = float(toks[0]);
  float pitch = -float(toks[1]);
  float yaw = 180 - float(toks[2]);
  print(yaw); print(", ");
  print(pitch); print(", ");
  println(roll);

  background(0);
  translate(width / 2, height / 2);
  scale(0.4);

  pushMatrix();
  float c1 = cos(radians(roll));
  float s1 = sin(radians(roll));
  float c2 = cos(radians(pitch));
  float s2 = sin(radians(pitch));
  float c3 = cos(radians(yaw));
  float s3 = sin(radians(yaw));
  applyMatrix(c2*c3, s1*s3+c1*c3*s2, c3*s1*s2-c1*s3, 0,
              -s2, c1*c2, c2*s1, 0,
              c2*s3, c1*s2*s3-c3*s1, c1*c3+s1*s2*s3, 0,
              0, 0, 0, 1);

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
