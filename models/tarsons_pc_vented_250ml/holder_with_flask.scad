$fn = 50;

union() {
    translate([2.7567, 0, 0]) {
        cube([2.7567, 10.1963, 0.27]);
    };
    union() {
        translate([0, 8.9218, 0]) {
            cube([8.27, 1.2745, 0.27]);
        };
        translate([2.7567, 10.1963, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.27) {
                    polygon([[0, 0], [3.5810150446487, 0], [0, 2.0675]]);
                };
            };
        };
        translate([5.2434, 10.1963, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.27) {
                    polygon([[0, 0], [3.5810150446487, 0], [0, 2.0675]]);
                };
            };
        };
    };
    difference() {
        union() {
            cube([8.27, 1.2745, 0.27]);
            translate([2.0675, 0, 0]) {
                cube([4.135, 0.27, 7.1356]);
            };
            translate([2.0675, 0, 7.1356]) {
                rotate([-30, 0, 0]) {
                    cube([4.135, 0.27, 1.6454]);
                };
            };
        };
        hull() {
            translate([4.135, 2.4828739063185, 8.036]) {
                rotate([60, 0, 0]) {
                    cylinder(h=6, r2=1.905, r1=1.905);
                };
            };
            translate([4.135, 2.4828739063185, 9.936]) {
                rotate([60, 0, 0]) {
                    cylinder(h=6, r2=2.667, r1=2.667);
                };
            };
        };
    };
    translate([4.135, 0.27, 0.27]) {
        rotate([0, 270, 0]) {
            linear_extrude(height=0.27) {
                polygon([[0, 0], [6.8656, 0], [0, 7.1337329716196]]);
            };
        };
    };
};

translate([4.135, 10.1905, 3.856]) {
    rotate([60, 0, 0]) {
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
    };
};
