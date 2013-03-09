import 'dart:html';

final int MAX_WIDTH = 800;
final int MAX_HEIGHT = 600;

void main() {

  CanvasElement gameContainer = query('#gamecontainer');

  window.setImmediate(() {
    gameContainer.width = MAX_WIDTH;
    gameContainer.height = MAX_HEIGHT;

    gameContainer.context2d.fillText("@", MAX_WIDTH/2, MAX_HEIGHT/2);
  });
}