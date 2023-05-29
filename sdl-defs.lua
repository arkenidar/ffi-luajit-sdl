---@diagnostic disable: lowercase-global
--[[
    require("sdl-defs")(SDL)
]]
--=============================================
return function(SDL)
SDL_Init = SDL.SDL_Init
SDL_WINDOW_OPENGL = 2
SDL_CreateWindow = SDL.SDL_CreateWindow
SDL_GL_CreateContext = SDL.SDL_GL_CreateContext
SDL_PollEvent = SDL.SDL_PollEvent
SDL_QUIT = SDL.SDL_QUIT
SDL_KEYDOWN = SDL.SDL_KEYDOWN
SDLK_ESCAPE = SDL.SDLK_ESCAPE
SDL_MOUSEBUTTONDOWN = SDL.SDL_MOUSEBUTTONDOWN
SDL_MOUSEBUTTONUP = SDL.SDL_MOUSEBUTTONUP
SDL_MOUSEMOTION = SDL.SDL_MOUSEMOTION
SDL_GL_SwapWindow = SDL.SDL_GL_SwapWindow
SDL_Quit = SDL.SDL_Quit
end