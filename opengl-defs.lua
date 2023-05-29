---@diagnostic disable: lowercase-global
--[[
    require("opengl-defs")(GL,GLU)
]]
--=============================================
return function(GL,GLU)

glViewport = GL.glViewport
glClearColor = GL.glClearColor
glClear = GL.glClear

GL_MODELVIEW=0x1700
GL_PROJECTION=0x1701
GL_TEXTURE=0x1702
glMatrixMode = GL.glMatrixMode
glLoadIdentity = GL.glLoadIdentity

GL_TRIANGLES = 4
GL_TRIANGLE_STRIP = 5

glBegin = GL.glBegin
glEnd = GL.glEnd
glColor3f = GL.glColor3f
glNormal3f = GL.glNormal3f
glVertex3f = GL.glVertex3f

gluPerspective = GLU.gluPerspective
gluLookAt = GLU.gluLookAt

glMaterialfv = GL.glMaterialfv
GL_FRONT =0x0404
GL_AMBIENT =0x1200
GL_DIFFUSE =0x1201

GL_SMOOTH =0x1D01
glShadeModel = GL.glShadeModel

glLightfv = GL.glLightfv
GL_LIGHT0=0x4000
GL_LIGHT1=0x4001
GL_LIGHT2=0x4002
GL_LIGHT3=0x4003
GL_LIGHT4=0x4004
GL_LIGHT5=0x4005
GL_LIGHT6=0x4006
GL_LIGHT7=0x4007

GL_AMBIENT=0x1200
GL_DIFFUSE=0x1201
GL_SPECULAR=0x1202
GL_POSITION=0x1203

glEnable = GL.glEnable
GL_LIGHTING=0x0B50
GL_DEPTH_TEST=0x0B71

GL_DEPTH_BUFFER_BIT=0x00000100
GL_COLOR_BUFFER_BIT=0x00004000

glPushMatrix = GL.glPushMatrix
glPopMatrix = GL.glPopMatrix
glTranslated = GL.glTranslated
glRotated = GL.glRotated

end
--===========================