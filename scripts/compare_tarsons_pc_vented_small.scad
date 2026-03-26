// Smaller comparison scene for Tarsons 125/250/500 mL plastic capped vented flasks.

translate([0, 22, 0]) {
    include <../models/tarsons_pc_vented_125ml/holder.scad>
}
translate([0, 0, 0]) {
    include <../models/tarsons_pc_vented_125ml/holder_with_flask.scad>
}
translate([0, -22, 0]) {
    include <../models/tarsons_pc_vented_125ml/flask.scad>
}

translate([24, 22, 0]) {
    include <../models/tarsons_pc_vented_250ml/holder.scad>
}
translate([24, 0, 0]) {
    include <../models/tarsons_pc_vented_250ml/holder_with_flask.scad>
}
translate([24, -22, 0]) {
    include <../models/tarsons_pc_vented_250ml/flask.scad>
}

translate([48, 22, 0]) {
    include <../models/tarsons_pc_vented_500ml/holder.scad>
}
translate([48, 0, 0]) {
    include <../models/tarsons_pc_vented_500ml/holder_with_flask.scad>
}
translate([48, -22, 0]) {
    include <../models/tarsons_pc_vented_500ml/flask.scad>
}
