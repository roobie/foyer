import std.stdio;
import std.math;

import derelict.sdl2.sdl;

import types.world;
/+
 Handles keyboard keydown events from SDL
 +/
public void handleKeydown(SDL_Event* event, WorldState world) {

  switch (event.key.keysym.sym) {

  case SDLK_q:
    world.quit = true;
    return;

  case SDLK_SPACE:
    auto curr = world.pause;
    world.pause = true;
    return;

  case SDLK_u:
    world.camera.scale = fmin(world.camera.scale + 0.1, 10);
    return;

  case SDLK_j:
    world.camera.scale = fmax(world.camera.scale - 0.1, 0.1);
    return;

  case SDLK_h:
    world.camera.rotationX -= 0.1;
    return;

  case SDLK_l:
    world.camera.rotationX += 0.1;
    return;

  case SDLK_i:
    world.camera.rotationY -= 0.1;
    return;

  case SDLK_k:
    world.camera.rotationY += 0.1;
    return;

  case SDLK_p: {
    writeln("Scale: ", world.camera.scale);
    writeln("Rot: ", world.camera.rotationX, "||", world.camera.rotationY);
    writeln("Pos: ", world.camera.position);
    writeln("Cent: ", world.camera.viewPortCenter);
    return;
  }

  case SDLK_UP:
    world.camera.position += [  0, -50];
    return;
  case SDLK_DOWN:
    world.camera.position += [  0,  50];
    return;
  case SDLK_LEFT:
    world.camera.position += [-50,   0];
    return;
  case SDLK_RIGHT:
    world.camera.position += [ 50,   0];
    return;

  default: return;
  }
}

public void handleMousemotion(SDL_Event* event, WorldState world) {
  
}
public void handleMousewheel(SDL_Event* event, WorldState world) {
  
}
