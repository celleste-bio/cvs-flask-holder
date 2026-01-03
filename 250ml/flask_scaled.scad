$fn = 50;

difference() {
    translate([0, 0, 1.2]) {  // base_edge
        union() {
            // conical body
            cylinder(h=9.9, r1=4.1, r2=1.8);

            // neck
            translate([0, 0, 9.9]) {
                cylinder(h=3.2, r1=1.8, r2=1.8);
            }

            // neck rim
            translate([0, 0, 13.91]) {
                rotate_extrude(convexity=10) {
                    translate([1.8, 0, 0]) {
                        circle(r=0.39);
                    }
                }
            }

            // base torus
            union() {
                rotate_extrude(convexity=10) {
                    translate([2.97, 0, 0]) {
                        circle(r=1.2);
                    }
                }
                translate([0, 0, -1.2]) {
                    cylinder(h=1.2, r2=2.97, r1=2.97);
                }
            }
        }
    }

    // bottom cut
    translate([0, 0, -16.545]) {
        sphere(r=17.5);
    }
}
