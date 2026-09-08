// Smaller comparison scene for Tarsons 1000/2000 mL plastic capped vented flasks.

translate([0, 22, 0]) {
    import("../models/tarsons_pc_vented_1000ml/holder.stl");
}
translate([0, 0, 0]) {
    import("../models/tarsons_pc_vented_1000ml/holder_with_flask.stl");
}
translate([0, -22, 0]) {
    import("../models/tarsons_pc_vented_1000ml/flask.stl");
}

translate([24, 22, 0]) {
    import("../models/tarsons_pc_vented_2000ml/holder.stl");
}
translate([24, 0, 0]) {
    import("../models/tarsons_pc_vented_2000ml/holder_with_flask.stl");
}
translate([24, -22, 0]) {
    import("../models/tarsons_pc_vented_2000ml/flask.stl");
}
