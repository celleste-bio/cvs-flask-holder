module volume(height_cutoff) {
    difference() {
        // Original object with applied transformations
        translate([0,0,2.4]) {
            rotate([30,0,0]) {
                import("erlenmeyer-250ml_solid.stl");
            }
        }
        scale([0.001,0.001,0.001]) {
            translate([0,0,2.4]) {
                rotate([30,0,0]) {
                    import("erlenmeyer-250ml.stl");
                }
            }
        }
        // Cutting shape with adjustable height
        translate([-5,-5,height_cutoff]) {
            cube([10,20,20]);
        }
    }
}

//height_cutoff = 5.5;
// Call the module with the height_cutoff variable
volume(height_cutoff);