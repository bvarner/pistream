// PiStream Camera Mount
// Raspberry Pi Zero W + Camera 1.3 + CCTV Lens mount

wall_thickness = 2.5;
cable_room = 10;

// board size + left padding + right padding + wall thickness.
length = 65 + cable_room + 5 + (wall_thickness * 2);
// board size + inset spacing + wall thickness.
width = 30 + 2+ (wall_thickness * 2);

camera_y_offset = 3;

module support_peg(x, y, z) {
    union() {
        standoff_height = 4;
        
        translate([x, y, z])
        scale([1/10, 1/10, 1/10]) cylinder(standoff_height * 10, d = 40);
        translate([x + 0, y + 0, z + standoff_height])
        scale([1/10, 1/10, 1/10]) cylinder(15, d = 25);
        translate([x + 0, y + 0, z + standoff_height + 1.5])
        scale([1/10, 1/10, 1/10]) cylinder(10, d1 = 25, d2 = 10);
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
                cylinder(90, d = 62, center = true);
        // Slot between forks
        translate([x, y - (10.45 + 15.5), z + 3])
            linear_extrude(height = 3)
                square([15.5, 22]);
        // Angle to case
        translate([x, y, z])
            linear_extrude(height = 9)
                polygon([[13.5, 0],
                                  [15.5, 0],
                                  [15.5, -12.75]]);
    }
}

// Actual Box Parts
color("grey")
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
                    translate([0, width, -6]) rotate([90, 0, 0])
                        linear_extrude(height = width)
                        polygon([[0, 6],
                                    [step, 3.5], 
                                    [step * 2, 1.5],
                                    [step * 3, 0.5],
                                    [step * 4, 0],
                                    [step * 5, 0],
                                    [step * 6, 0.5],
                                    [step * 7, 1.5],
                                    [step * 8, 3.5],
                                    [step * 9, 6]
                        ]);
                    
                        // lens mount outline
                        translate([(length / 2), (width / 2) + camera_y_offset, -12])
                            scale([1/10, 1/10, 1/10]) 
                                // 4 cm diff
                                cylinder(120, d = 120 + (wall_thickness * 2 * 10));
                }
                
                // Mounting bracket base
                translate([(length / 2) + 4.5, 0, -6]) rotate([0, 270, 0]) mount();
                
                // Camera lens base
                translate([(length / 2) - 8, (width / 2) - 8 + camera_y_offset, -8])
                    linear_extrude(height = 6)
                        square(16, 16);
            };
            
            // Camera Board Cavity
            translate([length / 2, (width / 2) + camera_y_offset, -1])
                cube([26, 25, 4], center = true);
            
            // Opening for lens
            translate([(length / 2), (width / 2) + camera_y_offset, -12]) 
                scale([1/10, 1/10, 1/10])
                    cylinder(80, d = 120);
            
            // camera sensor cavity
            translate([(length / 2) - 5, (width / 2) - 5 + camera_y_offset, -8])
                linear_extrude(height = 6)
                    square(10, 10);
     
            // Sunny cable opening
            translate([(length / 2) - 4, (width / 2) +4 + camera_y_offset, -5])
                linear_extrude(height = 2)
                    square([8, 8]);
     
            // Opening for LED
             translate([(length / 2) - 12.5 + 4, (width / 2) + 14.5 - 4 + camera_y_offset, -10])
                scale([1/10, 1/10, 1/10]) 
                    cylinder(100, d = 20);
                    
              // Opening for signal cable
              translate([(length / 2) - 8, wall_thickness, -3])
                    cube([16, 4 + camera_y_offset, 4]);
    };
        
        // camera mount pegs
        translate([(length / 2) - 10.5, (width / 2) + camera_y_offset, -2])
            scale([1/10, 1/10, 1/10])
                cylinder(40, d = 19, center = true);
        translate([(length / 2) + 10.5, (width / 2) + camera_y_offset, -2])
            scale([1/10, 1/10, 1/10])
                cylinder(40, d = 19, center = true);
};

    
// Sliding back of the case
union() {
    difference() {
        translate([100, 0, 0])
            linear_extrude(height = 1)
                square([length, width]);
        translate([100 + wall_thickness, wall_thickness, 1])
            linear_extrude(height = 1)
                square([length - (wall_thickness * 2), width - (wall_thickness * 2)]);
        translate([100, wall_thickness, 1])
            linear_extrude(height = 1)
                square([length, width - (wall_thickness * 2)]);
    };

    // Slide rails
    translate([100 + length, 0, 1]) rotate([0, 270, 0]) 
        linear_extrude(height = length)
            polygon([
                [0,0], 
                [2.4, 0], 
                [2.4, wall_thickness * .75 - .4], 
                [1.6, wall_thickness * .75 - .4], 
                [.8, (wall_thickness / 2) - .4 ], 
                [0, (wall_thickness / 2) - .4]
            ]);
    // For the inverse slide rail side, rotate 180 to extrude in the opposite direction, then rotate & translate into final position.
    translate([100 + length, width, 1]) rotate([0, 270, 0]) 
        linear_extrude(height = length)
            rotate([180, 0, 0])
            polygon([
                [0,0], 
                [2.4, 0], 
                [2.4, wall_thickness * .75 - .4], 
                [1.6, wall_thickness * .75 - .4], 
                [.8, (wall_thickness / 2) - .4], 
                [0, (wall_thickness / 2) - .4]
            ]);
    // Case Detents
        translate([100 + wall_thickness * .75, wall_thickness * .5 - .2, 2]) 
            scale([1/10, 1/10, 1/10]) cylinder(25, d = (.5 * wall_thickness * 10) - 4, center = true);
        translate([100 + wall_thickness * .75, width - (wall_thickness * .5 -.2), 2]) 
            scale([1/10, 1/10, 1/10]) cylinder(25, d = (.5 * wall_thickness * 10) - 4, center = true);


}
    
    
    