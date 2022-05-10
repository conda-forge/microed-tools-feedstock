@echo off

if not "%PKG_BUILDNUM%" == "0" set buildmetadata=%PKG_BUILDNUM%
(
    echo MICROED_TOOLS_VERSION_BRANCH=experimental/jiffies
    echo MICROED_TOOLS_VERSION_BUILDMETADATA=%buildmetadata%
    echo MICROED_TOOLS_VERSION_OBJECT_NAME=a496c67
    echo MICROED_TOOLS_VERSION_PRERELEASE=dev.6
    echo MICROED_TOOLS_VERSION_STATE=
    echo PACKAGE_VERSION_MAJOR=0
    echo PACKAGE_VERSION_MINOR=1
    echo PACKAGE_VERSION_PATCH=0
    echo PACKAGE_VERSION_TWEAK=0
) > "%SRC_DIR%\tvips\MICROED-TOOLS-VERSION-FILE"

cmake -G "MinGW Makefiles" %CMAKE_ARGS%                               ^
    -DBUILD_PYTHON_MODULE:BOOL=OFF                                    ^
    -DCMAKE_C_COMPILER=gcc                                            ^
    -DCMAKE_C_FLAGS:STRING="%CFLAGS% -D_POSIX_C_SOURCE=200809L -Wall" ^
    -DCMAKE_COLOR_MAKEFILE:BOOL=OFF                                   ^
    -DCMAKE_CXX_COMPILER=g++                                          ^
    -DCMAKE_CXX_FLAGS:STRING="%CXXFLAGS% -Wall"                       ^
    -DNLOPT_LIBRARIES:PATH="%LIBRARY_LIB%\nlopt.lib"                  ^
    "%SRC_DIR%\tvips"
if errorlevel 1 exit /b 1

cmake --build . --parallel "%CPU_COUNT%"
if errorlevel 1 exit /b 1

cmake --install . --prefix "%PREFIX%"
if errorlevel 1 exit /b 1

pandoc --from=gfm                          ^
       --to=plain+shortcut_reference_links ^
       --output=README                     ^
       --reference-links                   ^
       "%SRC_DIR%\README.md"
if errorlevel 1 exit /b 1

install -D -m 644                      ^
    README                             ^
    "%PREFIX%\share\%PKG_NAME%\README"
if errorlevel 1 exit /b 1

del CMakeCache.txt
rd /q /s CMakeFiles
cmake -G "NMake Makefiles"                    ^
    -DBUILD_PYTHON_MODULE:BOOL=ON             ^
    -DCMAKE_BUILD_TYPE:STRING=Release         ^
    -DCMAKE_C_FLAGS:STRING="%CFLAGS% /W3"     ^
    -DCMAKE_CXX_FLAGS:STRING="%CXXFLAGS% /W3" ^
    -DPython3_EXECUTABLE:PATH="%PYTHON%"      ^
    "%SRC_DIR%\tvips"
if errorlevel 1 exit /b 1

cmake --build . --config Release --parallel "%CPU_COUNT%" --target pysmv
if errorlevel 1 exit /b 1

cmake --install . --component module --config Release --prefix "%SP_DIR%"
if errorlevel 1 exit /b 1
