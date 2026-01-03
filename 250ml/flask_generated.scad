$fn = 50;

difference() {
    translate([0, 0, 0.88]) {
        union() {
            cylinder(h=10.62, r2=1.8, r1=4.1);
            translate([0, 0, 10.62]) {
                cylinder(h=2.8, r2=1.8, r1=1.8);
            };
            translate([0, 0, 13.22]) {
                rotate_extrude(convexity=10) {
                    translate([1.8, 0, 0]) {
                        circle(r=0.36);
                    };
                };
            };
            union() {
                rotate_extrude(convexity=10) {
                    translate([3.22, 0, 0]) {
                        circle(r=0.88);
                    };
                };
                translate([0, 0, -0.88]) {
                    cylinder(h=0.88, r2=3.22, r1=3.22);
                };
            };
        };
    };
    translate([0, 0, -15.96]) {
        sphere(r=16.4);
    };
};

