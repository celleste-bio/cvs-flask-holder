$fn = 50;

union() {
    translate([0, 0, 1.3783333333333]) {
        hull() {
            translate([0, 0, 1.3783333333333]) {
                cylinder(h=7.6433333333333, r2=1.9, r1=2.7566666666667);
            };
            rotate_extrude(convexity=10) {
                translate([2.7566666666667, 0, 0]) {
                    circle(r=1.3783333333333);
                };
            };
        };
    };
    translate([0, 0, 10.4]) {
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

