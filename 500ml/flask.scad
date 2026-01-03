$fn = 50;

union() {
    translate([0, 0, 1.6666666666667]) {
        hull() {
            translate([0, 0, 1.6666666666667]) {
                cylinder(h=10.166666666667, r2=1.8, r1=3.3333333333333);
            };
            rotate_extrude(convexity=10) {
                translate([3.3333333333333, 0, 0]) {
                    circle(r=1.6666666666667);
                };
            };
        };
    };
    translate([0, 0, 13.5]) {
        union() {
            cylinder(h=4.5, r2=1.8, r1=1.8);
            translate([0, 0, 4.14]) {
                rotate_extrude(convexity=10) {
                    translate([1.8, 0, 0]) {
                        circle(r=0.36);
                    };
                };
            };
        };
    };
};

