$fn = 50;

difference() {
    union() {
        translate([5.2867, 0, 0]) {
            cube([5.2867, 21.3005, 0.54]);
        };
        union() {
            translate([0, 18.6379, 0]) {
                cube([15.86, 2.6626, 0.54]);
            };
            translate([5.2867, 21.3005, 0]) {
                rotate([180, 270, 0]) {
                    linear_extrude(height=0.54) {
                        polygon([[0, 0], [6.8675814520106, 0], [0, 3.965]]);
                    };
                };
            };
            translate([10.0334, 21.3005, 0]) {
                rotate([180, 270, 0]) {
                    linear_extrude(height=0.54) {
                        polygon([[0, 0], [6.8675814520106, 0], [0, 3.965]]);
                    };
                };
            };
        };
        difference() {
            union() {
                cube([15.86, 2.6626, 0.54]);
                translate([3.965, 0, 0]) {
                    cube([7.93, 0.54, 16.2915]);
                };
                translate([3.965, 0, 16.2915]) {
                    rotate([-30, 0, 0]) {
                        cube([7.93, 0.54, 1.9486]);
                    };
                };
            };
            hull() {
                translate([7.93, 3.3290029984918, 17.2451]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=8, r2=2.255, r1=2.255);
                    };
                };
                translate([7.93, 3.3290029984918, 19.4951]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=8, r2=2.706, r1=2.706);
                    };
                };
            };
        };
        translate([7.93, 0.54, 0.54]) {
            rotate([0, 270, 0]) {
                linear_extrude(height=0.54) {
                    polygon([[0, 0], [15.2065, 0], [0, 15.880741345346]]);
                };
            };
        };
    };
    translate([5.6107, 1.3313, -0.1]) {
        linear_extrude(height=0.74) {
            text(valign="center", text="a37aecc", halign="right", size=0.9516);
        };
    };
    translate([4.9627, 19.9692, -0.1]) {
        linear_extrude(height=0.74) {
            text(valign="center", text="T2KV1", halign="left", size=0.9516);
        };
    };
};

