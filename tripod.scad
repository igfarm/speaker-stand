$fn=72;
use <lib/threads.scad>

inch = 25.4;

// Basic stats
stand_height = 28 * inch;
base_width = 13 * inch;
top_width = 6 * inch;
top_height = 0.75 * inch;

// https://pvcfittingstore.com/pages/pvc-pipe-sizes-and-dimensions
// Schedule 40 PVC
leg_odiam = 1.315 * inch; // FORMUFIT 1-1/4" Size Furniture Grade PVC Pipe 
leg_idiam = 1.049 * inch;
truss_odiam = 1.050 * inch; // FORMUFIT 3/4 in. Furniture Grade PVC pipe
truss_idiam = 0.824 * inch;

// Adornments 
spike_diam = 16;
spike_length = 27;
sphere_diameter = 0.75 * inch;

// Flags to show different things
show_low_part = false;
show_hi_part = true;

show_part = false;
part = "hi"; // Values are hi and low

show_spike = true ;
show_top = true;
show_inner = false;

show_guide = false;

taper_length = inch;

// Calculated values
alt_stand_height = stand_height  - top_height;


// Where the trusses live
low_truss_height = inch * 2.5;
hi_truss_height = alt_stand_height - 1.5 * inch;

base_diamater = base_width / sqrt(3) * 2;
base_radius = base_diamater/2;
top_diameter = top_width / sqrt(3) * 2 - leg_odiam;
top_radius = top_diameter/2;

hi_truss_radius = hi_truss_height * (top_radius - base_radius) / alt_stand_height + base_radius;
hi_truss_length = hi_truss_radius * sqrt(3);

low_truss_radius = low_truss_height * (top_radius - base_radius) / alt_stand_height + base_radius;
low_truss_length = low_truss_radius * sqrt(3);

leg_length = sqrt(alt_stand_height ^ 2 + (base_radius-top_radius) ^ 2);
leg_angle = atan((base_radius - top_radius)/alt_stand_height);

th = base_width * sqrt(3) / 2;


module my_thread(type, diameter, pitch , length ) {
    if (type == "metric") {
        if(show_part)
            metric_thread(diameter, pitch, length);
        else 
            translate([0,0,-1])
                cylinder(length+1, diameter/2, diameter/2);
    } 
    if (type == "english") {
        if(show_part)
            english_thread(diameter, pitch, length);
        else 
            translate([0,0,-1])
                cylinder(length * inch - 1, diameter * inch/2, diameter * inch/2);
    }
}

module leg() {
    hi_taper_line = spike_length + taper_length;

    leg_tube_length = (hi_truss_height  - low_truss_height)/cos(leg_angle) - truss_odiam * 2;
    echo("leg tube length");
    echo(leg_tube_length); 

    union() {
        rotate([0,leg_angle,0])

        // The leg
        difference() {
            union () {

                // Leg
                translate([0,0,hi_taper_line])
                    cylinder(leg_length-hi_taper_line-taper_length-sphere_diameter/2, leg_odiam/2, leg_odiam/2);

                // Top taper
                translate([0,0,leg_length-taper_length - sphere_diameter/2])
                    cylinder(taper_length, leg_odiam/2, spike_diam/2 * 1.5);

                // Bottom taper
                translate([0,0,spike_length]) {
                    difference () {
                        cylinder(taper_length, spike_diam/2 * 1.5, leg_odiam/2);
                        my_thread(type="metric", diameter=6, pitch=1.25, length=15 );
                    }
                }

                // Spike
                if (show_spike && !show_part) 
                    color("red") {
                        translate([0,0,0])
                            cylinder(spike_length, 0, spike_diam/2);

                        translate([0,0,leg_length-sphere_diameter/2])
                            sphere(d=sphere_diameter);
                        }
            }

            // Make a place for sphere to rest
            translate([0,0,leg_length-sphere_diameter/2])
                sphere(d=sphere_diameter);

            // Expose inner tube
            if (show_inner || show_part)
                translate([0, 0, truss_odiam  + low_truss_height]) 
                    difference() {
                        cylinder(leg_tube_length, leg_odiam/2 + 1, leg_odiam/2 + 1);
                        cylinder(leg_tube_length, leg_idiam/2, leg_idiam/2);
                    }
        }
    }
}

