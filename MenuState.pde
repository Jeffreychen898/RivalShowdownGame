class MenuState extends States {

  MenuState() {
  }

  void render() {
    if(gameState == 0){
      Beautiful_Rivalry.play();
    }else{
      Beautiful_Rivalry.pause();
    }
    if(Beautiful_Rivalry.position() >= 12800){
      Beautiful_Rivalry.rewind();
    }
    background(127, 0, 255);
    fill(255, 255, 0);
    textAlign(CENTER, TOP);
    textSize(60);
     image(title,width/2-700,height/2-200);
    text("Press Space To Select", width/2, height/4 + height/2);
  }

  void keyPressed(char k) {
    if (k== ' ') {
      gameState = 1;
    }
  }
}
