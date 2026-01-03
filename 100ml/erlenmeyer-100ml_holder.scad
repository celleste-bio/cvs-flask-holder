
$fn = 1000;

difference() {
    union() {
            scale([0.5,1,1]){
                cylinder(0.2,7,7);
            }
            translate([-2,-5,0]) {
                cube([4,10,5]);
            }
    }
    union() {
        translate([0,-3,2.4]) {
            rotate([30,0,0]) {
                import("erlenmeyer-100ml_solid.stl");
            }
        }
        translate([-2.5,-6.2,4]) {
            cube([5,5,5,]);
        }
    }
}
