$fn = 50;

union() {
    translate([2.7333, 0, 0]) {
        cube([2.7333, 10.51, 0.29]);
    };
    union() {
        translate([0, 9.1962, 0]) {
            cube([8.2, 1.3138, 0.29]);
        };
        translate([2.7333, 10.51, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.29) {
                    polygon([[0, 0], [3.5507041555162, 0], [0, 2.05]]);
                };
            };
        };
        translate([5.1766, 10.51, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.29) {
                    polygon([[0, 0], [3.5507041555162, 0], [0, 2.05]]);
                };
            };
        };
    };
    difference() {
        union() {
            cube([8.2, 1.3138, 0.29]);
            translate([2.05, 0, 0]) {
                cube([4.1, 0.29, 7.3919]);
            };
            translate([2.05, 0, 7.3919]) {
                rotate([-30, 0, 0]) {
                    cube([4.1, 0.29, 1.5588]);
                };
            };
        };
        hull() {
            translate([4.1, 2.6666700957508, 8.0807]) {
                rotate([60, 0, 0]) {
                    cylinder(h=7, r2=1.805, r1=1.805);
                };
            };
            translate([4.1, 2.6666700957508, 9.8807]) {
                rotate([60, 0, 0]) {
                    cylinder(h=7, r2=2.527, r1=2.527);
                };
            };
        };
    };
    translate([4.1, 0.29, 0.29]) {
        rotate([0, 270, 0]) {
            linear_extrude(height=0.29) {
                polygon([[0, 0], [7.1019, 0], [0, 7.5197457968773]]);
            };
        };
    };
};

