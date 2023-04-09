local ffi = require("ffi")

local SDL = ffi.load('SDL2')

local libraries={}
libraries.GL={Linux='GL',Windows='openGL32'}
libraries.GLU={Linux='GLU',Windows='GLU32'}

local GL = ffi.load(libraries.GL[ffi.os])
local GLU = ffi.load(libraries.GLU[ffi.os])

--[[
/* this is includes.c, processed with:

gcc -E includes.c | grep -v '^#' > ffi_defs_gl.h
*/
 #include <SDL2/SDL.h>

 #include <GL/gl.h>
 #include <GL/glu.h>

]]
ffi.cdef( io.open('ffi_defs_gl.h','r'):read('*a') )

SDL.SDL_Init(0)

--[[
(SublimeText's "find in files" shows this)

/usr/include/SDL2/SDL_video.h:
   98  {
   99      SDL_WINDOW_FULLSCREEN = 0x00000001,         /**< fullscreen window */
  100:     SDL_WINDOW_OPENGL = 0x00000002,             /**< window usable with OpenGL context */
  101      SDL_WINDOW_SHOWN = 0x00000004,              /**< window is visible */
  102      SDL_WINDOW_HIDDEN = 0x00000008,             /**< window is not visible */
]]
local SDL_WINDOW_OPENGL = 2
local window_width, window_height = 400, 300
local window = SDL.SDL_CreateWindow("opengl in sdl", 50,50, window_width, window_height, SDL_WINDOW_OPENGL)

context = SDL.SDL_GL_CreateContext(window)

-- #define GL_COLOR_BUFFER_BIT			0x00004000
local GL_COLOR_BUFFER_BIT	= 0x00004000

function update(mouse_position,mouse_down)
	-- to be defined
end

function draw()
  GL.glViewport(0, 0, window_width, window_height)
  GL.glClearColor(1.0, 0.0, 1.0, 0.0)
  GL.glClear(GL_COLOR_BUFFER_BIT)

	GL.glBegin(4) --   220: #define GL_TRIANGLES				0x0004
  
  GL.glColor3f(1, 0, 0)
  GL.glVertex3f(0, 0, 0)

  GL.glColor3f(0, 1, 0)
  GL.glVertex3f(1, 0, 0)

  GL.glColor3f(1, 1, 0)
  GL.glVertex3f(0, 1, 0)

	GL.glEnd()
end

local event = ffi.new("SDL_Event")
local looping = true

local mouse_position={0,0}
local mouse_down=false

while looping do

  while SDL.SDL_PollEvent(event) ~= 0 do
    if event.type == SDL.SDL_QUIT or
    ( event.type == SDL.SDL_KEYDOWN and event.key.keysym.sym == SDL.SDLK_ESCAPE ) 
    then
        looping = false

    elseif event.type == SDL.SDL_MOUSEBUTTONDOWN then
      mouse_down = true

    elseif event.type == SDL.SDL_MOUSEBUTTONUP then
      mouse_down = false
      
    elseif event.type == SDL.SDL_MOUSEMOTION then
      mouse_position = {event.button.x, event.button.y}
    end
  end

  update(mouse_position,mouse_down)

  draw()

  SDL.SDL_GL_SwapWindow(window)
end

--SDL.SDL_Quit() -- freezes in Windows
