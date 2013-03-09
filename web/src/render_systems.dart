part of ascent;

class TileRenderSystem extends EntityProcessingSystem {
  CanvasRenderingContext2D ctx;
  ComponentMapper<Position> posMapper;
  ComponentMapper<RenderableTile> renderableMapper;

  TileRenderSystem(this.ctx) : super(Aspect.getAspectForAllOf([Position, RenderableTile]));

  void initialize() {
    posMapper = new ComponentMapper<Position>(Position, world);
    renderableMapper = new ComponentMapper<RenderableTile>(RenderableTile, world);
  }

  void begin() {
    ctx.fillStyle = 'black';
    ctx.fillRect(0, 0, MAX_WIDTH, POS_Y_MESSAGES - TILE_HEIGHT);
  }

  void processEntity(Entity e) {
    var pos = posMapper.get(e);
    var renderable = renderableMapper.get(e);

    ctx.fillStyle = renderable.color;
    ctx.fillText(renderable.value, pos.x * TILE_WIDTH, pos.y * TILE_HEIGHT);
  }
}

class MessageRenderSystem extends EntityProcessingSystem {
  final List<String> lines = new List<String>.fixedLength(MAX_LINECOUNT);
  var lineCount = 0;
  CanvasRenderingContext2D ctx;
  ComponentMapper<Message> msgMapper;

  MessageRenderSystem(this.ctx) : super(Aspect.getAspectForAllOf([Message]));

  void initialize() {
    msgMapper = new ComponentMapper(Message, world);
  }

  void begin() {
    ctx.fillStyle = 'black';
    ctx.fillRect(0, POS_Y_MESSAGES - TILE_HEIGHT, MAX_WIDTH, MAX_HEIGHT);
    ctx.fillStyle = 'white';
    // 218 = ┌, 196 = ─, 191 = ┐, 179 = │, 192 = └, 217 = ┘
    ctx.fillText('┌──────────────────────────────────────────────────────────────────────────────┐', 0, POS_Y_MESSAGES - TILE_HEIGHT);
    for (int i = 0; i < MAX_LINECOUNT; i++) {
      ctx.fillText('│                                                                              │', 0, POS_Y_MESSAGES + i * TILE_HEIGHT);
    }
    ctx.fillText('└──────────────────────────────────────────────────────────────────────────────┘', 0, POS_Y_MESSAGES + MAX_LINECOUNT * TILE_HEIGHT);
  }

  void processEntity(Entity e) {
    var msg = msgMapper.get(e);

    var parts = msg.value.split(new RegExp(r'\s'));
    var lineWidth = 0, partWidth = 0;
    var text = "";
    for (var part in parts) {
      part = '$part ';
      partWidth = ctx.measureText(part).width;
      if (lineWidth + partWidth > MAX_TEXT_WIDTH) {
        lines[lineCount] = text;
        lineCount = (lineCount + 1) % MAX_LINECOUNT;
        text = part;
        lineWidth = partWidth;
      } else {
        lineWidth += partWidth;
        text = "$text$part";
      }
    }
    lines[lineCount] = text;
    lineCount = (lineCount + 1) % MAX_LINECOUNT;

    e.deleteFromWorld();
  }

  void end() {
    for (int i = lineCount, j = 0; i < lineCount + MAX_LINECOUNT; i++, j++) {
      ctx.fillText(lines[i % MAX_LINECOUNT], TILE_WIDTH, POS_Y_MESSAGES + j * TILE_HEIGHT);
    }
  }

}