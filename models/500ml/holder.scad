$fn = 50;

union() {
    translate([3.3333, 0, 0]) {
        cube([3.3333, 12.9089, 0.36]);
    };
    union() {
        translate([0, 11.2953, 0]) {
            cube([10, 1.6136, 0.36]);
        };
        translate([3.3333, 12.9089, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.36) {
                    polygon([[0, 0], [4.3301270189222, 0], [0, 2.5]]);
                };
            };
        };
        translate([6.3066, 12.9089, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.36) {
                    polygon([[0, 0], [4.3301270189222, 0], [0, 2.5]]);
                };
            };
        };
    };
    difference() {
        union() {
            cube([10, 1.6136, 0.36]);
            translate([2.5, 0, 0]) {
                cube([5, 0.36, 9.5213]);
            };
            translate([2.5, 0, 9.5213]) {
                rotate([-30, 0, 0]) {
                    cube([5, 0.36, 1.5588]);
                };
            };
        };
        hull() {
            translate([5, 3.1603142074251, 9.9601]) {
                rotate([60, 0, 0]) {
                    cylinder(h=9, r2=1.805, r1=1.805);
                };
            };
            translate([5, 3.1603142074251, 11.7601]) {
                rotate([60, 0, 0]) {
                    cylinder(h=9, r2=2.527, r1=2.527);
                };
            };
        };
    };
    translate([5, 0.36, 0.36]) {
        rotate([0, 270, 0]) {
            linear_extrude(height=0.36) {
                polygon([[0, 0], [9.1613, 0], [0, 9.4891240186124]]);
            };
        };
    };
};

