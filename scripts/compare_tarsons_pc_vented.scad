// Comparison scene for all Tarsons plastic capped vented flask models.
// Each cell shows:
// - holder only at y = 22
// - holder with flask at y = 0
// - flask only at y = -22

// Row 1
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

// Row 2
translate([0, -65, 0]) {
    import("../models/tarsons_pc_vented_1000ml/holder.stl");
}
translate([0, -87, 0]) {
    import("../models/tarsons_pc_vented_1000ml/holder_with_flask.stl");
}
translate([0, -109, 0]) {
    import("../models/tarsons_pc_vented_1000ml/flask.stl");
}

translate([24, -65, 0]) {
    import("../models/tarsons_pc_vented_2000ml/holder.stl");
}
translate([24, -87, 0]) {
    import("../models/tarsons_pc_vented_2000ml/holder_with_flask.stl");
}
translate([24, -109, 0]) {
    import("../models/tarsons_pc_vented_2000ml/flask.stl");
}
