module logic.ai_processor;

import std.random;

import random_stuff;

import types.graphics;
import types.game_elements;

public void aiProcessor(Entity e, float dt) {
  float stopThreshold = 0.04;
  float moveThreshold = 0.08;

  if (randFloat() < moveThreshold) {
    auto newMomentum = [uniform(-100, 100, rng), uniform(-100, 100, rng)];
    e._momentum = newMomentum;
  } else if (randFloat() < stopThreshold) {
    e._momentum = [0, 0];
  }
}
