@echo off

cmake %CMAKE_ARGS%                                           ^
    -DBUILD_PYTHON_MODULE:BOOL=ON                            ^
    -DCMAKE_C_FLAGS:STRING="%CFLAGS% /W3"                    ^
    -DCMAKE_CXX_FLAGS:STRING="%CXXFLAGS% /EHsc /W3"          ^
    -DCMAKE_INSTALL_DATADIR:PATH="%PREFIX%\share\%PKG_NAME%" ^
    -DCMAKE_INSTALL_PREFIX:PATH="%PREFIX%"                   ^
    -DPython3_EXECUTABLE:PATH="%PYTHON%"                     ^
    "%SRC_DIR%"
if errorlevel 1 exit /b 1

cmake --build . --config Release
if errorlevel 1 exit /b 1

cmake --install .
if errorlevel 1 exit /b 1
