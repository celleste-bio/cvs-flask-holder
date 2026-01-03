$fn = 50;

union() {
    translate([0, 0, 1.3666666666667]) {
        hull() {
            translate([0, 0, 1.3666666666667]) {
                cylinder(h=8.0666666666667, r2=1.8, r1=2.7333333333333);
            };
            rotate_extrude(convexity=10) {
                translate([2.7333333333333, 0, 0]) {
                    circle(r=1.3666666666667);
                };
            };
        };
    };
    translate([0, 0, 10.8]) {
        union() {
            cylinder(h=3.5, r2=1.8, r1=1.8);
            translate([0, 0, 3.14]) {
                rotate_extrude(convexity=10) {
                    translate([1.8, 0, 0]) {
                        circle(r=0.36);
                    };
                };
            };
        };
    };
};

