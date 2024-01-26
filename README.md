# Tripod Speaker Stand

OpenSCAD file to create tripod speaker stand using PCV pipe and 3D printed parts.

![Tripod Stand](./assets/tripod.png | width=100)

Spikes are threaded with M4

## OpenSCAD File

OpenSCAD file is provided and can be modified to adjust the height and with of the stand, along with many other parameters.

- `stand_height`: Height of the stand, including spikes and top balls. Excludes top itself.
- `top_width`: Width of top square platform
- `top_height`: Height of top platform
- `base_width`: Distance between two legs
- `leg_odiam`: Outside diamater of leg PVC pipe
- `leg_idiam`: Inside diamater of leg PVC pipe
- `truss_odiam`: Outside diamater of truss PVC pipe
- `truss_idiam`: Inside diamater of truss PVC pipe

## Generating 3D printed parts

```
// Flags to show different things
show_part1 = true;
show_part2 = false;
show_spike = false ;
show_top = false;
show_inner = true;
use_thread = false;
show_guide = false;
```

## Materials

- [1" schedule 40 PVC pipe](https://www.amazon.com/gp/product/B085B4SGD1/)
- [3/4" schedule 40 PVC pipe (optional)](https://www.amazon.com/gp/product/B085B4Y5V6/)
- [3/4" steel balls](https://www.amazon.com/gp/product/B07D9SSKN8/)
- [Speaker spikes](https://www.amazon.com/gp/product/B09K3H8FD9/)
- Sand to fill legs
- 1/4"-20 bolt to connect top plate to stand
- 6"x6" plywood top plate
- Epoxy to glue parts

## 3D Printed Parts

Top Part

![Top](./assets/part1.png)

Bottom Part

![Bottom](./assets/part2.png)

## Development

First prototype

![First Prototype](./assets/prototype1.png)
