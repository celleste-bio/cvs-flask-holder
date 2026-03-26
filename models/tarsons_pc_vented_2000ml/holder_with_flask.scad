$fn = 50;

union() {
    translate([5.2867, 0, 0]) {
        cube([5.2867, 21.3005, 0.54]);
    };
    union() {
        translate([0, 18.6379, 0]) {
            cube([15.86, 2.6626, 0.54]);
        };
        translate([5.2867, 21.3005, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.54) {
                    polygon([[0, 0], [6.8675814520106, 0], [0, 3.965]]);
                };
            };
        };
        translate([10.0334, 21.3005, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.54) {
                    polygon([[0, 0], [6.8675814520106, 0], [0, 3.965]]);
                };
            };
        };
    };
    difference() {
        union() {
            cube([15.86, 2.6626, 0.54]);
            translate([3.965, 0, 0]) {
                cube([7.93, 0.54, 16.294]);
            };
            translate([3.965, 0, 16.294]) {
                rotate([-30, 0, 0]) {
                    cube([7.93, 0.54, 1.9486]);
                };
            };
        };
        hull() {
            translate([7.93, 3.3246728714729, 17.2476]) {
                rotate([60, 0, 0]) {
                    cylinder(h=8, r2=2.255, r1=2.255);
                };
            };
            translate([7.93, 3.3246728714729, 19.4976]) {
                rotate([60, 0, 0]) {
                    cylinder(h=8, r2=3.157, r1=3.157);
                };
            };
        };
    };
    translate([7.93, 0.54, 0.54]) {
        rotate([0, 270, 0]) {
            linear_extrude(height=0.54) {
                polygon([[0, 0], [15.754, 0], [0, 16.449906112598]]);
            };
        };
    };
};

translate([7.93, 21.2947, 7.4126]) {
    rotate([60, 0, 0]) {
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
    };
};
