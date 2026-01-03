difference() {
    union() {
        translate([0, 0, 1]) {
            union() {
                cylinder(h=116, r2=17, r1=42.5);
                translate([0, 0, 116]) {
                    cylinder(h=29, r2=17, r1=17);
                };
                translate([0, 0, 144.15]) {
                    rotate_extrude(convexity=10) {
                        translate([17, 0, 0]) {
                            circle(r=1.7);
                        };
                    };
                };
            };
        };
        union() {
            translate([0, 0, -1.7]) {
                cylinder(h=3.4, r2=40.2, r1=40.2);
            };
            translate([0, 0, 1.7]) {
                rotate_extrude(convexity=10) {
                    translate([39.2, 0, 0]) {
                        circle(r=3.4);
                    };
                };
            };
        };
    };
    translate([0, 0, -124.1]) {
        sphere(r=127.5);
    };
};