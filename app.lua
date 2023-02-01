local ffi = require("ffi")
--[[
https://gist.github.com/creationix/1213280/a97d7051decb2f1d3e8844186bbff49b6442700a
-- Parse the C API header
-- It's generated with:
--
--     echo '#include <SDL.h>' > stub.c
--     gcc -I /usr/include/SDL -E stub.c | grep -v '^#' > ffi_SDL.h
--]]
ffi.cdef( io.open('ffi_defs.h','r'):read('*a') )
local SDL = ffi.load('SDL2')

SDL.SDL_Init(0)
local window = SDL.SDL_CreateWindow("title", 50,50, 400,300, 0)
local window_surface = SDL.SDL_GetWindowSurface(window)

function image_load(name)
  local file = SDL.SDL_RWFromFile(name..".bmp", "rb")
  return SDL.SDL_LoadBMP_RW(file, 1)
end
function image_transparency(image_surface,rgb)
  local key = SDL.SDL_MapRGB(window_surface.format,rgb[1],rgb[2],rgb[3])
  SDL.SDL_SetColorKey(image_surface, SDL.SDL_TRUE, key)  
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
SDL.SDL_FillRect(window_surface, rect_from_xywh(xywh), SDL.SDL_MapRGB(window_surface.format,rgb[1],rgb[2],rgb[3]))
end

function surface_draw_image(image_surface, xywh)
SDL.SDL_UpperBlitScaled(image_surface, nil, window_surface, rect_from_xywh(xywh) )
end

local image_surface = image_load("transparence")
local rgb = {0,0,255} -- key color (blue is transparent)
image_transparency(image_surface,rgb)

local event = ffi.new("SDL_Event")
local looping = true
while looping do
  while SDL.SDL_PollEvent(event) ~= 0 do
    if event.type == SDL.SDL_QUIT or
    ( event.type == SDL.SDL_KEYDOWN and event.key.keysym.sym == SDL.SDLK_ESCAPE ) 
    then
        looping = false
    end
  end

  local rgb={255,255,0}
  local xywh={0,0, 100, 100}

  surface_draw_rect(rgb, xywh)

  surface_draw_image(image_surface, xywh)

  SDL.SDL_UpdateWindowSurface(window)

end

SDL.SDL_FreeSurface(image_surface)

SDL.SDL_Quit()
