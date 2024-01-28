#!/bin/bash
OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --enable=manifold"

set -e

# Generate stands
INFILE=../../tripod.scad
for HEIGHT in 28 24 20
do
    echo "Processing ${HEIGHT}"
    HEIGHT_MM=`bc -l <<< $HEIGHT*25.4`
    pushd examples/${HEIGHT}-inch

    # Check if something has changed
    rm -rf tmp
    mkdir tmp

    $OPENSCAD -o tmp/tripod-tmp.stl \
        -D 'stand_height='${HEIGHT_MM} \
        $INFILE

    echo 'difference(){import("../tripod.stl");import("tripod-tmp.stl");}' > tmp/diff.scad
    $OPENSCAD -o tmp/result.stl \
        -D 'stand_height='${HEIGHT_MM} \
        tmp/diff.scad > tmp/diff.txt 2>&1  || true

    if grep -q "Current top level object is empty." tmp/diff.txt; then
        echo "No changes"
    else
        # There are changes, generate files again
        $OPENSCAD -o tripod.stl \
            -D 'stand_height='${HEIGHT_MM} \
            $INFILE 2> tube_sizes.txt

        $OPENSCAD -o tripod.png \
            -D 'stand_height='${HEIGHT_MM} \
            $INFILE

        $OPENSCAD -o $ODIR/tripod-hi.stl \
            -D 'stand_height='${HEIGHT_MM} \
            -D 'show_part=true' \
            -D 'part="hi"'  \
            $INFILE 

        $OPENSCAD -o $ODIR/tripod-low.stl \
        -D 'stand_height='${HEIGHT_MM} \
            -D 'show_part=true' \
            -D 'part="low"'  \
            $INFILE

        $OPENSCAD -o $ODIR/tripod-platform.stl \
            -D 'stand_height='${HEIGHT_MM} \
            -D 'show_part=true' \
            -D 'part="platform"'  \
            $INFILE
    fi
    rm -rf tmp
    popd
done
