
$fn = 100;

rotate([270,0,0]) {
    rotate_extrude() {
        projection(cut=false) {
            difference() {
                import("erlenmeyer-250ml.stl");
                translate([-10,0,-5]){
                    cube([10,20,10]);
                }
            }
        }
    }
}
