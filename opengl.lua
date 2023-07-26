---@diagnostic disable: lowercase-global
--================================================
local ffi = require("ffi")
--[[
/* this is includes.c, processed with:

gcc -E includes.c | grep -v '^#' > ffi_defs_gl.h
*/
 #include <SDL2/SDL.h>

 #include <GL/gl.h>
 #include <GL/glu.h>

]]
ffi.cdef( io.open('ffi_defs_gl.h','r'):read('*a') )

local SDL = ffi.load('SDL2')

local libraries={}
libraries.GL={Linux='GL',Windows='openGL32'}
libraries.GLU={Linux='GLU',Windows='GLU32'}
local GL = ffi.load(libraries.GL[ffi.os])
local GLU = ffi.load(libraries.GLU[ffi.os])

--require("sdl-defs")(SDL)
require("opengl-defs")(GL,GLU,SDL)
--====================================

SDL_Init(0)

local window_width, window_height = 400, 300
local window = SDL_CreateWindow("opengl in sdl", 50,50, window_width, window_height, SDL_WINDOW_OPENGL)

context = SDL_GL_CreateContext(window)

function update(mouse_position,mouse_down)
	-- to be defined
end

local bit = require("bit")
local binary_or = bit.bor

local angle = 0

function draw()

  -- update scene

  angle = angle + 1

  -- draw scene

  local lightPosition = ffi.new("float[4]",15,10,5,1)
  local lightAmbient = ffi.new("float[4]",0.1,0.1,0.1,1)
  local lightDiffuse = ffi.new("float[4]",0.9,0.9,0.9,1)

  local redMaterial = ffi.new("float[4]",1,0,0,1)
  local blueMaterial = ffi.new("float[4]",0,0,1,1)

  local greyMaterial = ffi.new("float[4]",0.5,0.5,0.5,1)
  local greenMaterial = ffi.new("float[4]",0,1,0,1)

  glViewport(0, 0, window_width, window_height);

  glClearColor(1,1,1,0);
  glClear( binary_or(GL_COLOR_BUFFER_BIT ,GL_DEPTH_BUFFER_BIT) );
  glEnable(GL_DEPTH_TEST);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(30,window_width/window_height,1,200);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  gluLookAt( 20,5,40, 0,0,0, 0,1,0);

  glShadeModel(GL_SMOOTH);
  glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
  glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glMaterialfv(GL_FRONT, GL_AMBIENT, greyMaterial);
  glMaterialfv(GL_FRONT, GL_DIFFUSE, greenMaterial);

  glPushMatrix();
  glRotated(angle, 0., 1., 0.);
  ---drawBox(-1, -1, -1, 1, 1, 1);

  glPushMatrix();
  local factor = 5
  glScalef( factor, factor, factor );
  draw_model(model)
  glPopMatrix();

  --[[
  glMaterialfv(GL_FRONT, GL_AMBIENT, greyMaterial);
  glMaterialfv(GL_FRONT, GL_DIFFUSE, redMaterial);

  glPushMatrix();
  glTranslated(0.,1.75,0.);
  glRotated(angle, 0., 1., 0.);
  drawBox(-.5,-.5,-.5,.5,.5,.5);
  glPopMatrix();

  glPushMatrix();
  glTranslated(0.,-1.75,0.);
  glRotated(angle, 0., 1., 0.);
  drawBox(-.5,-.5,-.5,.5,.5,.5);
  glPopMatrix();

  glPushMatrix();
  glRotated(90., 1., 0., 0.);
  glTranslated(0.,1.75,0.);
  glRotated(angle, 0., 1., 0.);
  drawBox(-.5,-.5,-.5,.5,.5,.5);
  glPopMatrix();

  glPushMatrix();
  glRotated(90., -1., 0., 0.);
  glTranslated(0.,1.75,0.);
  glRotated(angle, 0., 1., 0.);
  drawBox(-.5,-.5,-.5,.5,.5,.5);
  glPopMatrix();

  glPushMatrix();
  glRotated(90., 0., 0., 1.);
  glTranslated(0.,1.75,0.);
  glRotated(angle, 0., 1., 0.);
  drawBox(-.5,-.5,-.5,.5,.5,.5);
  glPopMatrix();

  glPushMatrix();
  glRotated(90., 0., 0., -1.);
  glTranslated(0.,1.75,0.);
  glRotated(angle, 0., 1., 0.);
  drawBox(-.5,-.5,-.5,.5,.5,.5);
  glPopMatrix();
  
  --]]

  glPopMatrix();

