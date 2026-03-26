$fn = 50;

union() {
    translate([0, 0, 1.1083333333333]) {
        hull() {
            translate([0, 0, 1.1083333333333]) {
                cylinder(h=5.7833333333333, r2=1.9, r1=2.2166666666667);
            };
            rotate_extrude(convexity=10) {
                translate([2.2166666666667, 0, 0]) {
                    circle(r=1.1083333333333);
                };
            };
        };
    };
    translate([0, 0, 8]) {
        union() {
            cylinder(h=3, r2=1.9, r1=1.9);
            translate([0, 0, 2.62]) {
                rotate_extrude(convexity=10) {
                    translate([1.9, 0, 0]) {
                        circle(r=0.38);
                    };
                };
            };
        };
    };
};

