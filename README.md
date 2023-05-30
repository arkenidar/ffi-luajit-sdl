
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
