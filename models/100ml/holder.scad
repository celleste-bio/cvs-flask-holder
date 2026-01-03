$fn = 50;

union() {
    translate([2.2, 0, 0]) {
        cube([2.2, 7.2683, 0.22]);
    };
    union() {
        translate([0, 6.3598, 0]) {
            cube([6.6, 0.9085, 0.22]);
        };
        translate([2.2, 7.2683, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.22) {
                    polygon([[0, 0], [2.8578838324886, 0], [0, 1.65]]);
                };
            };
        };
        translate([4.18, 7.2683, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.22) {
                    polygon([[0, 0], [2.8578838324886, 0], [0, 1.65]]);
                };
            };
        };
    };
    difference() {
        union() {
            cube([6.6, 0.9085, 0.22]);
            translate([1.65, 0, 0]) {
                cube([3.3, 0.22, 5.2089]);
            };
            translate([1.65, 0, 5.2089]) {
                rotate([-30, 0, 0]) {
                    cube([3.3, 0.22, 1.299]);
                };
            };
        };
        hull() {
            translate([3.3, 2.4560590089964, 5.6379]) {
                rotate([60, 0, 0]) {
                    cylinder(h=7, r2=1.505, r1=1.505);
                };
            };
            translate([3.3, 2.4560590089964, 7.1379]) {
                rotate([60, 0, 0]) {
                    cylinder(h=7, r2=2.107, r1=2.107);
                };
            };
        };
    };
    translate([3.3, 0.22, 0.22]) {
        rotate([0, 270, 0]) {
            linear_extrude(height=0.22) {
                polygon([[0, 0], [4.9889, 0], [0, 4.6837009084755]]);
            };
        };
    };
};

