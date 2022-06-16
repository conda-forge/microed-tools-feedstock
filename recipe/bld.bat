@echo off

if not "%PKG_BUILDNUM%" == "0" sed                                        ^
    -e "s:^\(MICROED_TOOLS_VERSION_BUILDMETADATA=\).*$:\1%PKG_BUILDNUM%:" ^
    -i "%SRC_DIR%\MICROED-TOOLS-VERSION-FILE"
type "%SRC_DIR%\MICROED-TOOLS-VERSION-FILE"

cmake %CMAKE_ARGS%                                            ^
    -DBUILD_PYTHON_MODULE:BOOL=ON                             ^
    -DCMAKE_BUILD_TYPE:STRING=Release                         ^
    -DCMAKE_C_FLAGS:STRING="%CFLAGS% /W3"                     ^
    -DCMAKE_CXX_FLAGS:STRING="%CXXFLAGS% /W3"                 ^
    -DCMAKE_THREAD_LIBS_INIT:PATH="%LIBRARY_LIB%\pthread.lib" ^
    -DNLOPT_LIBRARIES:PATH="%LIBRARY_LIB%\nlopt.lib"          ^
    -DPython3_EXECUTABLE:PATH="%PYTHON%"                      ^
    "%SRC_DIR%"
if errorlevel 1 exit /b 1

cmake --build . --config Release --parallel "%CPU_COUNT%"
if errorlevel 1 exit /b 1

cmake --install . --config Release --prefix "%PREFIX%"
if errorlevel 1 exit /b 1

src\Release\tiff2smv -V
