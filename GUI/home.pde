void setup() {
  size(800, 600);
  frameRate(10);
}

void draw() {
  if (mousePressed && mouseX < 400 && mouseY < 400) {
    //print("Pressed\n");
    triangle(mouseX,mouseY,mouseX + 20,mouseY,mouseX + 10,mouseY + 20);
  }
}
