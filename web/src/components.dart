part of ascent;

class RenderableTile implements Component {
  String value, color;
  RenderableTile._();
  static RenderableTile _constructor() => new RenderableTile._();
  factory RenderableTile(String value, String color) {
    RenderableTile component = new Component(RenderableTile, _constructor);
    component.value = value;
    component.color = color;
    return component;
  }
}

class Position implements Component {
  int x, y;
  Position._();
  static Position _constructor() => new Position._();
  factory Position(int x, int y) {
    Position component = new Component(Position, _constructor);
    component.x = x;
    component.y = y;
    return component;
  }
}

class Message implements Component {
  String value;
  Message._();
  static Message _constructor() => new Message._();
  factory Message(String value) {
    Message component = new Component(Message, _constructor);
    component.value = value;
    return component;
  }
}