end

----------------------------------------------
require("loader")
model = load_obj_file("assets/head.obj")
function draw_model(model)
  --[[
  glBegin(GL_TRIANGLE_STRIP);
    glNormal3f(0.,0.,-1.);
    glVertex3f(xmin, ymin, zmin);
    glVertex3f(xmin, ymax, zmin);
    glVertex3f(xmax, ymin, zmin);
    glVertex3f(xmax, ymax, zmin);
  glEnd();
  --]]
  glBegin(GL_TRIANGLES)

  -- glNormal3f, glVertex3f
  for _,triangle in ipairs(model) do
    local function normal(xyz) glNormal3f(xyz.x, xyz.y, xyz.z) end
    local function vertex(xyz) glVertex3f(xyz.x, xyz.y, xyz.z) end
    local function vertex_and_normal(xyz) normal(xyz.normal); vertex(xyz) end
    vertex_and_normal(triangle[1])
    vertex_and_normal(triangle[2])
    vertex_and_normal(triangle[3])
  end

  glEnd()
end

-- // (cleaner) code import from gltest.cpp (part of https://fox-toolkit.org/)

-- // Draws a simple box using the given corners
function drawBox(xmin, ymin, zmin, xmax, ymax, zmax)

  glBegin(GL_TRIANGLE_STRIP);
    glNormal3f(0.,0.,-1.);
    glVertex3f(xmin, ymin, zmin);
    glVertex3f(xmin, ymax, zmin);
    glVertex3f(xmax, ymin, zmin);
    glVertex3f(xmax, ymax, zmin);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
    glNormal3f(1.,0.,0.);
    glVertex3f(xmax, ymin, zmin);
    glVertex3f(xmax, ymax, zmin);
    glVertex3f(xmax, ymin, zmax);
    glVertex3f(xmax, ymax, zmax);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
    glNormal3f(0.,0.,1.);
    glVertex3f(xmax, ymin, zmax);
    glVertex3f(xmax, ymax, zmax);
    glVertex3f(xmin, ymin, zmax);
    glVertex3f(xmin, ymax, zmax);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
    glNormal3f(-1.,0.,0.);
    glVertex3f(xmin, ymin, zmax);
    glVertex3f(xmin, ymax, zmax);
    glVertex3f(xmin, ymin, zmin);
    glVertex3f(xmin, ymax, zmin);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
    glNormal3f(0.,1.,0.);
    glVertex3f(xmin, ymax, zmin);
    glVertex3f(xmin, ymax, zmax);
    glVertex3f(xmax, ymax, zmin);
    glVertex3f(xmax, ymax, zmax);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
    glNormal3f(0.,-1.,0.);
    glVertex3f(xmax, ymin, zmax);
    glVertex3f(xmax, ymin, zmin);
    glVertex3f(xmin, ymin, zmax);
    glVertex3f(xmin, ymin, zmin);
  glEnd();
end

--=============================

local event = ffi.new("SDL_Event")
local looping = true

local mouse_position={0,0}
local mouse_down=false

while looping do

  while SDL_PollEvent(event) ~= 0 do
    if event.type == SDL_QUIT or
    ( event.type == SDL_KEYDOWN and event.key.keysym.sym == SDLK_ESCAPE ) 
    then
        looping = false

    elseif event.type == SDL_MOUSEBUTTONDOWN then
      mouse_down = true

    elseif event.type == SDL_MOUSEBUTTONUP then
      mouse_down = false
      
    elseif event.type == SDL_MOUSEMOTION then
      mouse_position = {event.button.x, event.button.y}
    end
  end

  update(mouse_position,mouse_down)

  draw()

  SDL_GL_SwapWindow(window)
end

SDL_Quit()
