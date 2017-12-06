// PiStream Camera Mount
// Raspberry Pi Zero W + Camera 1.3 + CCTV Lens mount

// Diameter of the nozzle plays into the polygon shape for the 
// slide to move freely but 'taught' for the back cover.
nozzle_diameter = 0.4;

// Thickness of the walls.
wall_thickness = 2.5;

// Amount of space for the camera cable to the end of the pi zero.
cable_room = 10;

// board size + left padding + right padding + wall thickness.
length = 65 + cable_room + 5 + (wall_thickness * 2);
// board size + inset spacing + wall thickness.
width = 30 + 2+ (wall_thickness * 2);

module support_peg(x, y, z) {
    union() {
        standoff_height = 4;
        
        translate([x, y, z])
            scale([1/10, 1/10, 1/10]) 
                cylinder(standoff_height * 10, d = 40);
        translate([x + 0, y + 0, z + standoff_height])
            scale([1/10, 1/10, 1/10]) 
                cylinder(15, d = 25);
        translate([x + 0, y + 0, z + standoff_height + 1.5])
            scale([1/10, 1/10, 1/10])
                cylinder(10, d1 = 25, d2 = 10);
    }
}

module board_supports(x, y, z) {
    support_peg(x + 3.5, y+ 3.5, z);
    support_peg(x + 3.5, y + 3.5 + 23, z);
    support_peg(x + 3.5 + 58, y + 3.5, z);
    support_peg(x + 3.5 + 58, y + 3.5 + 23, z);
}

// x = is the midpoint location for the mount.
module mount(x = 0, y = 0, z = 0) {
    difference() {
        // A square and a cylinder
        union() {
            translate([x, y - 15.5 , z])
                linear_extrude(height = 9)
                    square(15.5, 10.45);
            translate([x + (15.5 / 2), y - 15.5, z])
                scale([1/10, 1/10, 1/10]) 
                    cylinder(90, d = 155);
        };
        // Screw hole.
        translate([x + (15.5 / 2), y - (15.5), z + 4.5]) 
            scale([1/10, 1/10, 1/10])
                cylinder(90, d = 52, center = true);
        // Slot between forks
        translate([x, y - (10.45 + 15.5), z + 3])
            linear_extrude(height = 3)
                square([15.5, 22]);
        // Angle to case
        translate([x, y, z])
            linear_extrude(height = 9)
                polygon([[13, 0],
                                  [15.5, 0],
                                  [15.5, -2.5]]);
    }
}

// Build a positive of the camera module.
module camera_hollow(x = 0, y = 0, z = 0) {
    union() {
        // extra space around camera board.
        translate([x - 2, y - 2, z])
            cube([29, 27, 4]);
        
        // actual size of camera board.
        translate([x, y, z])
            cube([25, 24, 4]);
        
        // camera sensor cavity
        translate([x + 7.5, y + 5, z + 4])
            cube([10,10,6]);

        // Opening for lens
        translate([x + 12.5, y+ 10, z +4])
        scale([1/10, 1/10, 1/10])
            cylinder(140, d = 120);
        
        // Sunny cable opening
        translate([x + 7.5, y + 4.5 + 10, z + 4])
            cube([10, 11, 2.5]);

        // LED
        translate([x + 25 - 4, y + 24 - 4, z + 4])
            scale([1/10, 1/10, 1/10]) 
            cylinder(40, r1 = 17, r2 = 7.5);
                
        // Opening for signal cable
        translate([x + 2, y - 8, z])
            cube([21, 8, 4]);
            
        // camera_mount_holes
        // Comment these out if you'd rather have pegs.
        translate([x + 2, y + 9.5, z + 4])
            scale([1/10, 1/10, 1/10])
            cylinder(32, r = 9);
        translate([x + 2 + 21, y + 9.5, z + 4])
            scale([1/10, 1/10, 1/10])
            cylinder(32, r = 9);
        translate([x + 2, y + 9.5 + 12.5, z + 4])
            scale([1/10, 1/10, 1/10])
            cylinder(32, r = 9);
        translate([x + 2 + 21, y + 9.5 + 12.5, z + 4])
            scale([1/10, 1/10, 1/10])
            cylinder(32, r = 9);
    }
}

module camera_pegs(x = 0, y = 0, z = 0) {
    // mounting points for camera board.
    translate([x + 2, y + 9.5, z + .5])
        scale([1/10, 1/10, 1/10]) 
        cylinder(15, r1 = 5, r2 = 9);
    translate([x + 2 + 21, y + 9.5, z + .5])
        scale([1/10, 1/10, 1/10]) 
        cylinder(15, r1 = 5, r2 = 9);
    
