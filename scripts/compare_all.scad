// Comparison scene for all current flask holder variants.
// Each cell shows:
// - holder only at y = 22
// - holder with flask at y = 0
// - flask only at y = -22
translate([0, 160, 0]){
// Row 1
translate([0, 22, 0]) {
    // 100 ml holder
    import("../models/100ml/holder.stl");
}
translate([0, 0, 0]) {
    // 100 ml holder with flask
    import("../models/100ml/holder_with_flask.stl");
}
translate([0, -22, 0]) {
    // 100 ml flask
    import("../models/100ml/flask.stl");
}

translate([24, 22, 0]) {
    // 250 ml holder
    import("../models/250ml/holder.stl");
}
translate([24, 0, 0]) {
    // 250 ml holder with flask
    import("../models/250ml/holder_with_flask.stl");
}
translate([24, -22, 0]) {
    // 250 ml flask
    import("../models/250ml/flask.stl");
}

translate([48, 22, 0]) {
    // 500 ml holder
    import("../models/500ml/holder.stl");
}
translate([48, 0, 0]) {
    // 500 ml holder with flask
    import("../models/500ml/holder_with_flask.stl");
}
translate([48, -22, 0]) {
    // 500 ml flask
    import("../models/500ml/flask.stl");
}

// Row 2
translate([0, -65, 0]) {
    // 1000 ml holder
    import("../models/1000ml/holder.stl");
}
translate([0, -87, 0]) {
    // 1000 ml holder with flask
    import("../models/1000ml/holder_with_flask.stl");
}
translate([0, -109, 0]) {
    // 1000 ml flask
    import("../models/1000ml/flask.stl");
}

translate([24, -65, 0]) {
    // Tarsons PC vented 125 ml holder
    import("../models/tarsons_pc_vented_125ml/holder.stl");
}
translate([24, -87, 0]) {
    // Tarsons PC vented 125 ml holder with flask
    import("../models/tarsons_pc_vented_125ml/holder_with_flask.stl");
}
translate([24, -109, 0]) {
    // Tarsons PC vented 125 ml flask
    import("../models/tarsons_pc_vented_125ml/flask.stl");
}

translate([48, -65, 0]) {
    // Tarsons PC vented 250 ml holder
    import("../models/tarsons_pc_vented_250ml/holder.stl");
}
translate([48, -87, 0]) {
    // Tarsons PC vented 250 ml holder with flask
    import("../models/tarsons_pc_vented_250ml/holder_with_flask.stl");
}
translate([48, -109, 0]) {
    // Tarsons PC vented 250 ml flask
    import("../models/tarsons_pc_vented_250ml/flask.stl");
}

// Row 3
translate([0, -152, 0]) {
    // Tarsons PC vented 500 ml holder
    import("../models/tarsons_pc_vented_500ml/holder.stl");
}
translate([0, -174, 0]) {
    // Tarsons PC vented 500 ml holder with flask
    import("../models/tarsons_pc_vented_500ml/holder_with_flask.stl");
}
translate([0, -196, 0]) {
    // Tarsons PC vented 500 ml flask
    import("../models/tarsons_pc_vented_500ml/flask.stl");
}

translate([24, -152, 0]) {
    // Tarsons PC vented 1000 ml holder
    import("../models/tarsons_pc_vented_1000ml/holder.stl");
}
translate([24, -174, 0]) {
    // Tarsons PC vented 1000 ml holder with flask
    import("../models/tarsons_pc_vented_1000ml/holder_with_flask.stl");
}
translate([24, -196, 0]) {
    // Tarsons PC vented 1000 ml flask
    import("../models/tarsons_pc_vented_1000ml/flask.stl");
}

translate([48, -152, 0]) {
    // Tarsons PC vented 2000 ml holder
    import("../models/tarsons_pc_vented_2000ml/holder.stl");
}
translate([48, -174, 0]) {
    // Tarsons PC vented 2000 ml holder with flask
    import("../models/tarsons_pc_vented_2000ml/holder_with_flask.stl");
}
translate([48, -196, 0]) {
    // Tarsons PC vented 2000 ml flask
    import("../models/tarsons_pc_vented_2000ml/flask.stl");
}
}