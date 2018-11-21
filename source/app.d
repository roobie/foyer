
/+ core imports +/
import core.atomic;
import core.thread;

/+ std imports +/
import std.stdio;
import std.string;
import std.format;
import std.concurrency;

/+ Derelict dynamic bindings +/
/+ => SDL +/
import derelict.sdl2.sdl;
// import derelict.sdl2.image;
// import derelict.sdl2.mixer;
import derelict.sdl2.ttf;
// import derelict.sdl2.net;

/+ luajit interface +/
import luajit.lua;

/+ internal imports +/
import config;
import timer;
import events;
import random_stuff;

import types.world;
import types.graphics;
import types.game_elements;

import logic.ai_processor;
import logic.move_processor;
import logic.chaos_processor;


void main() {

  WorldState world = new WorldState;
  // This example shows how to load all of the SDL2 libraries. You only need
  // to call the load methods for those libraries you actually need to load.

  // Load the SDL 2 library.
  DerelictSDL2.load();

  // Load the SDL2_image library.
  // DerelictSDL2Image.load();

  // Load the SDL2_mixer library.
  // DerelictSDL2Mixer.load();

  // Load the SDL2_ttf library
  DerelictSDL2ttf.load();

  // Load the SDL2_net library.
  // DerelictSDL2Net.load();

  // Now SDL 2 functions for all of the SDL2 libraries can be called.
  SDL_Init(SDL_INIT_EVERYTHING);
  scope(exit) SDL_Quit();

  auto windowFlags = SDL_WINDOW_OPENGL;
  auto window = SDL_CreateWindow("Foyer",
                                 SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
                                 defaultWindowWidth, defaultWindowHeight,
                                 windowFlags);
  scope(exit) SDL_DestroyWindow(window);

  auto rendererFlags = SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC;
  auto renderer = SDL_CreateRenderer(window, -1, rendererFlags);
  scope(exit) SDL_DestroyRenderer(renderer);

  version(GL) {
    auto glContext = SDL_GL_CreateContext(window);
    scope(exit) SDL_GL_DeleteContext(glContext);
    setGlAttrs();
  }

  TTF_Init();
  scope(exit) TTF_Quit();
  initSdlTtf();

  windowResized(window, world);

  {
    auto vec = world.ui.viewPort.dimensions / 2;
    for (auto i = 0; i < 10; ++i) {
      world.entities ~= makeRandomEntity(&vec);
    }
    world.entities[0]._position.xy = [0, 0];
  }

  auto timer = new Timer(TARGET_FPS);
  // TODO : move into own timer class impl

  auto message = "";
  Vector2i messagePos = [10, 10];

  SDL_Event event;
  while(!world.quit) {
    timer.startFrame();

    while (SDL_PollEvent(&event) != 0) {
      switch (event.type) {

      case SDL_QUIT:
        world.quit = true;
        break;

      case SDL_WINDOWEVENT_EXPOSED: goto case;
      case SDL_WINDOWEVENT_RESIZED:
        windowResized(window, world); break;

      case SDL_MOUSEMOTION:
        handleMousemotion(&event, world); break;
      case SDL_MOUSEWHEEL:
        handleMousewheel(&event, world); break;

      case SDL_KEYDOWN:
        handleKeydown(&event, world); break;

      default: break;
      }
    } // end event handling

    SDL_SetRenderDrawColor(renderer, 0, 0x20, 0x60, 0x40);
    SDL_RenderClear(renderer);

    /+ Game element loop here:
     - loop over all entities requiring logic to be done on them: process them with each processor.
     - render each element that is renderable (IRenderable)
     +/
    for (auto i = 0; i < world.entities.length; ++i) {
      auto entity = world.entities[i];
      if (!world.pause) {
        aiProcessor(entity, timer.dt);
        moveProcessor(entity, timer.dt);
      }
      // render if renderable
      if (entity.shouldRender()) {
        entity.render(renderer, world.camera);
      }
    }

    // global processors
    if (!world.pause) {
      chaosProcessor(world, timer.dt);
    }

    if (timer.frameCount % 20 == 0) {
      message = format("ΔT: %s s. | Actual delay: %s | Avg. FPS: %s", timer.dt, timer.actualDelaySec, timer.averageFps());
    }
    renderText(renderer, messagePos, message);

    SDL_RenderPresent(renderer);

    timer.startMeasureDelay();
    SDL_Delay(timer.getDelay());
    timer.stopMeasureDelay();

    timer.endFrame();
  } // end main loop
}

void renderText(SDL_Renderer* renderer, Vector2i pos, string message) {
    auto cmessage = toStringz(message);
    ubyte v = 0xff;
    auto color = SDL_Color(v, v, v, v);

    auto textSurface = TTF_RenderUTF8_Solid(fontMono, cmessage, color);
    scope(exit) SDL_FreeSurface(textSurface);

    auto texture = SDL_CreateTextureFromSurface(renderer, textSurface);

    int tw, th;
    TTF_SizeText(fontMono, cmessage, &tw, &th);

    auto textRect = SDL_Rect(pos.x, pos.y, tw, th);
    SDL_RenderCopy(renderer, texture, null, &textRect);
}

TTF_Font* fontMono;
TTF_Font* openFont(const string path, int size) {
  return sdlCheckNotNull!(TTF_Font*, "TTF")(TTF_OpenFont(toStringz(path), size));
}

void initSdlTtf() {
  auto defaultFontSize = 16;
  fontMono = openFont("./assets/DejaVuSansMono.ttf", defaultFontSize);
}

T sdlCheckNotNull(T, string subSystem)(T v) {
  static if (subSystem == "SDL") {
    writeln("Error, value is null: ", fromStringz(SDL_GetError()));
  }
  static if (subSystem == "TTF") {
    writeln("Error, value is null: ", fromStringz(TTF_GetError()));
  }

  if (v == null) throw new Exception("Value is null");
  return v;
}

void windowResized(SDL_Window* window, WorldState world) {
  SDL_GetWindowSize(window, &world.ui.viewPort.dimensions.x, &world.ui.viewPort.dimensions.y);
  world.camera.viewPortCenter.xy = world.ui.viewPort.dimensions / 2;
}
