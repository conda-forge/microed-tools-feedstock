@echo off

idoc2smv                                                 ^
    -f -d 2640 -k 2 -m -o "t_###.img" -r 0.09 -z EST5EDT ^
    "%PREFIX%\share\microed-data\movie23.idoc"
(
    echo 3e1e31afd68927b0ceb0c533924253af  t_001.img
) | sed -e "s/[[:space:]]*$//" | md5sum -c -
if errorlevel 1 exit /b 1

tiff2smv                                                 ^
    -f -d 2640 -k 2 -m -o "t_###.img" -r 0.09 -z EST5EDT ^
    "%PREFIX%\share\microed-data\movie23_000.tif"
(
    echo 564befe3319bd4acc4d8ee53aaa73de7  t_001.img
) | sed -e "s/[[:space:]]*$//" | md5sum -c -
if errorlevel 1 exit /b 1

tvips2smv                                                ^
    -f -d 2640 -k 2 -m -o "t_###.img" -r 0.09 -z EST5EDT ^
    "%PREFIX%\share\microed-data\movie23_000.tvips"
(
    echo 241fcb1756df99625d2e2e2a8599029e  t_001.img
    echo fe6acc3c3c3701c56e27d46019038a58  t_002.img
) | sed -e "s/[[:space:]]*$//" | md5sum -c -
if errorlevel 1 exit /b 1
