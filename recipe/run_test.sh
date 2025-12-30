#! /bin/sh

idoc2smv                                               \
    -f -D 2640.0 -k 2 -m -o "#.img" -R 0.09 -Z EST5EDT \
    "${PREFIX}/share/microed-data/movie23.idoc"        \
    "${PREFIX}/share/microed-data/movie23_000.tif"
cat << EOF | md5sum -c -
016a33d02180e252136c518b8306c0fe  1.img
EOF

tiff2smv                                               \
    -f -D 2640.0 -k 2 -m -o "#.img" -R 0.09 -Z EST5EDT \
    "${PREFIX}/share/microed-data/movie23_000.tif"
cat << EOF | md5sum -c -
0941fee076755ddf14d301e55d5764e3  1.img
EOF

tvips2smv                                              \
    -f -D 2640.0 -k 2 -m -o "#.img" -R 0.09 -Z EST5EDT \
    "${PREFIX}/share/microed-data/movie23_000.tvips"
cat << EOF | md5sum -c -
d00a6392e0e79a7cc6959084f3c5a0a9  1.img
c59d52a49692af8754d8d62613beffa4  2.img
EOF
