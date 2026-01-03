$fn = 50;

union() {
    cube([8.2, 12.91, 0.5]);
    difference() {
        union() {
            cube([8.2, 0.5, 7.99]);
            translate([0, 0, 7.99]) {
                rotate([-30, 0, 0]) {
                    cube([8.2, 0.5, 2.34]);
                };
            };
        };
        hull() {
            translate([4.1, 1.9, 9.14]) {
                rotate([60, 0, 0]) {
                    cylinder(h=2.8, r2=1.89, r1=1.89);
                };
            };
            translate([4.1, 2.8, 10.94]) {
                rotate([60, 0, 0]) {
                    cylinder(h=2.8, r2=2.646, r1=2.646);
                };
            };
        };
    };
    difference() {
        translate([0, 8.81, 0.5]) {
            cube([8.2, 4.1, 6.56]);
        };
        translate([-0.25, 5.74, 2.05]) {
            rotate([-30, 0, 0]) {
                cube([8.7, 4.1, 9.84]);
            };
        };
    };
    translate([4.35, 0, 0]) {
        rotate([0, -90, 0]) {
            linear_extrude(height=0.5) {
                polygon([[0.5, 0.5], [7.49, 0.5], [0.5, 8.31]]);
            };
        };
    };
};

