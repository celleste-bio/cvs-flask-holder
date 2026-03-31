// Smaller comparison scene for Tarsons 125/250/500 mL plastic capped vented flasks.

translate([0, 22, 0]) {
    import("../models/tarsons_pc_vented_125ml/holder.stl");
}
translate([0, 0, 0]) {
    import("../models/tarsons_pc_vented_125ml/holder_with_flask.stl");
}
translate([0, -22, 0]) {
    import("../models/tarsons_pc_vented_125ml/flask.stl");
}

translate([24, 22, 0]) {
    import("../models/tarsons_pc_vented_250ml/holder.stl");
}
translate([24, 0, 0]) {
    import("../models/tarsons_pc_vented_250ml/holder_with_flask.stl");
}
translate([24, -22, 0]) {
    import("../models/tarsons_pc_vented_250ml/flask.stl");
}

translate([48, 22, 0]) {
    import("../models/tarsons_pc_vented_500ml/holder.stl");
}
translate([48, 0, 0]) {
    import("../models/tarsons_pc_vented_500ml/holder_with_flask.stl");
}
translate([48, -22, 0]) {
    import("../models/tarsons_pc_vented_500ml/flask.stl");
}
