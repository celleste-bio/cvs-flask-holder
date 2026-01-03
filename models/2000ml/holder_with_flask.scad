$fn = 50;

union() {
    translate([5.4667, 0, 0]) {
        cube([5.4667, 21.693, 0.57]);
    };
    union() {
        translate([0, 18.9814, 0]) {
            cube([16.4, 2.7116, 0.57]);
        };
        translate([5.4667, 21.693, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.57) {
                    polygon([[0, 0], [7.1014083110324, 0], [0, 4.1]]);
                };
            };
        };
        translate([10.3634, 21.693, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.57) {
                    polygon([[0, 0], [7.1014083110324, 0], [0, 4.1]]);
                };
            };
        };
    };
    difference() {
        union() {
            cube([16.4, 2.7116, 0.57]);
            translate([4.1, 0, 0]) {
                cube([8.2, 0.57, 16.393]);
            };
            translate([4.1, 0, 16.393]) {
                rotate([-30, 0, 0]) {
                    cube([8.2, 0.57, 2.2084]);
                };
            };
        };
        hull() {
            translate([8.2, 4.1501855733651, 17.2314]) {
                rotate([60, 0, 0]) {
                    cylinder(h=11, r2=2.555, r1=2.555);
                };
            };
            translate([8.2, 4.1501855733651, 19.7814]) {
                rotate([60, 0, 0]) {
                    cylinder(h=11, r2=3.577, r1=3.577);
                };
            };
        };
    };
    translate([8.2, 0.57, 0.57]) {
        rotate([0, 270, 0]) {
            linear_extrude(height=0.57) {
                polygon([[0, 0], [15.823, 0], [0, 16.463925350484]]);
            };
        };
    };
};

translate([8.2, 21.6872, 7.6764]) {
    rotate([60, 0, 0]) {
        union() {
            translate([0, 0, 2.7333333333333]) {
                hull() {
                    translate([0, 0, 2.7333333333333]) {
                        cylinder(h=17.533333333333, r2=2.55, r1=5.4666666666667);
                    };
                    rotate_extrude(convexity=10) {
                        translate([5.4666666666667, 0, 0]) {
                            circle(r=2.7333333333333);
                        };
                    };
                };
            };
            translate([0, 0, 23]) {
                union() {
                    cylinder(h=5.5, r2=2.55, r1=2.55);
                    translate([0, 0, 4.99]) {
                        rotate_extrude(convexity=10) {
                            translate([2.55, 0, 0]) {
                                circle(r=0.51);
                            };
                        };
                    };
                };
            };
        };
    };
};
