$fn = 50;

union() {
    translate([2.2167, 0, 0]) {
        cube([2.2167, 8.0745, 0.22]);
    };
    union() {
        translate([0, 7.0652, 0]) {
            cube([6.65, 1.0093, 0.22]);
        };
        translate([2.2167, 8.0745, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.22) {
                    polygon([[0, 0], [2.8795344675833, 0], [0, 1.6625]]);
                };
            };
        };
        translate([4.2134, 8.0745, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.22) {
                    polygon([[0, 0], [2.8795344675833, 0], [0, 1.6625]]);
                };
            };
        };
    };
    difference() {
        union() {
            cube([6.65, 1.0093, 0.22]);
            translate([1.6625, 0, 0]) {
                cube([3.325, 0.22, 5.2341]);
            };
            translate([1.6625, 0, 5.2341]) {
                rotate([-30, 0, 0]) {
                    cube([3.325, 0.22, 1.6454]);
                };
            };
        };
        hull() {
            translate([3.325, 2.4395348754011, 6.1345]) {
                rotate([60, 0, 0]) {
                    cylinder(h=6, r2=1.905, r1=1.905);
                };
            };
            translate([3.325, 2.4395348754011, 8.0345]) {
                rotate([60, 0, 0]) {
                    cylinder(h=6, r2=2.667, r1=2.667);
                };
            };
        };
    };
    translate([3.325, 0.22, 0.22]) {
        rotate([0, 270, 0]) {
            linear_extrude(height=0.22) {
                polygon([[0, 0], [4.7891, 0], [0, 5.1261968623376]]);
            };
        };
    };
};

translate([3.325, 8.0687, 3.1045]) {
    rotate([60, 0, 0]) {
        union() {
            translate([0, 0, 1.1083333333333]) {
                hull() {
                    translate([0, 0, 1.1083333333333]) {
                        cylinder(h=5.7833333333333, r2=1.9, r1=2.2166666666667);
                    };
                    rotate_extrude(convexity=10) {
                        translate([2.2166666666667, 0, 0]) {
                            circle(r=1.1083333333333);
                        };
                    };
                };
            };
            translate([0, 0, 8]) {
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
    };
};
