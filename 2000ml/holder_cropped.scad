$fn = 50;

difference() {
union() {
    difference() {
        union() {
            difference() {
                union() {
                    cube([16.4, 0.5, 16.89]);
                    translate([0, 0, 16.89]) {
                        rotate([-30, 0, 0]) {
                            cube([16.4, 0.5, 3.315]);
                        };
                    };
                };
                hull() {
                    translate([8.2, 4.22, 18.48]) {
                        rotate([60, 0, 0]) {
                            cylinder(h=5.5, r2=2.6775, r1=2.6775);
                        };
                    };
                    translate([8.2, 5.495, 21.03]) {
                        rotate([60, 0, 0]) {
                            cylinder(h=5.5, r2=3.7485, r1=3.7485);
                        };
                    };
                };
            };
            difference() {
                translate([0, 17.09, 0.5]) {
                    cube([16.4, 8.2, 13.12]);
                };
                union() {
                    translate([-0.25, 10.94, 4.1]) {
                        rotate([-30, 0, 0]) {
                            cube([16.9, 8.2, 19.68]);
                        };
                    };
                    translate([0, 17.59, 8.445]) {
                        cube([16.9, 8.2, 19.68]);
                    };
                };
            };
            translate([8.45, 0, 0]) {
                rotate([0, -90, 0]) {
                    linear_extrude(height=0.5) {
                        polygon([[0.5, 0.5], [16.765, 0.5], [0.5, 17.215]]);
                    };
                };
            };
        };
        translate([11.9485, -1, -1]) {
            cube([8.2, 27.29, 21.1]);
        };
        translate([-3.7485, -1, -1]) {
            cube([8.2, 27.29, 21.1]);
        };
    };
    difference() {
        cube([16.4, 25.29, 0.5]);
        translate([-0.5, 8.7, -1]) {
            cylinder(h=17.39, r2=8.2, r1=8.2);
        };
        translate([16.9, 8.7, -1]) {
            cylinder(h=17.39, r2=8.2, r1=8.2);
        };
    };
};
translate([-2, 21, -1]) {
    cube([20, 10, 16.0]);
};
};