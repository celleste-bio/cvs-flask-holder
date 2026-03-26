$fn = 50;

union() {
    translate([4.3233, 0, 0]) {
        cube([4.3233, 16.9271, 0.44]);
    };
    union() {
        translate([0, 14.8112, 0]) {
            cube([12.97, 2.1159, 0.44]);
        };
        translate([4.3233, 16.9271, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.44) {
                    polygon([[0, 0], [5.6161747435421, 0], [0, 3.2425]]);
                };
            };
        };
        translate([8.2066, 16.9271, 0]) {
            rotate([180, 270, 0]) {
                linear_extrude(height=0.44) {
                    polygon([[0, 0], [5.6161747435421, 0], [0, 3.2425]]);
                };
            };
        };
    };
    difference() {
        union() {
            cube([12.97, 2.1159, 0.44]);
            translate([3.2425, 0, 0]) {
                cube([6.485, 0.44, 12.5676]);
            };
            translate([3.2425, 0, 12.5676]) {
                rotate([-30, 0, 0]) {
                    cube([6.485, 0.44, 1.9486]);
                };
            };
        };
        hull() {
            translate([6.485, 3.2380986202059, 13.5212]) {
                rotate([60, 0, 0]) {
                    cylinder(h=8, r2=2.255, r1=2.255);
                };
            };
            translate([6.485, 3.2380986202059, 15.7712]) {
                rotate([60, 0, 0]) {
                    cylinder(h=8, r2=3.157, r1=3.157);
                };
            };
        };
    };
    translate([6.485, 0.44, 0.44]) {
        rotate([0, 270, 0]) {
            linear_extrude(height=0.44) {
                polygon([[0, 0], [12.1276, 0], [0, 12.64984198631]]);
            };
        };
    };
};

translate([6.485, 16.9213, 6.0612]) {
    rotate([60, 0, 0]) {
        union() {
            translate([0, 0, 2.1616666666667]) {
                hull() {
                    translate([0, 0, 2.1616666666667]) {
                        cylinder(h=13.476666666667, r2=2.25, r1=4.3233333333333);
                    };
                    rotate_extrude(convexity=10) {
                        translate([4.3233333333333, 0, 0]) {
                            circle(r=2.1616666666667);
                        };
                    };
                };
            };
            translate([0, 0, 17.8]) {
                union() {
                    cylinder(h=4, r2=2.25, r1=2.25);
                    translate([0, 0, 3.55]) {
                        rotate_extrude(convexity=10) {
                            translate([2.25, 0, 0]) {
                                circle(r=0.45);
                            };
                        };
                    };
                };
            };
        };
    };
};
