$fn = 50;

difference() {
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
                    cube([6.485, 0.44, 12.5651]);
                };
                translate([3.2425, 0, 12.5651]) {
                    rotate([-30, 0, 0]) {
                        cube([6.485, 0.44, 1.9486]);
                    };
                };
            };
            hull() {
                translate([6.485, 3.2424287472248, 13.5187]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=8, r2=2.255, r1=2.255);
                    };
                };
                translate([6.485, 3.2424287472248, 15.7687]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=8, r2=2.706, r1=2.706);
                    };
                };
            };
        };
        translate([6.485, 0.44, 0.44]) {
            rotate([0, 270, 0]) {
                linear_extrude(height=0.44) {
                    polygon([[0, 0], [11.6801, 0], [0, 12.185583573273]]);
                };
            };
        };
    };
    translate([4.5873, 1.058, -0.1]) {
        linear_extrude(height=0.64) {
            text(valign="center", text="a37aecc", halign="right", size=0.7782);
        };
    };
    translate([4.0593, 15.8692, -0.1]) {
        linear_extrude(height=0.64) {
            text(valign="center", text="T1KV1", halign="left", size=0.7782);
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
