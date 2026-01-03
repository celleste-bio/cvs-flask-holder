$fn = 50;

union() {
    translate([0, 0, 1.1]) {
        hull() {
            translate([0, 0, 1.1]) {
                cylinder(h=5.1, r2=1.5, r1=2.2);
            };
            rotate_extrude(convexity=10) {
                translate([2.2, 0, 0]) {
                    circle(r=1.1);
                };
            };
        };
    };
    translate([0, 0, 7.3]) {
        union() {
            cylinder(h=3.5, r2=1.5, r1=1.5);
            translate([0, 0, 3.2]) {
                rotate_extrude(convexity=10) {
                    translate([1.5, 0, 0]) {
                        circle(r=0.3);
                    };
                };
            };
        };
    };
};

