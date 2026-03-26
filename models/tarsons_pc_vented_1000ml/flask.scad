$fn = 50;

union() {
    translate([0, 0, 2.1616666666667]) {
        hull() {
            translate([0, 0, 2.1616666666667]) {
                cylinder(h=13.476666666667, r2=2.25, r1=4.3233333333333);
            };
            rotate_extrude(convexity=10) {
                translate([4.3233333333333, 0, 0]) {
                    circle(r=2.1616666666667);
                };
            };
        };
    };
    translate([0, 0, 17.8]) {
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

