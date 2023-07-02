local ffi = require("ffi")
ffi.cdef( io.open('ffi_defs.h','r'):read('*a') )
local SDL = ffi.load('SDL2')
---require("sdl-defs")(SDL)
_G=setmetatable(_G, {
	__index = function(self, index) -- index function CASE
    if "SDL"==string.sub(index,1,3) then
      return SDL[index]
    end
	end
})

SDL_Init(0)
local window = SDL_CreateWindow("title", 50,50, 400,300, 0)
local window_surface = SDL_GetWindowSurface(window)

function image_load(name)
  local file = SDL_RWFromFile(name..".bmp", "rb")
  return SDL_LoadBMP_RW(file, 1)
end
function image_transparency(image_surface,rgb)
  local key = SDL_MapRGB(window_surface.format,rgb[1],rgb[2],rgb[3])
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
SDL_FillRect(window_surface, rect_from_xywh(xywh), SDL_MapRGB(window_surface.format,rgb[1],rgb[2],rgb[3]))
end

function surface_draw_image(image_surface, xywh)
SDL_UpperBlitScaled(image_surface, nil, window_surface, rect_from_xywh(xywh) )
end

------------------------------------------------------------
function load_map(file_path)
  grid={}
  local line_count=1
  for line in io.lines(file_path) do
    local row={}
    for i=1,#line do
      local char=line:sub(i,i)
      if char=="P" then
        px=i
        py=line_count
        char=" "
      end
      table.insert(row,char)
    end
    table.insert(grid,row)
    line_count=line_count+1
  end
end

function next_map()
  if map[map_current+1] then
    map_current=1+map_current
    load_map("assets/map"..map[map_current]..".txt")
  end
end

function load()
  tile_size=32

  local player=image_load("assets/P")
  local space=image_load("assets/-")
  local wall=image_load("assets/W")
  local exit=image_load("assets/E")
  tile={P=player,[" "]=space,["#"]=wall,E=exit}
  map={"01","02","03"}
  map_current=0
  next_map()
end

load()

function draw()
  surface_draw_rect({0,0,0}, nil)
  for y=1,#grid do
    for x=1,#grid[1] do
      local tile_type=grid[y][x]
      if x==px and y==py then tile_type="P" end
      local dx,dy=(x-1)*tile_size,(y-1)*tile_size
      surface_draw_image(tile[tile_type],{dx,dy,tile_size,tile_size})
    end
  end
end

function going(tx,ty)
  local going=grid[ty][tx]
  if going~="#" then
    px,py=tx,ty
    if going=="E" then next_map() end
  end
end

function process_events()
  if key_down("space") then next_map() end
  
  local tx,ty=px,py
  if key_down("up") then ty=ty-1 end
  if key_down("down") then ty=ty+1 end
  if key_down("left") then tx=tx-1 end
  if key_down("right") then tx=tx+1 end
  
  if tx~=px or ty~=py then
    going(tx,ty)
  end
  
end

function update(mouse_position,mouse_down)
  if mouse_down then
    local mx,my=mouse_position[1],mouse_position[2]
    local tx,ty=math.floor(mx/tile_size)+1,math.floor(my/tile_size)+1
    
    if grid[ty]~=nil and grid[ty][tx]~=nil then
      if
      (math.abs(tx-px)==1 and ty==py)
      or (math.abs(ty-py)==1 and tx==px)
      then
        going(tx,ty)
      end
    end
  
  end
end
------------------------------------------------------------

local event = ffi.new("SDL_Event")

function key_down(key)
  return ( event.type == SDL_KEYDOWN and event.key.keysym.sym == SDL["SDLK_"..string.upper(key)] )
end

local looping = true

local mouse_position={0,0}
local mouse_down=false

while looping do

  while SDL_PollEvent(event) ~= 0 do
    if event.type == SDL_QUIT or key_down("escape")
    then
        looping = false

    elseif event.type == SDL_MOUSEBUTTONDOWN then
      mouse_down = true

    elseif event.type == SDL_MOUSEBUTTONUP then
      mouse_down = false
      
    elseif event.type == SDL_MOUSEMOTION then
      mouse_position = {event.button.x, event.button.y}
    end
    
    process_events()
  end
  
  update(mouse_position,mouse_down)

  draw()

  SDL_UpdateWindowSurface(window)

end

SDL_FreeSurface(image_surface)

SDL_Quit()
