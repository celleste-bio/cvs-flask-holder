$fn = 50;

union() {
    translate([0, 0, 2.7333333333333]) {
        hull() {
            translate([0, 0, 2.7333333333333]) {
                cylinder(h=17.533333333333, r2=2.55, r1=5.4666666666667);
            };
            rotate_extrude(convexity=10) {
                translate([5.4666666666667, 0, 0]) {
                    circle(r=2.7333333333333);
                };
            };
        };
    };
    translate([0, 0, 23]) {
        union() {
            cylinder(h=5.5, r2=2.55, r1=2.55);
            translate([0, 0, 4.99]) {
                rotate_extrude(convexity=10) {
                    translate([2.55, 0, 0]) {
                        circle(r=0.51);
                    };
                };
            };
        };
    };
};

