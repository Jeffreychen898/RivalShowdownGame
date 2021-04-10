class EndState extends States {

  EndState() {
  }

  void render() {
background(138, 201, 232, 70);
fill(255, 255, 0);
textSize(60);
textAlign(CENTER, TOP);
text("You Win!", width/2, height/4);
image(returnPrompt,450,height/2);
  }
  
  void keyPressed(char k){
    if(key == 'r'){
      gameState = 1;
    }
  }
}
