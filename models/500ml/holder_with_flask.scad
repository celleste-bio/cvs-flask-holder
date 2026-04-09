$fn = 50;

difference() {
    union() {
        translate([3.3333, 0, 0]) {
            cube([3.3333, 12.9089, 0.36]);
        };
        union() {
            translate([0, 11.2953, 0]) {
                cube([10, 1.6136, 0.36]);
            };
            translate([3.3333, 12.9089, 0]) {
                rotate([180, 270, 0]) {
                    linear_extrude(height=0.36) {
                        polygon([[0, 0], [4.3301270189222, 0], [0, 2.5]]);
                    };
                };
            };
            translate([6.3066, 12.9089, 0]) {
                rotate([180, 270, 0]) {
                    linear_extrude(height=0.36) {
                        polygon([[0, 0], [4.3301270189222, 0], [0, 2.5]]);
                    };
                };
            };
        };
        difference() {
            union() {
                cube([10, 1.6136, 0.36]);
                translate([2.5, 0, 0]) {
                    cube([5, 0.36, 9.5188]);
                };
                translate([2.5, 0, 9.5188]) {
                    rotate([-30, 0, 0]) {
                        cube([5, 0.36, 1.5588]);
                    };
                };
            };
            hull() {
                translate([5, 3.164644334444, 9.9576]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=9, r2=1.805, r1=1.805);
                    };
                };
                translate([5, 3.164644334444, 11.7576]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=9, r2=2.166, r1=2.166);
                    };
                };
            };
        };
        translate([5, 0.36, 0.36]) {
            rotate([0, 270, 0]) {
                linear_extrude(height=0.36) {
                    polygon([[0, 0], [8.7938, 0], [0, 9.110959819504]]);
                };
            };
        };
    };
    translate([3.5493, 0.8068, -0.1]) {
        linear_extrude(height=0.56) {
            text(valign="center", text="4627203", halign="right", size=0.6);
        };
    };
};

translate([5, 12.9031, 4.6951]) {
    rotate([60, 0, 0]) {
        union() {
            translate([0, 0, 1.6666666666667]) {
                hull() {
                    translate([0, 0, 1.6666666666667]) {
                        cylinder(h=10.166666666667, r2=1.8, r1=3.3333333333333);
                    };
                    rotate_extrude(convexity=10) {
                        translate([3.3333333333333, 0, 0]) {
                            circle(r=1.6666666666667);
                        };
                    };
                };
            };
            translate([0, 0, 13.5]) {
                union() {
                    cylinder(h=4.5, r2=1.8, r1=1.8);
                    translate([0, 0, 4.14]) {
                        rotate_extrude(convexity=10) {
                            translate([1.8, 0, 0]) {
                                circle(r=0.36);
                            };
                        };
                    };
                };
            };
        };
    };
};