    translate([x + 2, y + 9.5, z + 2])
        scale([1/10, 1/10, 1/10]) 
        cylinder(20, r = 9);
    translate([x + 2 + 21, y + 9.5, z + 2])
        scale([1/10, 1/10, 1/10]) 
        cylinder(20, r = 9);
}    


// Actual Box Parts
color("grey")
    translate([length, 23, 10])
    rotate([0, 180, 0])
    union() {
        difference() {
            union() {
                difference() {
                    // Box Size.
                    translate([0,0,0])
                        linear_extrude(height = 10)
                            square([length, width]);
                    // Box Inside Volume.
                    translate([wall_thickness, wall_thickness, 1])
                        linear_extrude(height = 9)
                            square([length - (wall_thickness * 2), width - (wall_thickness * 2)]);
                    // USB Power port
                    translate([wall_thickness + cable_room + (11 - 4), 0, 2.8])
                        linear_extrude(height = 2.4)
                            square([8, wall_thickness]);
                    // USB Power port surround
                    translate([wall_thickness + cable_room + (11 - 7), 0, 0])
                        linear_extrude(height = 8)
                            square([14, wall_thickness - 1]);
                    
                    // Slide rails
                    translate([0, 0, 10]) rotate([0, 90, 0]) 
                        linear_extrude(height = length)
                            polygon([
                                [0,0], 
                                [2.5, 0], 
                                [2.5, wall_thickness * .75], 
                                [1.5, wall_thickness * .75], 
                                [.75, (wall_thickness / 2) ], 
                                [0, (wall_thickness / 2)]
                            ]);
                    // For the inverse slide rail side, rotate 180 to extrude in the opposite direction, then rotate & translate into final position.
                    translate([0, width, 10]) rotate([0, 90, 0]) 
                        linear_extrude(height = length)
                            rotate([180, 0, 0])
                            polygon([
                                [0,0], 
                                [2.5, 0], 
                                [2.5, wall_thickness * .75], 
                                [1.5, wall_thickness * .75], 
                                [.75, (wall_thickness / 2) ], 
                                [0, (wall_thickness / 2)]
                            ]);
                            
                    // Case Detents
                    translate([wall_thickness * .75, wall_thickness * .5, 8.75]) 
                        scale([1/10, 1/10, 1/10]) cylinder(25, d = .5 * wall_thickness * 10, center = true);
                    translate([wall_thickness * .75, width - (wall_thickness * .5), 8.75]) 
                        scale([1/10, 1/10, 1/10]) cylinder(25, d = .5 * wall_thickness * 10, center = true);
                        
                     // lens and LED opening bottom of box housing
                    translate([(length / 2), (width / 2), 0])
                        scale([1/10, 1/10, 1/10]) cylinder(10, d = 120);
                     translate([(length / 2) - 12.5 + 4, (width / 2) + 14.5 - 4], 0)
                        scale([1/10, 1/10, 1/10]) cylinder(10, d = 20);
                        
                };
                board_supports(wall_thickness + cable_room, wall_thickness + 1, 1);
                 
                // Face contour & camera front
                union() {
                    step = length / 9;
                    translate([0, width, -7]) rotate([90, 0, 0])
                        linear_extrude(height = width)
                        polygon([[0, 7],
                                    [step, 3.75], 
                                    [step * 2, 1.5],
                                    [step * 3, 0.5],
                                    [step * 4, 0],
                                    [step * 5, 0],
                                    [step * 6, 0.5],
                                    [step * 7, 1.5],
                                    [step * 8, 3.75],
                                    [step * 9, 7]
                        ]);
                    
                        // lens mount outline
                        translate([(length / 2), (width / 2) + 2, -16])
                            scale([1/10, 1/10, 1/10]) 
                                // 4 cm diff
                                cylinder(120, d = 120 + (wall_thickness * 2 * 10));
                }
                
                // Mounting bracket base
                translate([(length / 2) + 4.5, 0, -5.5]) rotate([0, 270, 0]) mount();
            };
            
            // Power / Activity LED
            translate([wall_thickness + cable_room + 3.5 + 2, wall_thickness +4 + 4, -6])
                scale([1/10, 1/10, 1/10]) 
                cylinder(70, r1 =7.5, r2 = 20);

            
            // Create the camera hollow centered. subtract half the x/y size of the camera board.
            rotate([0, 180, 0])
                translate([-length, 0, -1])
                    camera_hollow((length / 2) - 12.5,  (width / 2) - (24 / 2) + wall_thickness + 1.5, 0);
            
    };

    // Camera support pegs.
//    rotate([0, 180, 0])
//    translate([-length, 0, -1])
//        camera_pegs((length / 2) - 12.5,  (width / 2) - (24 / 2) + wall_thickness + 1.5, 0);
};