$fn = 50;

union() {
    translate([0, 0, 1.6916666666667]) {
        hull() {
            translate([0, 0, 1.6916666666667]) {
                cylinder(h=10.016666666667, r2=2.25, r1=3.3833333333333);
            };
            rotate_extrude(convexity=10) {
                translate([3.3833333333333, 0, 0]) {
                    circle(r=1.6916666666667);
                };
            };
        };
    };
    translate([0, 0, 13.4]) {
        union() {
            cylinder(h=4, r2=2.25, r1=2.25);
            translate([0, 0, 3.55]) {
                rotate_extrude(convexity=10) {
                    translate([2.25, 0, 0]) {
                        circle(r=0.45);
                    };
                };
            };
        };
    };
};

