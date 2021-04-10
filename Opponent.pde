class Opponent {
  int characterChoice;
  PVector position;
  Opponent() {
    characterChoice = 0;
    position = new PVector(0, 0);
  }
  void update(float deltaTime) {
  }
  void render(Camera cam) {
    cam.drawRect(position.x, position.y, BLOCK_SIZE, BLOCK_SIZE);
  }
}
