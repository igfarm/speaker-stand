#!/bin/bash
OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --enable=manifold"

set -e

# Generate stands
INFILE=tripod.scad
for HEIGHT in 20 24 28
do
    MM_HEIGHT=`bc -l <<< $HEIGHT*25.4`
    ODIR=examples/${HEIGHT}-inch

    $OPENSCAD -o $ODIR/tripod.stl \
    -D 'stand_height='${MM_HEIGHT} \
    $INFILE 2> $ODIR/tube_sizes.txt

    $OPENSCAD -o $ODIR/tripod.png \
    -D 'stand_height='${MM_HEIGHT} \
    $INFILE

    $OPENSCAD -o $ODIR/tripod-hi.stl \
    -D 'stand_height='${MM_HEIGHT} \
    -D 'show_part=true' \
    -D 'part="hi"'  \
    $INFILE 

    $OPENSCAD -o $ODIR/tripod-low.stl \
    -D 'stand_height='${MM_HEIGHT} \
    -D 'show_part=true' \
    -D 'part="low"'  \
    $INFILE
done
