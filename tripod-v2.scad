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

// ../formatter/scadformat/scadformat ./tripod.scad

$fn = 72;
include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screws.scad>

default_height = 29 * INCH;
default_width = 14 * INCH;
default_show = "all";


module _stand(height, width, show) {

  base_width = width;
  stand_height = height;

  plate_width = 6.5 * INCH;
  plate_depth = 7 * INCH;
  plate_height = 0.75 * INCH;
  plate_angle = 10;

  // https://pvcfittingstore.com/pages/pvc-pipe-sizes-and-dimensions
  leg_odiam = 1.325 * INCH;// Set up for 1" schedule 40 PVC
  leg_idiam = 1.03 * INCH;

  truss_odiam = leg_odiam;
  truss_idiam = leg_idiam;

  top_diameter = plate_width / sqrt(3) * 2 - leg_odiam * 1.6;
  // top_diameter = 5.3 * INCH;

  taper_length = INCH / 2;

  top_margin = INCH * 2.0;
  bottom_margin = INCH * 3.5;
  top_rad = top_diameter / 2;

  // Spike
  spike_diam = 16;
  spike_length = 28;
  spike_thread = 6;
  spike_thread_pitch = 1;
  spike_thread_length = 13;

  // Kef LM50
  speaker_width = 200;
  speaker_depth = 260;
  speaker_height = 10;// 302;

  speaker_hole_depth = 138;
  speaker_hole_width = 123;
  speaker_hole_screw = "M8";
  speaker_hole_screw_head = "socket";

  // Plate Screw
  plate_screw_diam = 1 / 4 * INCH;
  plate_screw_pitch = 1 / 20 * INCH;

  // Steel ball
  sphere_diameter = 0.75 * INCH;

  // Flags to show different things
  // Flags to show different things
  show_part = show != "all";
  part = show;// Values are hi, low, plate

  show_spike = true;
  show_top = false;
  show_inner = false;
  show_speaker = true;

  top_angle = 60;
  bottom_angle = 60;

  truss_orad = truss_odiam / 2;
  truss_irad = truss_idiam / 2;

  leg_orad = leg_odiam / 2;
  leg_irad = leg_idiam / 2;

  alt_stand_height = stand_height - plate_height;
  top_radius = top_diameter / 2;

  plate_offset = -1 / 4 * top_radius;

  base_diamater = base_width / sqrt(3) * 2;
  base_radius = base_diamater / 2;

  // Oversize thread diamater adjusment.
  // This value works using Prusa Mini+ using PLA
  thread_adjusment = 0.3;


  module my_thread(diameter, pitch, length) {
    if (show_part) {
      translate([0, 0, length / 2])
        threaded_rod(d = diameter + thread_adjusment, height = length, pitch = pitch, $fa = 0.5, $fs = 0.5, internal = true);
    } else {
      translate([0, 0, -1])
        cylinder(length + 2, diameter / 2, diameter / 2);
    }
  }

  // Transpose of matrix A (swap rows and columns)
  function transpose(A) = [ for(j = [0:len(A[0]) - 1])
    [ for(i = [0:len(A) - 1])A[i][j]]
  ];

 
  //  Cylinder of radius r from P to Q
  module cylinder_between_points(P, Q, r, taper = 0, irad = 0) {
    v = Q - P;// vector from P to Q
    L = norm(v);// height of the cylnder = dist(P, Q)
    c = v / L;// unit vector: direction from P to Q
    is_c_vertical = (1 - abs(c * [0, 0, 1]) < 1e-6);//is c parallel to z axis?
    u = is_c_vertical ? [1, 0, 0] : cross([0, 0, 1], c);// normal to c and Z axis
    a = u / norm(u);// unit vector normal to c and the Z axis
    b = cross(c, a);// unit vector normal to a and b
    // [a, b, c] is an orthonormal basis, i.e. the rotation matrix; P is the translation
    MT = [a, b, c, P];// the transformation matrix
    M = transpose(MT);// OpenSCAD wants vectors in columns, so we need to transpose
    multmatrix(M) {
      length = L - taper;
      difference() {
        cylinder(h = length, r = r);
        if (irad > 0) {
          tube_length = length - truss_idiam * 2 - INCH;
          translate([0, 0, (length - tube_length) / 2]) {
            difference() {
              cylinder(h = tube_length, r = r + 0.1);
              cylinder(h = tube_length, r = irad);
            }
          }
        }
      }

      if (taper > 0) {
        translate([0, 0, L - taper]) {
          cylinder(taper, r, spike_diam / 2 * 1.5);
        }
      }
    }
  }

  // Calculate all interesting points on the design
  bottom_z = bottom_margin;
  bottom_rad = default_width / 2;
  top_z = height - top_margin - plate_height - sphere_diameter / 2;
  cone_slope = (top_rad - bottom_rad)/(top_z - bottom_z);
  cone_height = -bottom_rad / cone_slope + bottom_z;

  function cone_rad_at(height) = cone_slope * ( height - bottom_z) + bottom_rad;

  // get coordinate of three points around circle r at height z
  function tcords(r, z, angle = 60, offset = 0) = [
    [r + offset, 0, z], 
    [-r * cos(angle) + offset, r * sin(angle), z], 
    [-r * cos(angle) + offset, -r * sin(angle), z]
  ];

