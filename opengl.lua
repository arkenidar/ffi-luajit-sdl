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
ffi.cdef(io.open('ffi_defs_gl.h', 'r'):read('*a'))

local SDL = ffi.load('SDL2')

local libraries = {}
libraries.GL = { Linux = 'GL', Windows = 'openGL32' }
libraries.GLU = { Linux = 'GLU', Windows = 'GLU32' }
local GL = ffi.load(libraries.GL[ffi.os])
local GLU = ffi.load(libraries.GLU[ffi.os])

--require("sdl-defs")(SDL)
require("opengl-defs")(GL, GLU, SDL)
--====================================

SDL_Init(0)

local window_width, window_height = 400, 300
local window = SDL_CreateWindow("opengl in sdl", 50, 50, window_width, window_height, SDL_WINDOW_OPENGL)

context = SDL_GL_CreateContext(window)

function update(mouse_position, mouse_down)
  -- to be defined
end

local bit = require("bit")
local binary_or = bit.bor

local angle = 0

function draw()
  -- update scene

  angle = angle + 1

  -- draw scene

  local lightPosition = ffi.new("float[4]", 15, 10, 5, 1)
  local lightAmbient = ffi.new("float[4]", 0.1, 0.1, 0.1, 1)
  local lightDiffuse = ffi.new("float[4]", 0.9, 0.9, 0.9, 1)

  local redMaterial = ffi.new("float[4]", 1, 0, 0, 1)
  local blueMaterial = ffi.new("float[4]", 0, 0, 1, 1)

  local greyMaterial = ffi.new("float[4]", 0.5, 0.5, 0.5, 1)
  local greenMaterial = ffi.new("float[4]", 0, 1, 0, 1)

  glViewport(0, 0, window_width, window_height);

  glClearColor(1, 1, 1, 0);
  glClear(binary_or(GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT));
  glEnable(GL_DEPTH_TEST);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(30, window_width / window_height, 1, 200);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  gluLookAt(20, 5, 40, 0, 0, 0, 0, 1, 0);

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
  glScalef(factor, factor, factor);
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
-- "assets/cube.obj" was corrected in loading (previous loader was conflicting vertex normals, super-imposed, re-assigned)
-- "assets/head.obj" more complex and more memory intensive also (memory use improvement)
model = load_obj_file("assets/head.obj")
print("loading: " .. (model and "OK" or "failed!"))

function draw_model(model)
  local triangles, indexable_vertex_position_xyz, indexable_vertex_normal_xyz = model[1], model[2], model[3]
  glBegin(GL_TRIANGLES)
  for _, triangle in ipairs(triangles) do
    local position_indices = triangle.vertex_position_indices
    local normal_indices = triangle.vertex_normal_indices

    -- vertex 1
    local normal1 = indexable_vertex_normal_xyz[normal_indices[1]]
    glNormal3f(normal1[1], normal1[2], normal1[3])

    local position1 = indexable_vertex_position_xyz[position_indices[1]]
    glVertex3f(position1[1], position1[2], position1[3])

    -- vertex 2
    local normal2 = indexable_vertex_normal_xyz[normal_indices[2]]
    glNormal3f(normal2[1], normal2[2], normal2[3])

    local position2 = indexable_vertex_position_xyz[position_indices[2]]
    glVertex3f(position2[1], position2[2], position2[3])

    -- vertex 3
    local normal3 = indexable_vertex_normal_xyz[normal_indices[3]]
    glNormal3f(normal3[1], normal3[2], normal3[3])

    local position3 = indexable_vertex_position_xyz[position_indices[3]]
    glVertex3f(position3[1], position3[2], position3[3])
  end

  glEnd()
end

-- // (cleaner) code import from gltest.cpp (part of https://fox-toolkit.org/)

-- // Draws a simple box using the given corners
function drawBox(xmin, ymin, zmin, xmax, ymax, zmax)
  glBegin(GL_TRIANGLE_STRIP);
  glNormal3f(0., 0., -1.);
  glVertex3f(xmin, ymin, zmin);
  glVertex3f(xmin, ymax, zmin);
  glVertex3f(xmax, ymin, zmin);
  glVertex3f(xmax, ymax, zmin);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
  glNormal3f(1., 0., 0.);
  glVertex3f(xmax, ymin, zmin);
  glVertex3f(xmax, ymax, zmin);
  glVertex3f(xmax, ymin, zmax);
  glVertex3f(xmax, ymax, zmax);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
  glNormal3f(0., 0., 1.);
  glVertex3f(xmax, ymin, zmax);
  glVertex3f(xmax, ymax, zmax);
  glVertex3f(xmin, ymin, zmax);
  glVertex3f(xmin, ymax, zmax);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
  glNormal3f(-1., 0., 0.);
  glVertex3f(xmin, ymin, zmax);
  glVertex3f(xmin, ymax, zmax);
  glVertex3f(xmin, ymin, zmin);
  glVertex3f(xmin, ymax, zmin);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
  glNormal3f(0., 1., 0.);
  glVertex3f(xmin, ymax, zmin);
  glVertex3f(xmin, ymax, zmax);
  glVertex3f(xmax, ymax, zmin);
  glVertex3f(xmax, ymax, zmax);
  glEnd();

  glBegin(GL_TRIANGLE_STRIP);
  glNormal3f(0., -1., 0.);
  glVertex3f(xmax, ymin, zmax);
  glVertex3f(xmax, ymin, zmin);
  glVertex3f(xmin, ymin, zmax);
  glVertex3f(xmin, ymin, zmin);
  glEnd();
end

--=============================

local event = ffi.new("SDL_Event")
local looping = true

local mouse_position = { 0, 0 }
local mouse_down = false

while looping do
  while SDL_PollEvent(event) ~= 0 do
    if event.type == SDL_QUIT or
        (event.type == SDL_KEYDOWN and event.key.keysym.sym == SDLK_ESCAPE)
    then
      looping = false
    elseif event.type == SDL_MOUSEBUTTONDOWN then
      mouse_down = true
    elseif event.type == SDL_MOUSEBUTTONUP then
      mouse_down = false
    elseif event.type == SDL_MOUSEMOTION then
      mouse_position = { event.button.x, event.button.y }
    end
  end

  update(mouse_position, mouse_down)

  draw()

  SDL_GL_SwapWindow(window)
end

SDL_Quit()
