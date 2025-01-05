#! /bin/sh

idoc2smv                                               \
    -f -D 2640.0 -k 2 -m -o "#.img" -R 0.09 -Z EST5EDT \
    "${PREFIX}/share/microed-data/movie23.idoc"        \
    "${PREFIX}/share/microed-data/movie23_000.tif"
cat << EOF | md5sum -c -
58f000e026493093977a946a3c4284d6  1.img
EOF

tiff2smv                                               \
    -f -D 2640.0 -k 2 -m -o "#.img" -R 0.09 -Z EST5EDT \
    "${PREFIX}/share/microed-data/movie23_000.tif"
cat << EOF | md5sum -c -
24d7be15550ae5e9f54a9d80f85850f6  1.img
EOF

tvips2smv                                              \
    -f -D 2640.0 -k 2 -m -o "#.img" -R 0.09 -Z EST5EDT \
    "${PREFIX}/share/microed-data/movie23_000.tvips"
cat << EOF | md5sum -c -
7cf2401e011a88c3bbfe8bb82330c951  1.img
3174b06e9a831424e516f77929d3959d  2.img
EOF
