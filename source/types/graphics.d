module types.graphics;

import derelict.sdl2.sdl;

import gfm.math.vector;
import gfm.math.matrix;

public interface IRenderable {
  void render(SDL_Renderer* renderer, Camera cam);
  bool shouldRender();
}

public alias Vector2i = Vector!(int, 2);
public alias Vector2f = Vector!(float, 2);
public alias Vector3f = Vector!(float, 3);
public alias Mat2f = Matrix!(float, 2, 2);
public alias Mat3f = Matrix!(float, 3, 3);

public class Camera {
  Vector2f position;
  Vector2f viewPortCenter;
  float scale;
  float rotationX;
  float rotationY;

  this() {
    this.position = Vector2f(0, 0);
    this.viewPortCenter = Vector2f(0, 0);
    this.scale = 1.0;
    this.rotationX = 0.0;
    this.rotationY = 0.0;
  }
}
