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

// Sliding back of the case
union() {
    difference() {
        translate([0, 0, 0])
            linear_extrude(height = 1)
                square([length, width]);
        translate([0 + wall_thickness, wall_thickness, 1])
            linear_extrude(height = 1)
                square([length - (wall_thickness * 2), width - (wall_thickness * 2)]);
        translate([0, wall_thickness, 1])
            linear_extrude(height = 1)
                square([length, width - (wall_thickness * 2)]);
    };

    // Slide rails
    translate([0 + length, 0, 1]) rotate([0, 270, 0]) 
        linear_extrude(height = length)
            polygon([
                [0,0], 
                [2.4, 0], 
                [2.4, wall_thickness * .75 - nozzle_diameter], 
                [1.6, wall_thickness * .75 - nozzle_diameter], 
                [.8, (wall_thickness / 2) - nozzle_diameter ], 
                [0, (wall_thickness / 2) - nozzle_diameter]
            ]);
    // For the inverse slide rail side, rotate 180 to extrude in the opposite direction, then rotate & translate into final position.
    translate([0 + length, width, 1]) rotate([0, 270, 0]) 
        linear_extrude(height = length)
            rotate([180, 0, 0])
            polygon([
                [0,0], 
                [2.4, 0], 
                [2.4, wall_thickness * .75 - nozzle_diameter], 
                [1.6, wall_thickness * .75 - nozzle_diameter], 
                [.8, (wall_thickness / 2) - nozzle_diameter], 
                [0, (wall_thickness / 2) - nozzle_diameter]
            ]);
    // Case Detents
        translate([0 + wall_thickness * .75, wall_thickness * .5 - .2, 2]) 
            scale([1/10, 1/10, 1/10]) cylinder(25, d = (.5 * wall_thickness * 10) - 4, center = true);
        translate([0 + wall_thickness * .75, width - (wall_thickness * .5 -.2), 2]) 
            scale([1/10, 1/10, 1/10]) cylinder(25, d = (.5 * wall_thickness * 10) - 4, center = true);
}
