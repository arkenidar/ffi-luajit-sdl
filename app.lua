
local ffi = require("ffi")

-- Parse the C API header
-- It's generated with:
--
--     echo '#include <SDL2/SDL.h>' >> includes.c
--     gcc -E includes.c | grep -v '^#' > ffi_defs.h
--

ffi.cdef( io.open('ffi_defs.h','r'):read('*a') )

local SDL = ffi.load('SDL2')

SDL.SDL_Init(0)
local window = SDL.SDL_CreateWindow("title", 50,50, 400,300, 0)
local renderer = SDL.SDL_CreateRenderer(window, -1, 0)

local window_surface = SDL.SDL_GetWindowSurface(window)

--********************************************

-- load assets

local file = SDL.SDL_RWFromFile("transparence.bmp", "rb")
local image_surface = SDL.SDL_LoadBMP_RW(file, 1)

---local image_surface = SDL.SDL_LoadBMP("transparence.bmp")
local window_surface = SDL.SDL_GetWindowSurface(window)
local rgb = {0,0,255} -- key color (blue is transparent)
local key = SDL.SDL_MapRGB(window_surface.format,rgb[1],rgb[2],rgb[3])
SDL.SDL_SetColorKey(image_surface, SDL.SDL_TRUE, key)

-- utility
function rect_from_xywh(xywh)
if xywh == nil then return nil end
local rect = ffi.new('SDL_Rect')
rect.x = xywh[1]
rect.y = xywh[2]
rect.w = xywh[3]
rect.h = xywh[4]
return rect
end

----
  function draw_rect_renderer(rgb, xywh)
    SDL.SDL_SetRenderDrawColor(renderer,rgb[1],rgb[2],rgb[3],255)
    SDL.SDL_RenderFillRect(renderer, rect_from_xywh(xywh))
  end

  function draw_rect_surface(rgb, xywh)
    SDL.SDL_FillRect(window_surface, rect_from_xywh(xywh), SDL.SDL_MapRGB(window_surface.format,rgb[1],rgb[2],rgb[3]))
  end
---
  function draw_image_texture(image_texture, xywh)
    SDL.SDL_RenderCopy(renderer, image_texture, nil, rect_from_xywh(xywh))
  end

  function draw_image_surface(image_surface, xywh)
    SDL.SDL_UpperBlitScaled(image_surface, nil, window_surface, rect_from_xywh(xywh) )
  end
--***********************************

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

  --draw_rect_renderer(rgb, xywh)
  draw_rect_surface(rgb, xywh)
  
  --draw_image_texture(image_texture, xywh)
  draw_image_surface(image_surface, xywh)

  --SDL.SDL_RenderPresent(renderer)
  SDL.SDL_UpdateWindowSurface(window)

end

SDL.SDL_Quit()
