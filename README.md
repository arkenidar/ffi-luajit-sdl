For testing and scripting I used Linuxes (Debian, Arch), and MSYS/MINGW in Windows. Looking forward for Android too (WIP).

# requirement to install
sudo apt install luajit libsdl2-dev # apt in Debian

launch with LuaJIT.org for example `luajit maze.lua`
| script | description |
|--------|-------------|
| maze.lua | 2d with input and asset loader |
| opengl.lua | 3d |
| app.lua | basic |

https://luajit.org/ext_ffi.html The FFI library allows calling external C functions and using C data structures from pure Lua code.

```
some credit and further documentation:

Using SDL from luajit's built-in ffi module
https://gist.github.com/creationix/1213280/a97d7051decb2f1d3e8844186bbff49b6442700a
-- load the luajit ffi module
local ffi = require "ffi"
-- Parse the C API header
-- It's generated with:
--
--     echo '#include <SDL.h>' > stub.c
--     gcc -I /usr/include/SDL -E stub.c | grep -v '^#' > ffi_SDL.h
--
ffi.cdef(io.open('ffi_SDL.h', 'r'):read('*a'))
-- Load the shared object
local SDL = ffi.load('SDL')
```
