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

local ffi = require("ffi")
--[[
https://gist.github.com/creationix/1213280/a97d7051decb2f1d3e8844186bbff49b6442700a
-- Parse the C API header
-- It's generated with:
--
--     echo '#include <SDL.h>' > stub.c
--     gcc -I /usr/include/SDL -E stub.c | grep -v '^#' > ffi_SDL.h
--]]
ffi.cdef(io.open('ffi_defs.h', 'r'):read('*a'))
local SDL = ffi.load('SDL2')      -- sudo apt install libsdl2-dev
_G = setmetatable(_G, {
  __index = function(self, index) -- index function CASE
    if "SDL" == string.sub(index, 1, 3) then
      return SDL[index]
    end
  end
})

SDL_Init(0)
local window = SDL_CreateWindow("title", 50, 50, 400, 300, 0)
local window_surface = SDL_GetWindowSurface(window)

function image_load(name)
  local file = SDL_RWFromFile(name .. ".bmp", "rb")
  return SDL_LoadBMP_RW(file, 1)
end

function image_transparency(image_surface, rgb)
  local key = SDL_MapRGB(window_surface.format, rgb[1], rgb[2], rgb[3])
  SDL_SetColorKey(image_surface, SDL_TRUE, key)
end

function rect_from_xywh(xywh)
  if xywh == nil then return nil end
  local rect = ffi.new('SDL_Rect')
  rect.x = xywh[1]
  rect.y = xywh[2]
  rect.w = xywh[3]
  rect.h = xywh[4]
  return rect
end

function surface_draw_rect(rgb, xywh)
  SDL_FillRect(window_surface, rect_from_xywh(xywh), SDL_MapRGB(window_surface.format, rgb[1], rgb[2], rgb[3]))
end

function surface_draw_image(image_surface, xywh)
  SDL_UpperBlitScaled(image_surface, nil, window_surface, rect_from_xywh(xywh))
end

local image_surface = image_load("transparence")
local rgb = { 0, 0, 255 } -- key color (blue is transparent)
image_transparency(image_surface, rgb)

local event = ffi.new("SDL_Event")
local looping = true

local movement = 0

while looping do
  -- update (before draw)

  while SDL_PollEvent(event) ~= 0 do
    if event.type == SDL_KEYDOWN and event.key.keysym.sym == SDLK_RIGHT then
      movement = movement + 10
    elseif event.type == SDL_KEYDOWN and event.key.keysym.sym == SDLK_LEFT then
      movement = movement - 10
    end

    if event.type == SDL_QUIT or
        (event.type == SDL_KEYDOWN and event.key.keysym.sym == SDLK_ESCAPE)
    then
      -- exit
      looping = false
      break
    end
  end

  if not looping then break end

  -- draw (after update)

  surface_draw_rect({ 255, 255, 255 }) -- draw-begin: clear

  local rgb = { 255, 255, 0 }
  local xywh = { 0, 0, 100, 100 }

  surface_draw_rect(rgb, xywh)

  xywh[1] = xywh[1] + xywh[3] + movement -- image put aside
  surface_draw_image(image_surface, xywh)

  SDL_UpdateWindowSurface(window) -- draw-end: present
end

SDL_FreeSurface(image_surface)

SDL_Quit()
