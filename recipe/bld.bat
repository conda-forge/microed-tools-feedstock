@echo off

if not "%PKG_BUILDNUM%" == "0" sed                                        ^
    -e "s:^\(MICROED_TOOLS_VERSION_BUILDMETADATA=\).*$:\1%PKG_BUILDNUM%:" ^
    -i.bak "%SRC_DIR%\MICROED-TOOLS-VERSION-FILE"

cmake %CMAKE_ARGS%                                   ^
    -DBUILD_PYTHON_MODULE:BOOL=ON                    ^
    -DCMAKE_BUILD_TYPE:STRING=Release                ^
    -DCMAKE_C_FLAGS:STRING="%CFLAGS% /W3"            ^
    -DCMAKE_CXX_FLAGS:STRING="%CXXFLAGS% /EHsc /W3"  ^
    -DCMAKE_INSTALL_DATADIR:PATH="%PREFIX%\share\%PKG_NAME%" ^
    -DCMAKE_INSTALL_DOCDIR:PATH="%PREFIX%\share\doc\%PKG_NAME%" ^
    -DCMAKE_INSTALL_PREFIX:PATH="%PREFIX%"           ^
    -DNLOPT_LIBRARIES:PATH="%LIBRARY_LIB%\nlopt.lib" ^
    -DPython3_EXECUTABLE:PATH="%PYTHON%"             ^
    "%SRC_DIR%"
if errorlevel 1 exit /b 1

cmake --build . --config Release
if errorlevel 1 exit /b 1

cmake --install .
if errorlevel 1 exit /b 1
