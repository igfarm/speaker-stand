/*
This file is part of the speaker-stand project.

The speaker-stand project is free software: you can redistribute it 
and/or modify it under  the terms of the GNU General Public License 
as published by the Free Software Foundation, either version 3 of 
the License, or (at your option) any later version.

The speaker-stand project is distributed in the hope that it will be 
useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
General Public License for more details.

You should have received a copy of the GNU General Public License along 
with the project. If not, see <https://www.gnu.org/licenses/>.
*/
$fn = 72;
include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screws.scad>

// Basic stats
stand_height = 28 * INCH;
base_width = 13 * INCH;
platform_width = 6 * INCH;
platform_height = 0.75 * INCH;
platform_angle = 10;

//
// https://pvcfittingstore.com/pages/pvc-pipe-sizes-and-dimensions
//
leg_odiam = 1.315 * INCH;// FORMUFIT 1" Size Furniture Grade PVC Pipe
leg_idiam = 1.049 * INCH;
truss_odiam = 1.050 * INCH;// FORMUFIT 3/4" Furniture Grade PVC pipe
truss_idiam = 0.824 * INCH;

// Adornments
spike_diam = 16;
spike_length = 27;
sphere_diameter = 0.75 * INCH;

// Flags to show different things
show_part = true;
part = "platform";// Values are hi, low, platform

show_spike = true;
show_top = true;
show_inner = false;

show_guide = false;

taper_length = INCH;

// Calculated values
alt_stand_height = stand_height - platform_height;

// Where the trusses live
low_truss_height = INCH * 2.5;
hi_truss_height = alt_stand_height - 1.5 * INCH;

// Oversize thread diamater adjusment.
// This value works using Prusa Mini+ using PLA
thread_ajsument = 0.3;

base_diamater = base_width / sqrt(3) * 2;
base_radius = base_diamater / 2;
top_diameter = platform_width / sqrt(3) * 2 - leg_odiam * 2;
top_radius = top_diameter / 2;
top_offset = (sqrt(3) - 1) * platform_width / 2 - top_radius;

hi_truss_radius = hi_truss_height * (top_radius - base_radius) / alt_stand_height + base_radius;
hi_truss_length = hi_truss_radius * sqrt(3);

low_truss_radius = low_truss_height * (top_radius - base_radius) / alt_stand_height + base_radius;
low_truss_length = low_truss_radius * sqrt(3);

leg_length = sqrt(alt_stand_height ^ 2 + (base_radius - top_radius) ^ 2);
leg_angle = atan((base_radius - top_radius) / alt_stand_height);

th = base_width * sqrt(3) / 2;

module my_thread(diameter, pitch, length) {
  if (show_part)
    translate([0, 0, length / 2])
      threaded_rod(d = diameter + thread_ajsument, height = length, pitch = pitch, $fa = 0.5, $fs = 0.5, internal = true);
  else
    translate([0, 0, -1])
      cylinder(length + 1, diameter / 2, diameter / 2);
}

module leg(show_length = false) {
  hi_taper_line = spike_length + taper_length;

  leg_tube_length = (hi_truss_height - low_truss_height) / cos(leg_angle) - truss_odiam * 2;
  if (show_length) {
    echo("leg tube length");
    echo(leg_tube_length);
  }

  union() {
    rotate([0, leg_angle, 0]) {
      // The leg
      difference() {
        union() {
          // Leg
          translate([0, 0, hi_taper_line])
            cylinder(leg_length - hi_taper_line - taper_length - sphere_diameter / 2, leg_odiam / 2, leg_odiam / 2);

            // Top taper
          translate([0, 0, leg_length - taper_length - sphere_diameter / 2])
            cylinder(taper_length, leg_odiam / 2, spike_diam / 2 * 1.5);

            // Bottom taper
          translate([0, 0, spike_length]) {
            difference() {
              cylinder(taper_length, spike_diam / 2 * 1.5, leg_odiam / 2);
              my_thread(diameter = 6, pitch = 1, length = 15);
            }
          }
        }

        // Make a place for sphere to rest
        translate([0, 0, leg_length - sphere_diameter / 2])
          sphere(d = sphere_diameter);

          // Expose inner tube
        if (show_inner || show_part)
          translate([0, 0, truss_odiam + low_truss_height])
            difference() {
              cylinder(leg_tube_length, leg_odiam / 2 + 1, leg_odiam / 2 + 1);
              cylinder(leg_tube_length, leg_idiam / 2, leg_idiam / 2);
            }
      }
      if (!show_inner && !show_part)
        translate([0, 0, truss_odiam + low_truss_height])
          color("grey")
            cylinder(leg_tube_length, leg_odiam / 2 + 0.1, leg_odiam / 2 + 0.1);


            // Spike
      if (show_spike && !show_part)
        color("grey") {
          translate([0, 0, 0])
            cylinder(spike_length, 0, spike_diam / 2);

          translate([0, 0, leg_length - sphere_diameter / 2])
            sphere(d = sphere_diameter);
        }

    }

  }
}

