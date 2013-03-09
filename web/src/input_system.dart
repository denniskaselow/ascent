part of ascent;

class InputSystem extends VoidEntitySystem {
  /** W. */
  const int UP = 87;
  /** A. */
  const int LEFT = 65;
  /** S. */
  const int DOWN = 83;
  /** D. */
  const int RIGHT = 68;

  Map<int, bool> keyState = new Map<int, bool>();
  RequestAnimationFrameCallback cb;
  Position pos;

  InputSystem(this.cb);

  void initialize() {
    var positionMapper = new ComponentMapper<Position>(Position, world);
    var tagManager = world.getManager(TagManager);
    Entity player = tagManager.getEntity(TAG_PLAYER);
    pos = positionMapper.get(player);

    window.onKeyDown.listen(handleKeyDown);
    window.onKeyUp.listen(handleKeyUp);
  }

  void processSystem() {
    if (keyState[UP] == true) {
      pos.y -= 1;
      createMessage(world, "UP");
    } else if (keyState[DOWN] == true) {
      pos.y += 1;
      createMessage(world, "DOWN");
    } else if (keyState[LEFT] == true) {
      pos.x -= 1;
      createMessage(world, "LEFT");
    } else if (keyState[RIGHT] == true) {
      pos.x += 1;
      createMessage(world, "RIGHT");
    }
  }

  void handleKeyDown(KeyboardEvent e) => updateKeyState(e.keyCode, true);
  void handleKeyUp(KeyboardEvent e) => updateKeyState(e.keyCode, false);

  void updateKeyState(int keyCode, bool value) {
    keyState[keyCode] = value;
    if (value) {
      window.requestAnimationFrame(cb);
    }
  }
}