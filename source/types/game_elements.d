module types.game_elements;

import std.stdio;
import std.conv;

import derelict.sdl2.sdl;

import gfm.math.vector;
import gfm.math.matrix;

import types.graphics;

size_t idCounter = 0;

immutable invY = Vector2f(1.0, -1.0);

public abstract class Entity : IRenderable {
public:
  size_t id;
  Vector2i _position;
  Vector2i _momentum;
  double _rotation;
}

public class Box : Entity {
private:

  SDL_Rect getRect(Mat3f transform, Camera camera) {
    auto v = Vector3f(_position[0], _position[1], 1);
    auto p = transform * v;
    return SDL_Rect(roundTo!int(p[0]),
                    roundTo!int(p[1]),
                    roundTo!int(10 * camera.scale),
                    roundTo!int(10 * camera.scale));
  }

public:
  SDL_Color _color;

  this(Vector2i position, SDL_Color color) {
    id = ++idCounter;
    _position = [position[0], position[1]];
    _momentum = [0, 0];
    _rotation = 0.0;
    _color = color;
  }

  bool shouldRender() { return true; }

  void render(SDL_Renderer* renderer, Camera camera) {
    auto mat = Mat3f.identity();

    // // invert y axis
    // mat.scale(invY);
    // // translate to center of screen
    // mat.translate(camera.viewPortCenter);
    // // rotate
    // mat = mat.rotateX(camera.rotationX);
    // mat = mat.rotateY(camera.rotationY);
    // // scale distances
    // mat.scale(Vector2f(camera.scale, camera.scale));
    // // make position of camera center of screen
    // mat.translate(-camera.position);

    mat.translate(camera.viewPortCenter);
    // rotation?
    mat.scale(Vector2f(camera.scale, camera.scale));
    mat.translate(-camera.position);

    ubyte v = 0xaa;
    auto c = _color;
    SDL_SetRenderDrawColor(renderer, c.r, c.g, c.b, c.a);
    auto rect = getRect(mat, camera);
    SDL_RenderFillRect(renderer, &rect);
  }
}
