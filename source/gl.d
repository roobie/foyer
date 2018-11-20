module gl;

void setGlAttrs() {
  version(GL) {
    glSetAttr(SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
    glSetAttr(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
    glSetAttr(SDL_GL_DOUBLEBUFFER, 1);
    glSetAttr(SDL_GL_DEPTH_SIZE, 24);
    glSetAttr(SDL_GL_STENCIL_SIZE, 8);
    glSetAttr(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    glSetAttr(SDL_GL_CONTEXT_MINOR_VERSION, 2);
    SDL_GL_SetSwapInterval(1);
  }
}