module truss_with_sleeve(truss_length, show_length = false) {
  truss_tube_length = low_truss_length - truss_idiam * 4;
  if (show_length) {
    echo("low truss tube length");
    echo(truss_tube_length);
  }

  union() {
    // The truss
    difference() {
      cylinder(truss_length, truss_odiam / 2, truss_odiam / 2);
      if (show_inner || show_part)
        translate([0, 0, truss_idiam * 2])
          difference() {
            cylinder(truss_tube_length, truss_odiam / 2 + 2, truss_odiam / 2 + 2);
            cylinder(truss_tube_length, truss_idiam / 2, truss_idiam / 2);
          }
    }
  }

  if (!show_inner && !show_part)
    translate([0, 0, truss_idiam * 2])
      color("grey")
        cylinder(truss_tube_length, truss_odiam / 2 + 0.1, truss_odiam / 2 + 0.1);

}

module hi_truss() {
  // Trusses in T arrengment
  translate([base_diamater / 2, 0, 0])
    rotate([0, 0, 60])
      translate([-hi_truss_length / (2 * sqrt(3)), 0, hi_truss_height])
        union() {
          rotate([90, 0, 0])
            translate([0, 0, -hi_truss_length / 2])
              cylinder(hi_truss_length, truss_odiam / 2, truss_odiam / 2);
          rotate([0, 90, 0])
            cylinder(3 / 2 * hi_truss_radius, truss_odiam / 2, truss_odiam / 2);
        }

        // Tube to connect to top plate
  translate([base_radius, 0, hi_truss_height])
    rotate([0, 0, 60])
      translate([-top_offset, 0, 0]) {
        difference() {
          alt_len = alt_stand_height - hi_truss_height - 0.125 * INCH;
          cylinder(alt_len, truss_odiam / 3, truss_odiam / 3);
          my_thread(diameter = 1 / 4 * INCH, pitch = 1 / 20 * INCH, length = alt_len);
        }
      }
}

module low_truss() {
  translate([base_diamater / 2, 0, 0])
    rotate([0, 0, 60])
      translate([-low_truss_length / (2 * sqrt(3)), 0, low_truss_height])
        union() {
          rotate([90, 0, 0])
            translate([0, 0, -low_truss_length / 2]) {
              truss_with_sleeve(low_truss_length, show_length = true);
            }
          translate([0, -low_truss_length / 2, 0])
            rotate([90, 0, -60])
              translate([0, 0, -low_truss_length])
                truss_with_sleeve(low_truss_length);
          translate([0, low_truss_length / 2, 0])
            rotate([90, 0, -120])
              translate([0, 0, -low_truss_length])
                truss_with_sleeve(low_truss_length);
        }
}

union() {
  difference() {
    union() {
      // Legs
      leg(show_length = true);
      translate([th, -base_width / 2, 0])
        rotate([0, 0, 120])
          leg();
      translate([th, base_width / 2, 0])
        rotate([0, 0, 240])
          leg();

          // Trusses
      hi_truss();
      low_truss();

    }

    // If we are just showing a part, hide things we don't want to dee
    if (show_part) {
      if (part == "low") {
        translate([-100, -400, low_truss_height + 2.5 * INCH])
          cube([800, 800, 1500]);

        translate([70, -400, -10])
          cube([800, 800, 200]);
      }

      if (part == "hi") {
        translate([-100, -400, -INCH * 4])
          cube([800, 800, alt_stand_height]);
      }

      if (part == "platform") {
        translate([-100, -400, 0])
          cube([800, 800, alt_stand_height]);
      }
    }
  }
}

if ((show_top && !show_part) || (show_part && part == "platform"))
  color("grey")
    translate([base_diamater / 2, 0, alt_stand_height + 0.75 * INCH / 2])
      rotate([0, 0, 240])
        translate([top_offset, 0, 0])
          difference() {
            cube([platform_width, platform_width, platform_height], center = true);
            translate([0, platform_width / 2 + 4, 0]) {
              rotate([-platform_angle, 0, 0])
                cube([platform_width, platform_height, 2 * platform_height], center = true);
            }
            translate([0, -platform_width / 2 - 4, 0]) {
              rotate([platform_angle, 0, 0])
                cube([platform_width, platform_height, 2 * platform_height], center = true);
            }
            translate([-platform_width / 2 - 4, 0, 0]) {
              rotate([-platform_angle, 0, 90])
                cube([platform_width, platform_height, 2 * platform_height], center = true);
            }
            translate([platform_width / 2 - 4, 0, 0]) {
              rotate([platform_angle, 0, 90])
                cube([platform_width, platform_height, 2 * platform_height], center = true);
            }
            translate([0, 0, -platform_height / 2])
              cylinder(platform_height * 2, INCH / 8 + 0.2, INCH / 8 + 0.2);

            translate([0, 0, 3])
              cylinder(INCH, 15, 15);
          }

if (show_guide)
  color("grey") {
    translate([base_radius, 0, alt_stand_height + INCH])
      cylinder(1, top_radius, top_radius);

    translate([base_radius, 0, 0])
      cylinder(1, base_radius, base_radius);

    translate([base_radius, 0, 0])
      cylinder(alt_stand_height + 50, 5, 5);
  }


