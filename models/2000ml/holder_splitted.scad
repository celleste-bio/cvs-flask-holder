$fn = 50;

module holder() {
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
                                cylinder(h=5.5, r=2.6775);
                            };
                        };
                        translate([8.2, 5.495, 21.03]) {
                            rotate([60, 0, 0]) {
                                cylinder(h=5.5, r=3.7485);
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
                cylinder(h=17.39, r=8.2);
            };
            translate([16.9, 8.7, -1]) {
                cylinder(h=17.39, r=8.2);
            };
        };
    };
}

module connector() {
    translate([3.2, 8, -2]) {
        rotate([15, 0, 0]) {
            translate([-1, 2, 2]) {
                cube([12, 3, 1]);
            }
        }
        
        rotate([15, 0, 0]) {
            translate([-1, 2, 4]) {
                cube([12, 3, 1]);
            }
        }
        
        rotate([15, 0, 0]) {
            translate([-1, 2, 6]) {
                cube([12, 3, 1]);
            }
        }
    }
}

module front_cutoff() {
    union() {
        translate([-1, -1, -1]) {
            cube([20, 11, 22]);
        }
        connector();
    }
}

module rear_cutoff() {
    difference() {
        translate([-1, 10, -1]) {
            cube([20, 20, 22]);
        }
        connector();
    }
}

module rear_part() {
    difference() {
        holder();
        front_cutoff();
    }
}

module front_part() {
    difference() {
        holder();
        rear_cutoff();
    }
}

//front_part();
rear_part();
