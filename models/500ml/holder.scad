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
            text(valign="center", text="a37aecc", halign="right", size=0.6);
        };
    };
    translate([3.1173, 12.1021, -0.1]) {
        linear_extrude(height=0.56) {
            text(valign="center", text="G500O1", halign="left", size=0.6);
        };
    };
};

