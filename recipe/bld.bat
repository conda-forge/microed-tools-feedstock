@echo off

if not "%PKG_BUILDNUM%" == "0" set buildmetadata=%PKG_BUILDNUM%
(
    echo MICROED_TOOLS_VERSION_BRANCH=experimental/jiffies
    echo MICROED_TOOLS_VERSION_BUILDMETA=%buildmetadata%
    echo MICROED_TOOLS_VERSION_OBJECT_NAME=d0bd797
    echo MICROED_TOOLS_VERSION_PRERELEASE=dev.5
    echo MICROED_TOOLS_VERSION_STATE=
    echo PACKAGE_VERSION_MAJOR=0
    echo PACKAGE_VERSION_MINOR=1
    echo PACKAGE_VERSION_PATCH=0
    echo PACKAGE_VERSION_TWEAK=0
) > "%SRC_DIR%\MICROED-TOOLS-VERSION-FILE"

rem cmake -G "MinGW Makefiles" %CMAKE_ARGS%                               ^
rem     -DBUILD_PYTHON_MODULE:BOOL=OFF                                    ^
rem     -DCMAKE_C_FLAGS:STRING="%CFLAGS% -D_POSIX_C_SOURCE=200809L -Wall" ^
rem     -DCMAKE_COLOR_MAKEFILE:BOOL=OFF                                   ^
rem     -DCMAKE_CXX_FLAGS:STRING="%CXXFLAGS% -Wall"                       ^
rem     -DNLOPT_LIBRARIES:PATH="%LIBRARY_LIB%\nlopt.lib"                  ^
rem     "%SRC_DIR%"
rem if errorlevel 1 exit /b 1

rem cmake --build . --parallel "%CPU_COUNT%"
rem if errorlevel 1 exit /b 1

rem cmake --install . --prefix "%PREFIX%"
rem if errorlevel 1 exit /b 1

rem install -D -m 644                      ^
rem     "%SRC_DIR%\README"                 ^
rem     "%PREFIX%\share\%PKG_NAME%\README"
rem if errorlevel 1 exit /b 1

cmake --help
rem del CMakeCache.txt
rem rd /q /s CMakeFiles
cmake -G "NMake Makefiles"                    ^
    -DBUILD_PYTHON_MODULE:BOOL=ON             ^
    -DCMAKE_BUILD_TYPE:STRING=Release         ^
    -DCMAKE_C_FLAGS:STRING="%CFLAGS% /W3"     ^
    -DCMAKE_CXX_FLAGS:STRING="%CXXFLAGS% /W3" ^
    -DPython3_EXECUTABLE:PATH="%PYTHON%"      ^
    "%SRC_DIR%"
if errorlevel 1 exit /b 1

echo BUILDING
cmake --build . --config Release --parallel "%CPU_COUNT%" --target pysmv
if errorlevel 1 exit /b 1

echo CHECKING
cmake -L -N
if errorlevel 1 exit /b 1

echo INSTALLING
cmake --install . --component module --config Release --prefix "%SP_DIR%"
if errorlevel 1 exit /b 1
