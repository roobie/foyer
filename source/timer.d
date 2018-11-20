module timer;

import derelict.sdl2.sdl;

import std.conv;

immutable sampleSize = 1 << 5;

public class Timer {
  ulong perfreq;
  ulong actualDelay = 0;
  ulong delayTemp = 0;

  int targetFps = 50;
  int delay;
  float actualDelaySec = 0;
  int delta;
  int lastDelta;
  int startTicks;
  int frameFps;
  float dt;
  ulong frameCount = 0;

  float[sampleSize] fpsArr;

  this(uint targetFps) {
    for (int i = 0; i < sampleSize; ++i) fpsArr[i] = 0.0;

    this.targetFps = targetFps;

    perfreq = SDL_GetPerformanceFrequency();
    delay = 1000 / targetFps;
    delta = delay;
    lastDelta = delay;
    dt = cast(float)(delta) / 1000.0;
  }

  void startFrame() {
    ++frameCount;
    delta = lastDelta;
    startTicks = SDL_GetTicks();
    dt = cast(float)(delta) / 1000.0;
  }

  void endFrame() {
    lastDelta = SDL_GetTicks() - startTicks;
    frameFps = 1000 / lastDelta;
    fpsArr[frameCount % sampleSize] = frameFps;
  }

  void startMeasureDelay() {
    delayTemp = SDL_GetPerformanceCounter();
  }

  void stopMeasureDelay() {
    actualDelay = SDL_GetPerformanceCounter() - delayTemp;
    actualDelaySec = cast(float)(actualDelay) / perfreq;
  }

  uint getDelay() {
    return this.delay;
  }

  uint averageFps() {
    auto sum = 0;

    for (int i = 0; i < sampleSize; ++i) sum += roundTo!int(fpsArr[i]);
    return sum / sampleSize;
  }
}
