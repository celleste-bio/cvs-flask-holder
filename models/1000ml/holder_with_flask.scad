$fn = 50;

union() {
    translate([4.3333, 0, 0]) {
        cube([4.3333, 16.6423, 0.44]);
    };
    union() {
        translate([0, 14.562, 0]) {
            cube([13, 2.0803, 0.44]);
        };
        translate([4.3333, 16.6423, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.44) {
                    polygon([[0, 0], [5.6291651245989, 0], [0, 3.25]]);
                };
            };
        };
        translate([8.2266, 16.6423, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.44) {
                    polygon([[0, 0], [5.6291651245989, 0], [0, 3.25]]);
                };
            };
        };
    };
    difference() {
        union() {
            cube([13, 2.0803, 0.44]);
            translate([3.25, 0, 0]) {
                cube([6.5, 0.44, 12.4739]);
            };
            translate([3.25, 0, 12.4739]) {
                rotate([-30, 0, 0]) {
                    cube([6.5, 0.44, 1.9053]);
                };
            };
        };
        hull() {
            translate([6.5, 3.4296125922873, 13.2592]) {
                rotate([60, 0, 0]) {
                    cylinder(h=9, r2=2.205, r1=2.205);
                };
            };
            translate([6.5, 3.4296125922873, 15.4592]) {
                rotate([60, 0, 0]) {
                    cylinder(h=9, r2=3.087, r1=3.087);
                };
            };
        };
    };
    translate([6.5, 0.44, 0.44]) {
        rotate([0, 270, 0]) {
            linear_extrude(height=0.44) {
                polygon([[0, 0], [12.0339, 0], [0, 12.33984198631]]);
            };
        };
    };
};

translate([6.5, 16.6365, 6.0742]) {
    rotate([60, 0, 0]) {
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
    };
};
