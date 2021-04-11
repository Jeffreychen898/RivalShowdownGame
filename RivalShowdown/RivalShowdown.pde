import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import java.util.Date;
import java.util.UUID;
import processing.net.*;

/*
 * Game States
 *
 * 0 - Menu
 * 1 - Selection
 * 2 - Game
 * 3 - End
 */
States states[]= new States[4];
int gameState = 1;
ArrayList<PlayerData> character;
int selectedPlayerIndex;
PImage title,returnPrompt;
Minim minim;
AudioPlayer Beautiful_Rivalry;
AudioPlayer Showdown;

Client client;
final String IP = "127.0.0.1";//"73.246.174.43"; //public ip v4
final int PORT = 2345;//port 
String id;

void setup() {
  //fullScreen(P2D);
  size(1024, 768, P2D);
  id = UUID.randomUUID().toString();
  client = new Client(this, IP, PORT);
  returnPrompt = loadImage("res/backgrounds/return.png");
  returnPrompt.resize(1200,60);
   title = loadImage("res/backgrounds/title.png");
  minim = new Minim(this);
  Beautiful_Rivalry = minim.loadFile("Beautiful Rivalry.wav");
  Showdown = minim.loadFile("HeadedForAShowdown.wav");
  ((PGraphicsOpenGL)g).textureSampling(3);
  loadPlayers();
  states[2] = new GameState();
  states[0] = new MenuState();
  states[1] = new SelectionState();
  states[3] = new EndState();
}
void loadPlayers() {
  character = new ArrayList<PlayerData>();
  String[] character_list = loadStrings("res/characters/info.txt");
  for (String each_char : character_list) {
    PlayerData new_player = new PlayerData("res/characters/" + each_char);
    character.add(new_player);
  }
}
void draw() {
  // println(gameState);
  rectMode(CORNER);
  imageMode(CORNER);
  textAlign(LEFT, TOP);
  float delta_time = 1.f / frameRate;
  states[gameState].update(delta_time);

  noStroke();
  background(0);
  states[gameState].render();
}
void mousePressed() {
  states[gameState].mousePressed(mouseButton);
}
void mouseReleased() {
  states[gameState].mouseReleased(mouseButton);
}
void keyPressed() {
  states[gameState].keyPressed(key);
}
void keyReleased() {
  states[gameState].keyReleased(key);
}
void mouseWheel(MouseEvent evt) {
  states[gameState].mouseWheel(evt.getCount());
}
