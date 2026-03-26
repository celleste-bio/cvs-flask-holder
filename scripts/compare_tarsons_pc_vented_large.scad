// Smaller comparison scene for Tarsons 1000/2000 mL plastic capped vented flasks.

translate([0, 22, 0]) {
    include <../models/tarsons_pc_vented_1000ml/holder.scad>
}
translate([0, 0, 0]) {
    include <../models/tarsons_pc_vented_1000ml/holder_with_flask.scad>
}
translate([0, -22, 0]) {
    include <../models/tarsons_pc_vented_1000ml/flask.scad>
}

translate([24, 22, 0]) {
    include <../models/tarsons_pc_vented_2000ml/holder.scad>
}
translate([24, 0, 0]) {
    include <../models/tarsons_pc_vented_2000ml/holder_with_flask.scad>
}
translate([24, -22, 0]) {
    include <../models/tarsons_pc_vented_2000ml/flask.scad>
}
