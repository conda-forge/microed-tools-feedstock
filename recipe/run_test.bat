@echo off

idoc2smv                                               ^
    -f -d 2640.0 -k 2 -m -o "#.img" -r 0.09 -z EST5EDT ^
    "%PREFIX%\share\microed-data\movie23.idoc"         ^
    "%PREFIX%\share\microed-data\movie23_000.tif"
(
    echo 61220847e866ac7b9ffe90cc83120918  1.img
) | sed -e "s/[[:space:]]*$//" | md5sum -c -
if errorlevel 1 exit /b 1

tiff2smv                                               ^
    -f -d 2640.0 -k 2 -m -o "#.img" -r 0.09 -z EST5EDT ^
    "%PREFIX%\share\microed-data\movie23_000.tif"
(
    echo ee89d1d974c2a1a541eaa570493f16cf  1.img
) | sed -e "s/[[:space:]]*$//" | md5sum -c -
if errorlevel 1 exit /b 1

tvips2smv                                              ^
    -f -d 2640.0 -k 2 -m -o "#.img" -r 0.09 -z EST5EDT ^
    "%PREFIX%\share\microed-data\movie23_000.tvips"
(
    echo 61220847e866ac7b9ffe90cc83120918  1.img
    echo c17a439c07636884b1b17d1ca5913d43  2.img
) | sed -e "s/[[:space:]]*$//" | md5sum -c -
if errorlevel 1 exit /b 1