   // get coordinate of three points around height z
  function zcords(z, angle = 60, offset = 0) = tcords(cone_rad_at(z),z,angle, offset);

  t0 = zcords(bottom_z, bottom_angle);
  p0 = t0[0];
  p1 = t0[1];
  p2 = t0[2];

  t1 =  zcords(spike_length);
  p0a = t1[0];
  p1a = t1[1];
  p2a = t1[2];

  t2 = zcords(top_z);
  p3 = t2[0];
  p4 = t2[1];
  p5 = t2[2];

  t3 = zcords(top_z + top_margin, top_angle);
  p3a = t3[0];
  p4a = t3[1];
  p5a = t3[2];

  p6 = (p5 + p4) / 2;
  p7 = p3 + [-(p3[0] - p6[0]) / 2, 0, 0];
  p8 = p7 + [0, 0, top_margin + sphere_diameter / 2 - INCH / 8];

  // Put speheres in the intersection points to fill in the gaps
  for(p = [p0, p1, p2, p3, p4, p5]) {
     translate(p) {
      sphere(r = leg_orad);
    }
  }
 
  // Draw the connecting tubes
  difference() {
    union() {
      cylinder_between_points(p0, p1, truss_orad, irad = truss_irad);
      cylinder_between_points(p1, p2, truss_orad, irad = truss_irad);
      cylinder_between_points(p2, p0, truss_orad, irad = truss_irad);

      cylinder_between_points(p0, p0a, leg_orad, taper_length);
      cylinder_between_points(p1, p1a, leg_orad, taper_length);
      cylinder_between_points(p2, p2a, leg_orad, taper_length);

      cylinder_between_points(p0, p3, leg_orad, irad = leg_irad);
      cylinder_between_points(p1, p4, leg_orad, irad = leg_irad);
      cylinder_between_points(p2, p5, leg_orad, irad = leg_irad);

      cylinder_between_points(p4, p5, truss_orad);
      cylinder_between_points(p3, p6, truss_orad);

      cylinder_between_points(p3, p3a, leg_orad, taper_length);
      cylinder_between_points(p4, p4a, leg_orad, taper_length);
      cylinder_between_points(p5, p5a, leg_orad, taper_length);

      cylinder_between_points(p7, p8, truss_irad);
    }

    // Top screw
    translate(p8) {
      rotate([180, 0, 0]) {
        my_thread(diameter = plate_screw_diam, pitch = plate_screw_pitch, length = INCH);
      }
    }
    // Spike screws
    for(p = [p0a, p1a, p2a])
      translate(p) {
        my_thread(diameter = spike_thread, pitch = spike_thread_pitch, length = spike_thread_length * 1.5);
      }
    // Spheres
    for(p = [p3a, p4a, p5a]) {
      translate(p) {
        color("grey")
          sphere(d = sphere_diameter);
      }
    }
  }

  // Add top spheres and spikes
  if (show_spike) {
    for(p = [p3a, p4a, p5a]) {
      translate(p) {
        color("grey")
          sphere(d = sphere_diameter);
      }
    }
    for(p = [p0a, p1a, p2a]) {
      translate(p) {
        color("grey")
          translate([0,0,-spike_length])
          cylinder(spike_length, 0, spike_diam / 2);
      }
    }
  }

  if ((show_top && !show_part) || (show_part && part == "plate"))
    color("grey")
      difference() {
        translate([0, 0, alt_stand_height + plate_height / 2])
          rotate([0, 0, 240])
            translate([INCH / 2, 0, 0])
              difference() {
                cube([plate_depth, plate_width, plate_height], center = true);

                // plate screw
                translate([0, 0, 0]) {
                  screw_hole("1/4-20", "flat", length = plate_height);
                }

                // speaker screws
                tinfo = screw_info(str(str(speaker_hole_screw, ",", plate_height)), speaker_hole_screw_head);
                translate([-speaker_hole_depth / 2, -speaker_hole_width / 2, 0]) {
                  for(x = [0, speaker_hole_depth])
                    for(y = [0, speaker_hole_width])
                      translate([x, y, 0])
                        rotate([0, 180, 0]) {
                          translate([0, 0, -struct_val(tinfo, "head_height") / 2])
                            screw_hole(str(speaker_hole_screw, ",", plate_height), speaker_hole_screw_head);
                        }
                }

                // bevel the corners
                for(rot = [0, 180])
                  rotate([0, 0, rot])
                    translate([0, plate_width / 2 + 9, 0]) {
                      rotate([-plate_angle, 0, 0])
                        cube([plate_depth, plate_height, 2 * plate_height], center = true);
                    }
                for(rot = [90, 270]) {
                  rotate([0, 0, rot])
                    translate([0, plate_depth / 2 + 9, 0]) {
                      rotate([-plate_angle, 0, 0])
                        cube([plate_width, plate_height, 2 * plate_height], center = true);
                    }
                }
              }


      }


}

module _tripod(height, width, show) {
  rotate([0, 0, 0])
    _stand(height, width, show);
}

module speaker_tripod(height = default_height, width = default_width, show = default_show) {
  if (show == "hero") {
    for(h = [21, 25, 29]) {
      translate([(h - 21) * INCH * 3, 0, 0])
        _tripod(h * INCH, width, "all");
    }
  } else {
    _tripod(height, width, show);
  }
}

speaker_tripod();