module truss_with_sleeve(truss_length) {
    truss_tube_length = low_truss_length - truss_idiam * 4;
    echo("low truss tube length");
    echo(truss_tube_length); 

    union() {
        // The truss
        difference() {
            cylinder(truss_length, truss_odiam/2, truss_odiam/2);
            if (show_inner || show_part)
                translate([0, 0, truss_idiam * 2])
                    difference() {
                        cylinder(truss_tube_length, truss_odiam/2 + 2, truss_odiam/2 + 2);
                        cylinder(truss_tube_length, truss_idiam/2, truss_idiam/2);
                    }
        }
    }
}

module hi_truss() {
    // Trusses in T arrengment
    translate([base_diamater/2,0,0])
        rotate([0,0,60])
            translate([-hi_truss_length / (2* sqrt(3)),0, hi_truss_height])
                union() {
                    rotate([90,0,0])
                        translate([0, 0, -hi_truss_length/2]) 
                            cylinder(hi_truss_length, truss_odiam/2, truss_odiam/2);
                    rotate([0,90,0]) 
                            cylinder(3/2 * hi_truss_radius, truss_odiam/2, truss_odiam/2);
                }

    // Tube to connect to top plate
    translate([base_radius,0,hi_truss_height]) {
        difference() {
            cylinder(alt_stand_height - hi_truss_height - 0.125 * inch, truss_odiam/3, truss_odiam/3);
            my_thread(type="english", diameter=1/4, pitch=20 , length=(alt_stand_height - hi_truss_height)/inch );
        }
    }
}

module low_truss() {
     translate([base_diamater/2,0,0])
         rotate([0,0,60])
             translate([-low_truss_length / (2* sqrt(3)),0, low_truss_height])
                union() {
                    rotate([90,0,0])
                        translate([0, 0, -low_truss_length/2]) {
                            truss_with_sleeve(low_truss_length);
                        }
                    translate([0, -low_truss_length/2, 0])
                        rotate([90,0,-60])
                            translate([0, 0, -low_truss_length])
                                truss_with_sleeve(low_truss_length);
                    translate([0, low_truss_length/2, 0])
                        rotate([90,0,-120])
                            translate([0, 0, -low_truss_length])
                                truss_with_sleeve(low_truss_length);
                }
}



union() {
    difference() {
        union() {
            // Legs
            leg();
            translate([th, -base_width/2, 0])
                rotate([0,0,120])
                leg();
            translate([th, base_width/2, 0])
                rotate([0,0,240])
                leg();

            // Trusses
            hi_truss();
            low_truss();

        }

        if (show_part && part == "low") {
                translate([-100,-400, low_truss_height + 2.5 * inch])   
                    cube([800,800,1500]);

                translate([70,-400, -10])   
                    cube([800, 800,200]); 
        }
        if (show_part && part == "hi") {
               translate([-100,-400, -inch * 4])   
                   cube([800,800,alt_stand_height]);
        }
    }
}

if (show_top && !show_part)
    color("red")
        translate([base_diamater/2,0, alt_stand_height + 0.75 * inch/2])
        rotate([0,0,240])
            cube([top_width,top_width, top_height], center=true);

if (show_guide) 
    color("red") {
    translate([base_radius,0,alt_stand_height + inch])
        cylinder(1, top_radius, top_radius);

    translate([base_radius,0,0])
       cylinder(1, base_radius, base_radius);

    translate([base_radius,0,0])
        cylinder(alt_stand_height+50, 5, 5);
}

