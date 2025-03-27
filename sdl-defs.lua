--[[
   Copyright 2025 Dario Cangialosi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]

---@diagnostic disable: lowercase-global
--[[
    require("sdl-defs")(SDL)
]]
--=============================================
return function(SDL)
  --[[
SDL_Init = SDL.SDL_Init
--SDL_WINDOW_OPENGL = 2
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
--]]

  ---[[
  --SDL_WINDOW_OPENGL = 2
  _G = setmetatable(_G, {
    __index = function(self, index) -- index function CASE
      if "SDL" == string.sub(index, 1, 3) then
        return SDL[index]
      end
    end
  })
  --]]
end
