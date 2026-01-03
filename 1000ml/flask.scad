$fn = 50;

union() {
    translate([0, 0, 2.1666666666667]) {
        hull() {
            translate([0, 0, 2.1666666666667]) {
                cylinder(h=13.166666666667, r2=2.2, r1=4.3333333333333);
            };
            rotate_extrude(convexity=10) {
                translate([4.3333333333333, 0, 0]) {
                    circle(r=2.1666666666667);
                };
            };
        };
    };
    translate([0, 0, 17.5]) {
        union() {
            cylinder(h=4.5, r2=2.2, r1=2.2);
            translate([0, 0, 4.06]) {
                rotate_extrude(convexity=10) {
                    translate([2.2, 0, 0]) {
                        circle(r=0.44);
                    };
                };
            };
        };
    };
};

