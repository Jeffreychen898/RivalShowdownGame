class Player {
  PlayerData playerData;
  float frameElapsedtime;
  boolean ready;
  PVector position;
  float speed;

  Node path;
  Node hoverPath;
  ArrayList<Bullet> bullets;
  
  PVector mousePosition;
  Player() {
    ready = false;
    frameElapsedtime = 0;
    path = null;
    hoverPath = null;
    position = new PVector(100, 100);
    bullets = new ArrayList<Bullet>();
    mousePosition = new PVector(0, 0);
  }
  void getPlayer(PlayerData player) {
    playerData = player;
    ready = true;
  }
  void update(float deltaTime, GameMap map) {
    if(ready) {
      frameElapsedtime += deltaTime;
      speed = min(playerData.walkingSpeed * deltaTime, 99);
      int stepping_on_tile = map.tilemap.get(int(position.y / BLOCK_SIZE)).get(int(position.x / BLOCK_SIZE));
      TileInformation tile_info = map.mapInfo.tilesInfo.get(stepping_on_tile);
      speed *= tile_info.speed;
    }
    
    /*
    if path exist
      get the direction
      check to see if the next's parent exist
        get the direction
      if both direction are not the same
        if approaching the next tile
          set to next tile location
          path = path.parent
    */
    if(path != null) {
      PVector direction = new PVector(path.parent.location.x - path.location.x, path.parent.location.y - path.location.y);
      PVector next_direction = null;
      if(path.parent.parent != null) {
        Node next_node = path.parent;
        Node node_after = path.parent.parent;
        next_direction = new PVector(node_after.location.x - next_node.location.x, node_after.location.y - next_node.location.y);
      }
      if(!matchingPVector(direction, next_direction)) {
        PVector next_tile_position = path.parent.location.copy();
        next_tile_position.mult(BLOCK_SIZE);
        float distance = dist(position.x, position.y, next_tile_position.x, next_tile_position.y);
        if(distance < speed) {
          position.x = next_tile_position.x;
          position.y = next_tile_position.y;
          path = path.parent;
          if(path.parent == null) {
            path = null;
          }
        } else {
          direction.mult(speed);
          position.add(direction);
        }
      } else {
        PVector next_tile_position = path.parent.location.copy();
        next_tile_position.mult(BLOCK_SIZE);
        if(dist(position.x, position.y, next_tile_position.x, next_tile_position.y) < speed) {
          path = path.parent;
        }
        direction.mult(speed);
        position.add(direction);
      }
    }
    //update the bullet position
    for(int i=0;i<bullets.size();i++) {
      //bullet move
      Bullet bullet = bullets.get(i);
      bullet.position.add(bullet.velocity);
    }
  }
  void render(Camera cam) {
    mousePosition = cam.pointToWorldSpace(mouseX, mouseY);
    
    cam.position.x = lerp(cam.position.x, position.x, 0.1);
    cam.position.y = lerp(cam.position.y, position.y, 0.1);
    //render the path that player is following
    Node current = path;
    stroke(255, 0, 255);
    strokeWeight(10);
    while(current != null) {
      if(current.parent != null) {
        PVector position_one = current.location.copy();
        PVector position_two = current.parent.location.copy();
        position_one.mult(BLOCK_SIZE);
        position_two.mult(BLOCK_SIZE);
        position_one.add(BLOCK_SIZE / 2.f, BLOCK_SIZE / 2.f);
        position_two.add(BLOCK_SIZE / 2.f, BLOCK_SIZE / 2.f);
        cam.drawLine(position_one.x, position_one.y, position_two.x, position_two.y);
      }
      current = current.parent;
    }
    //render the path from the player position to the mouse
    if(path == null) {
      Node hoverpath_current = hoverPath;
      stroke(255, 255, 0);
      strokeWeight(10);
      while(hoverpath_current != null) {
        if(hoverpath_current.parent != null) {
          PVector position_one = hoverpath_current.location.copy();
          PVector position_two = hoverpath_current.parent.location.copy();
          position_one.mult(BLOCK_SIZE);
          position_two.mult(BLOCK_SIZE);
          position_one.add(BLOCK_SIZE / 2.f, BLOCK_SIZE / 2.f);
          position_two.add(BLOCK_SIZE / 2.f, BLOCK_SIZE / 2.f);
          cam.drawLine(position_one.x, position_one.y, position_two.x, position_two.y);
        }
        hoverpath_current = hoverpath_current.parent;
      }
    }
    //render the bullets
    for(Bullet bullet : bullets) {
      bullet.display(cam);
    }
    //render the player
    if(ready) {
      //frame count
      float time_per_frame = 1.f / playerData.walkingFramerate;
      int frame_count = int(frameElapsedtime / time_per_frame) % playerData.walkingFrameCount;
      imageMode(CORNER);
      cam.drawImage(playerData.walkingAnimation.get(frame_count), position.x, position.y, BLOCK_SIZE, BLOCK_SIZE);
    }
  }
  boolean matchingPVector(PVector first, PVector second) {
    if(first == null || second == null) {
      return false;
    }
    return first.x == second.x && first.y == second.y;
  }
  void setHoverPath(Node start_node) {
    hoverPath = start_node;
  }
  void getPath(Node new_path) {
    if(path == null) {
      path = new_path;
    }
  }
  void shoot() {
    //add bullet
    Bullet new_bullet = new Bullet(position.x + BLOCK_SIZE / 2, position.y + BLOCK_SIZE / 2, 5, playerData.attack, 0, playerData.bulletImage);
    PVector velocity = new PVector(mousePosition.x - position.x, mousePosition.y - position.y);
    velocity.normalize();
    velocity.mult(20);
    new_bullet.velocity = velocity;
    bullets.add(new_bullet);
  }
}
