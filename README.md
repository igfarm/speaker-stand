# Tripod Speaker Stand

This is an OpenSCAD file for creating a tripod speaker stand using PVC pipe and 3D printed components.

<img src="./assets/tripod.png" width="800">

The top plate for the speaker is attached with a single 1/4"-20 screw. The bottom of the stand features threaded spikes.

<img src="./assets/29-inch-tripod.png" width="400">

## OpenSCAD File

The provided OpenSCAD file allows customization of various stand dimensions and features:

- `default_height`: Total height of the stand, including spikes and top plate.
- `default_width`: Distance between two legs.
- `plate_width`: Width of top plate.
- `plate_height`: Height of top plate.
- `leg_odiam`: Outside diamater of leg PVC pipe.
- `leg_idiam`: Inside diamater of leg PVC pipe.
- `show_part`: Render the part to be printed. Values are `top`, `bottom`, `plate`, `all`, and `hero`.

Adjust these and other parameters to tailor the stand to your requirements.

Additional display options include toggling the visibility of the spikes, top plate, and inner diameter PVC pipe.

**Note:** The BOSL2 library is required for thread generation. Installation details are available at https://github.com/BelfrySCAD/BOSL2

## Generating 3D Printed Parts using SCAD File

To create printable 3D parts using the SCAD file:

- `default_show`: part to show, values are "all", "hi", "low", "plate", and "test"

These parts are suitable for printing on a Prusa Mini printer with a 7"x7"x7" bed.

## Materials

This is a sample list using vendors in the US.

- 1" schedule 40 PVC pipe for legs and trusses
- Speaker spikes with M6 thread ([Amazon Link](https://www.amazon.com/gp/product/B09K3H8FD9/)) ([AliExpress Link](hhttps://www.aliexpress.us/item/3256804460518547.html))

- 3/4" Steel balls ([Amazon Link](https://www.amazon.com/gp/product/B07D9SSKN8/))
- 1/4"-20 bolt to connect top plate to stand
- Epoxy to glue connectors to tubes
- 3D printed parts
- Sand to fill the legs
- Paint

Please print the test article to make sure the PVC pipe pipe and threads fit. Adjust the source code as needed.

## Construction Notes

See the wiki at https://github.com/igfarm/speaker-stand/wiki

## 3D Printed Parts

### Plate (optional)

This is probably done better with MDF or plywoood.

<img src="./assets/platform.png" width="400">

### Top Connector

<img src="./assets/part-hi.png" width="400">

### Bottom Connector

<img src="./assets/part-low.png" width="400">

### Test Article

<img src="./assets/prototype2-test.png" width="400">

## Development

### Third Prototype

<img src="./assets/prototype3.png" width="400">

### Second Prototype

<img src="./assets/prototype2.png" width="400">

Starting to look like the real thing.

- Need to fine tune the gemoetry.
- Print orientation is importat to get proper fitting parts.
- Added a print test article.

<img src="./assets/prototype2-test.png" width="400">

### First Prototype

<img src="./assets/prototype1.png" width="400">

This proof of concept was made using old PVC pipes found in the garage.
