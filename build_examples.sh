#!/bin/bash
OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --enable=manifold"

# Generate stands
INFILE=./tripod.scad
for HEIGHT in 29 25 21
do
    echo "Processing ${HEIGHT}"
    HEIGHT_MM=`bc -l <<< $HEIGHT*25.4`
    ODIR="examples/${HEIGHT}-inch"

    if [ ! -d $ODIR ]; then
        echo creating dir
        mkdir $ODIR
    fi

    # CMD="${OPENSCAD} -D 'default_height=${HEIGHT_MM}'";
    CMD="${OPENSCAD} -D default_height=${HEIGHT_MM}"
    
    # There are changes, generate files again
    $CMD -o $ODIR/tripod.stl \
        $INFILE 2> $ODIR/tube_sizes.txt

cat <<EOT > $ODIR/README.md
# ${HEIGHT}" Speaker Stand

<img src="./tripod.png" width="400">

## STL Files
-   [Plate](./tripod-plate.stl)
-   [Top Brace](./tripod-hi.stl)
-   [Low Brace](./tripod-low.stl)
-   [All Parts](./tripod.stl)
-   [Test Print](./tripod-test.stl)

## Tube Lengths (in mm)
\`\`\`
EOT
grep ECHO $ODIR/tube_sizes.txt | sed 's/ECHO://' >> $ODIR/README.md
cat <<EOT >> $ODIR/README.md
\`\`\`
EOT

    rm -rf $ODIR/tube_sizes.txt

    $CMD -o $ODIR/tripod.png \
        $INFILE

    $CMD -o $ODIR/tripod-hi.stl \
        -D 'default_show="hi"'  \
        $INFILE 

    $CMD -o $ODIR/tripod-low.stl \
        -D 'default_show="low"'  \
        $INFILE

    $CMD -o $ODIR/tripod-plate.stl \
        -D 'default_show="plate"'  \
        $INFILE

    $CMD -o $ODIR/tripod-test.stl \
        -D 'default_show="test"'  \
        $INFILE
done
