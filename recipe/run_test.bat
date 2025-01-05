@echo off

idoc2smv                                               ^
    -f -D 2640.0 -k 2 -m -o "#.img" -R 0.09 -Z EST5EDT ^
    "%PREFIX%\share\microed-data\movie23.idoc"         ^
    "%PREFIX%\share\microed-data\movie23_000.tif"
(
    echo 58f000e026493093977a946a3c4284d6  1.img
) | sed -e "s/[[:space:]]*$//" | md5sum -c -
if errorlevel 1 exit /b 1

tiff2smv                                               ^
    -f -D 2640.0 -k 2 -m -o "#.img" -R 0.09 -Z EST5EDT ^
    "%PREFIX%\share\microed-data\movie23_000.tif"
(
    echo 24d7be15550ae5e9f54a9d80f85850f6  1.img
) | sed -e "s/[[:space:]]*$//" | md5sum -c -
if errorlevel 1 exit /b 1

tvips2smv                                              ^
    -f -D 2640.0 -k 2 -m -o "#.img" -R 0.09 -Z EST5EDT ^
    "%PREFIX%\share\microed-data\movie23_000.tvips"
(
    echo 7cf2401e011a88c3bbfe8bb82330c951  1.img
    echo 3174b06e9a831424e516f77929d3959d  2.img
) | sed -e "s/[[:space:]]*$//" | md5sum -c -
if errorlevel 1 exit /b 1
