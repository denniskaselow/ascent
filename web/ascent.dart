library ascent;

import 'dart:html';
import 'package:dartemis/dartemis.dart';

part 'src/components.dart';
part 'src/input_system.dart';
part 'src/render_systems.dart';

const int MAX_WIDTH = 800;
const int MAX_HEIGHT = 640;
const int TILE_WIDTH = 10;
const int TILE_HEIGHT = 16;
const int MAX_LINECOUNT = 5;
const int MAX_TEXT_WIDTH = MAX_WIDTH - 1 * TILE_WIDTH;
const int POS_Y_MESSAGES = MAX_HEIGHT - MAX_LINECOUNT * TILE_HEIGHT;

const String TAG_PLAYER = 'player';

void main() {

  var gameContainer = query('canvas#gamecontainer');

  window.setImmediate(() {
    gameContainer.width = MAX_WIDTH;
    gameContainer.height = MAX_HEIGHT;
    gameContainer.context2d.font = '16px Courier New';

    var game = new Game(gameContainer);
    game.start();
  });
}

class Game {
  CanvasElement canvas;
  World world;
  Game(this.canvas) : world = new World();

  void start() {
    Entity player = world.createEntity();
    player.addComponent(new RenderableTile('@', 'white'));
    player.addComponent(new Position(0, 0));
    player.addToWorld();

    createMessage(world, '''
Something fell from the sky and crashed down close to where you have been. You
choose to seek out the site of impact and discover something that looks like a
door. You open the door and go inside. But the door suddenly closes and you
can\'t find a way to open it. So you decide to explore the inside of this object.
''');

    var tagManager = new TagManager();
    tagManager.register(TAG_PLAYER, player);
    world.addManager(tagManager);

    world.addSystem(new InputSystem(gameLoop));
    world.addSystem(new TileRenderSystem(canvas.context2d));
    world.addSystem(new MessageRenderSystem(canvas.context2d));

    world.initialize();
    world.process();
  }

  void gameLoop(_) {
    world.process();
  }
}



void createMessage(World world, String message) {
  Entity e = world.createEntity();
  e.addComponent(new Message(message));
  e.addToWorld();
}