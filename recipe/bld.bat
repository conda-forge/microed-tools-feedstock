@echo off

if not "%PKG_BUILDNUM%" == "0" sed                                        ^
    -e "s:^\(MICROED_TOOLS_VERSION_BUILDMETADATA=\).*$:\1%PKG_BUILDNUM%:" ^
    -i.bak "%SRC_DIR%\MICROED-TOOLS-VERSION-FILE"

cmake %CMAKE_ARGS%                                   ^
    -DBUILD_PYTHON_MODULE:BOOL=ON                    ^
    -DCMAKE_BUILD_TYPE:STRING=Release                ^
    -DCMAKE_C_FLAGS:STRING="%CFLAGS% /W3"            ^
    -DCMAKE_CXX_FLAGS:STRING="%CXXFLAGS% /EHsc /W3"  ^
    -DNLOPT_LIBRARIES:PATH="%LIBRARY_LIB%\nlopt.lib" ^
    -DPython3_EXECUTABLE:PATH="%PYTHON%"             ^
    "%SRC_DIR%"
if errorlevel 1 exit /b 1

cmake --build . --config Release
if errorlevel 1 exit /b 1

cmake --install . --prefix "%PREFIX%"
if errorlevel 1 exit /b 1

md "%PREFIX%\share\man\man1"
if errorlevel 1 exit /b 1
move "%PREFIX%\share\man\"*.1 "%PREFIX%\share\man\man1"
if errorlevel 1 exit /b 1

md "%PREFIX%\share\man\man5"
if errorlevel 1 exit /b 1
move "%PREFIX%\share\man\"*.5 "%PREFIX%\share\man\man5"
if errorlevel 1 exit /b 1

md "%PREFIX%\share\%PKG_NAME%"
if errorlevel 1 exit /b 1
move "%PREFIX%\share\doc\LICENSE" "%PREFIX%\share\%PKG_NAME%"
if errorlevel 1 exit /b 1
move "%PREFIX%\share\doc\README" "%PREFIX%\share\%PKG_NAME%"
if errorlevel 1 exit /b 1
