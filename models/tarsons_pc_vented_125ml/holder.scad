$fn = 50;

difference() {
    union() {
        translate([2.2167, 0, 0]) {
            cube([2.2167, 8.0745, 0.22]);
        };
        union() {
            translate([0, 7.0652, 0]) {
                cube([6.65, 1.0093, 0.22]);
            };
            translate([2.2167, 8.0745, 0]) {
                rotate([180, 270, 0]) {
                    linear_extrude(height=0.22) {
                        polygon([[0, 0], [2.8795344675833, 0], [0, 1.6625]]);
                    };
                };
            };
            translate([4.2134, 8.0745, 0]) {
                rotate([180, 270, 0]) {
                    linear_extrude(height=0.22) {
                        polygon([[0, 0], [2.8795344675833, 0], [0, 1.6625]]);
                    };
                };
            };
        };
        difference() {
            union() {
                cube([6.65, 1.0093, 0.22]);
                translate([1.6625, 0, 0]) {
                    cube([3.325, 0.22, 5.2316]);
                };
                translate([1.6625, 0, 5.2316]) {
                    rotate([-30, 0, 0]) {
                        cube([3.325, 0.22, 1.6454]);
                    };
                };
            };
            hull() {
                translate([3.325, 2.4438650024201, 6.132]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=6, r2=1.905, r1=1.905);
                    };
                };
                translate([3.325, 2.4438650024201, 8.032]) {
                    rotate([60, 0, 0]) {
                        cylinder(h=6, r2=2.286, r1=2.286);
                    };
                };
            };
        };
        translate([3.325, 0.22, 0.22]) {
            rotate([0, 270, 0]) {
                linear_extrude(height=0.22) {
                    polygon([[0, 0], [4.7866, 0], [0, 5.1260767223726]]);
                };
            };
        };
    };
    translate([2.3487, 0.5047, -0.1]) {
        linear_extrude(height=0.42) {
            text(valign="center", text="4627203", halign="right", size=0.399);
        };
    };
};

