module random_stuff;

import std.random;

import derelict.sdl2.sdl;

import types.graphics;
import types.game_elements;

public immutable auto seed = 0xdeadbeef;
public auto rng = Random(seed);

public float randFloat() {
  return uniform(0.0, 1.0, rng);
}
public ubyte randByte() {
  return cast(ubyte)uniform(0, 0xff, rng);
}

public Entity makeRandomEntity(const Vector2i* positionRadius) {
  Vector2i pos = [uniform(-positionRadius.x, positionRadius.x, rng),
                  uniform(-positionRadius.y, positionRadius.y, rng)];
  auto color = SDL_Color(randByte(), randByte(), randByte(), randByte());
  return new Box(pos, color);
}
