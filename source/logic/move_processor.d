module logic.move_processor;

import std.conv;

import types.graphics;
import types.game_elements;

public void moveProcessor(Entity e, float dt) {
  const auto mom = e._momentum;
  e._position += [roundTo!int(mom.x * dt), roundTo!int(mom.y * dt)];
}
