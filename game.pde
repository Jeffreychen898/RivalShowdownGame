class GameState extends States {
  GameMap gameMap;
  MapData sampleMap;
  PImage mapImg;
  Camera gameCamera;
  float aspectRatio;
  Player player;
  PlayerData playerData;
  Opponent opponent;
  boolean ready;
  GameState() {
    sampleMap = new MapData("res/grassyLand");
    gameMap = new GameMap();
    
    playerData = new PlayerData("res/characters/pyromancer");
    player = new Player();

    opponent = new Opponent();

    PVector campos = new PVector(0, 0);
    aspectRatio = float(height) / float(width);
    float camheight = 1600.f * aspectRatio;
    PVector camsize = new PVector(1600, camheight);
    gameCamera = new Camera(campos, camsize);
    ready = false;
  }
  void update(float deltaTime) {
    //parse requests
    ArrayList<HashMap<String, String>> requests = Networking_recieve();
    if(requests != null) {
      for(HashMap<String, String> request : requests) {
        if(request.get("name").equals("opponent")) {
          //set the player position
          int player_position = Integer.parseInt(request.get("position"));
          player.position = new PVector(player_position, player_position);
          //set the opponent's sprite
          opponent.characterChoice = Integer.parseInt(request.get("character"));
          //set ready to true
          ready = true;
        } else if(request.get("name").equals("update_character_position")) {
          float new_position_x = Float.parseFloat(request.get("positionX"));
          float new_position_y = Float.parseFloat(request.get("positionY"));
          opponent.position = new PVector(new_position_x, new_position_y);
        }
      }
    }

    if(ready) {
      //get the player hover path(player path to mouse)
      if(gameMap.ready) {
        PVector mouse_position = gameCamera.pointToWorldSpace(mouseX, mouseY);
        PVector player_position = player.position.copy();
        mouse_position.x = int(mouse_position.x / BLOCK_SIZE);
        mouse_position.y = int(mouse_position.y / BLOCK_SIZE);
        player_position.x = int(player_position.x / BLOCK_SIZE);
        player_position.y = int(player_position.y / BLOCK_SIZE);
        PVector start_tile = new PVector(gameCamera.position.x - gameCamera.size.x / 2, gameCamera.position.y - gameCamera.size.y / 2);
        PVector end_tile = new PVector(gameCamera.position.x + gameCamera.size.x / 2, gameCamera.position.y + gameCamera.size.y / 2);
        start_tile.x = int(start_tile.x / BLOCK_SIZE);
        start_tile.y = int(start_tile.y / BLOCK_SIZE);
        end_tile.x = int(end_tile.x / BLOCK_SIZE) + 1;
        end_tile.y = int(end_tile.y / BLOCK_SIZE) + 1;
        Astar pathfinder = new Astar(player_position, mouse_position, gameMap.tilemap, gameMap.mapInfo.tilesInfo, start_tile, end_tile);
        player.setHoverPath(pathfinder.path);
      }
      //update other parts of the game
      player.update(deltaTime, gameMap);
      //update the opponent
      opponent.update(deltaTime);

      //send the player position
      Networking_send("character_position", "positionX=" + player.position.x + "&positionY=" + player.position.y);
    }
  }
  void render() {
    if(ready) {
      gameMap.getMap(sampleMap);
      player.getPlayer(character.get(selectedPlayerIndex));
      gameMap.render(gameCamera);
      player.render(gameCamera);
      opponent.render(gameCamera);
    }
  }
  void keyPressed(char k) {
  }
  void keyReleased(char k) {
  }
  void mouseWheel(float offset) {
    if(ready) {
      gameCamera.size.x += (gameCamera.size.x * 0.05) * offset;
      gameCamera.size.y += (gameCamera.size.y * 0.05) * offset;
      gameCamera.size.x = max(1000, gameCamera.size.x);
      gameCamera.size.y = max(1000 * aspectRatio, gameCamera.size.y);
      gameCamera.size.x = min(3000, gameCamera.size.x);
      gameCamera.size.y = min(3000 * aspectRatio, gameCamera.size.y);
    }
  }
  void mousePressed(int button) {
    if(ready) {
      if(button == RIGHT) {
        PVector mouse_position = gameCamera.pointToWorldSpace(mouseX, mouseY);
        PVector player_position = player.position.copy();
        mouse_position.x = int(mouse_position.x / BLOCK_SIZE);
        mouse_position.y = int(mouse_position.y / BLOCK_SIZE);
        player_position.x = int(player_position.x / BLOCK_SIZE);
        player_position.y = int(player_position.y / BLOCK_SIZE);
        PVector start_tile = new PVector(gameCamera.position.x - gameCamera.size.x / 2, gameCamera.position.y - gameCamera.size.y / 2);
        PVector end_tile = new PVector(gameCamera.position.x + gameCamera.size.x / 2, gameCamera.position.y + gameCamera.size.y / 2);
        start_tile.x = int(start_tile.x / BLOCK_SIZE);
        start_tile.y = int(start_tile.y / BLOCK_SIZE);
        end_tile.x = int(end_tile.x / BLOCK_SIZE) + 1;
        end_tile.y = int(end_tile.y / BLOCK_SIZE) + 1;
        Astar pathfinder = new Astar(player_position, mouse_position, gameMap.tilemap, gameMap.mapInfo.tilesInfo, start_tile, end_tile);
        player.getPath(pathfinder.path);
      } else if(button == LEFT) {
        player.shoot();
      }
    }
  }
}
