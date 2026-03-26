$fn = 50;

union() {
    translate([0, 0, 2.6433333333333]) {
        hull() {
            translate([0, 0, 2.6433333333333]) {
                cylinder(h=17.463333333333, r2=2.25, r1=5.2866666666667);
            };
            rotate_extrude(convexity=10) {
                translate([5.2866666666667, 0, 0]) {
                    circle(r=2.6433333333333);
                };
            };
        };
    };
    translate([0, 0, 22.75]) {
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

