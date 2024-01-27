# Tripod Speaker Stand

This is an OpenSCAD file for creating a tripod speaker stand using PVC pipe and 3D printed components.

<img src="./assets/tripod.png" width="400">

The top plate for the speaker is attached with a single 1/4"-20 screw. The bottom of the stand features threaded spikes.

## OpenSCAD File

The provided OpenSCAD file allows customization of various stand dimensions and features:

- `stand_height`: Total height of the stand, including spikes and top balls, excluding the height of the top plate.
- `top_width`: Width of top square platform.
- `top_height`: Height of top platform.
- `base_width`: Distance between two legs.
- `leg_odiam`: Outside diamater of leg PVC pipe.
- `leg_idiam`: Inside diamater of leg PVC pipe.
- `truss_odiam`: Outside diamater of truss PVC pipe.
- `truss_idiam`: Inside diamater of truss PVC pipe.

Adjust these parameters to tailor the stand to your requirements.

Additional display options include toggling the visibility of the spikes, top plate, and inner diameter PVC pipe.

**Note:** The BOSL2 library is required for thread generation. Installation details are available at https://github.com/BelfrySCAD/BOSL2

## Generating 3D Printed Parts using SCAD File

To create printable 3D parts using the SCAD file:

- `show_part`: set to true if you want to generate one of the parts
- `part`: part to show, values are "hi" and "low"

These parts are suitable for printing on a Prusa Mini printer with a 7"x7"x7" bed.

## Materials

- 1" schedule 40 PVC pipe for legs ([Amazon Link](https://www.amazon.com/gp/product/B085B4SGD1/))
- 3/4" schedule 40 PVC pipe for trusses ([Amazon Link](https://www.amazon.com/gp/product/B085B4Y5V6/))
- 3/4" steel balls ([Amazon Link](https://www.amazon.com/gp/product/B07D9SSKN8/))
- Speaker spikes ([Amazon Link](https://www.amazon.com/gp/product/B09K3H8FD9/))
- Sand to fill legs
- 1/4"-20 bolt to connect top plate to stand
- 6"x6" plywood top plate
- Epoxy to glue parts
- 3D printed parts

## 3D Printed Parts

Top Part

<img src="./assets/part1.png" width="400">

Bottom Part

<img src="./assets/part2.png" width="400">

## Development

### First Prototype

<img src="./assets/prototype1.png" width="400">

This proof of concept was made using old PVC pipes found in the garage.

### Second Prototype

Waiting for parts...
