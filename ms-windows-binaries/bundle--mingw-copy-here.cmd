@echo ********************************
@echo mingw copy essentials
@echo ********************************
@echo.

@echo ********************************
@echo custom luajit binaries for console-less variant
@echo ********************************
@echo .

copy c:\opt\Dropbox\gh-repos\luajit\src\luajit.exe .
copy c:\opt\Dropbox\gh-repos\luajit\src\lua51.dll .

@echo ********************************
@echo copy DLL files and their (cascading) dependencies
@echo ********************************
@echo .

@echo ********************************
copy c:\msys64\mingw64\bin\SDL2.DLL .
copy c:\msys64\mingw64\bin\SDL2_image.DLL .
@echo ********************************
@echo.

@echo ********************************
@echo required by SDL2_image.DLL
@echo ********************************
@echo.

copy c:\msys64\mingw64\bin\LIBPNG16-16.DLL .
copy c:\msys64\mingw64\bin\LIBJPEG-8.DLL .
copy c:\msys64\mingw64\bin\LIBJXL.DLL .
copy c:\msys64\mingw64\bin\LIBTIFF-6.DLL .
copy c:\msys64\mingw64\bin\LIBWEBP-7.DLL .


copy c:\msys64\mingw64\bin\LIBGCC_S_SEH-1.DLL .
copy "c:\msys64\mingw64\bin\libstdc++-6.dll" .
copy c:\msys64\mingw64\bin\LIBBROTLIDEC.DLL .
copy c:\msys64\mingw64\bin\LIBHWY.DLL .
copy c:\msys64\mingw64\bin\LIBLCMS2-2.DLL .

copy c:\msys64\mingw64\bin\ZLIB1.DLL .
copy c:\msys64\mingw64\bin\LIBDEFLATE.DLL .
copy c:\msys64\mingw64\bin\LIBJBIG-0.DLL .
copy c:\msys64\mingw64\bin\LIBLERC.DLL .
copy c:\msys64\mingw64\bin\LIBLZMA-5.DLL .
copy c:\msys64\mingw64\bin\LIBZSTD.DLL .
copy c:\msys64\mingw64\bin\LIBSHARPYUV-0.DLL .
copy c:\msys64\mingw64\bin\LIBWINPTHREAD-1.DLL .
copy c:\msys64\mingw64\bin\LIBBROTLICOMMON.DLL .
