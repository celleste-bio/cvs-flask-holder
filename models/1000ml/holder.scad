$fn = 50;

difference() {
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
                    cube([6.5, 0.44, 12.4714]);
                };
                translate([3.25, 0, 12.4714]) {
                    rotate([-30, 0, 0]) {
                        cube([6.5, 0.44, 1.9053]);
                    };
                };
            };
            hull() {
                translate([6.5, 3.4339427193062, 13.2567]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=9, r2=2.205, r1=2.205);
                    };
                };
                translate([6.5, 3.4339427193062, 15.4567]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=9, r2=2.646, r1=2.646);
                    };
                };
            };
        };
        translate([6.5, 0.44, 0.44]) {
            rotate([0, 270, 0]) {
                linear_extrude(height=0.44) {
                    polygon([[0, 0], [11.5864, 0], [0, 11.883433780788]]);
                };
            };
        };
    };
    translate([4.5973, 1.0401, -0.1]) {
        linear_extrude(height=0.64) {
            text(valign="center", text="4627203", halign="right", size=0.78);
        };
    };
};

