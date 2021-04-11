class Bullet {
  PVector initalPosition, position;
  float bspeed, bdamage, ang;
  PImage img;
  // load image in external variable and place into constructior
  Bullet(float x, float y, float bspeed, float bdamage, float ang, PImage image) {
    initalPosition = new PVector(x, y);
    position = new PVector(x, y);
    this.ang = ang;
    this.bspeed = bspeed;
    this.bdamage = bdamage;
    img = image;
    img.resize(45, 45);
  }
  void display(Camera cam) {
    imageMode(CENTER);
    cam.drawImageRotated(img, position.x, position.y, 45, 45, ang);
  }
}
