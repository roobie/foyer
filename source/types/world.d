module types.world;

import types.graphics;
import types.game_elements;

public struct ViewPort {
  Vector2i dimensions;
}

public struct UserInterface {
  ViewPort viewPort;
}

public class WorldState {
  bool quit;
  bool pause;

  Camera camera = new Camera();

  Entity[] entities;

  UserInterface ui;
}
