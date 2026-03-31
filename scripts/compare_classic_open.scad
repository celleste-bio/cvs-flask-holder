// Comparison scene for the original open-rim flask set.
// Each cell shows:
// - holder only at y = 22
// - holder with flask at y = 0
// - flask only at y = -22

translate([0, 22, 0]) {
    import("../models/100ml/holder.stl");
}
translate([0, 0, 0]) {
    import("../models/100ml/holder_with_flask.stl");
}
translate([0, -22, 0]) {
    import("../models/100ml/flask.stl");
}

translate([24, 22, 0]) {
    import("../models/250ml/holder.stl");
}
translate([24, 0, 0]) {
    import("../models/250ml/holder_with_flask.stl");
}
translate([24, -22, 0]) {
    import("../models/250ml/flask.stl");
}

translate([48, 22, 0]) {
    import("../models/500ml/holder.stl");
}
translate([48, 0, 0]) {
    import("../models/500ml/holder_with_flask.stl");
}
translate([48, -22, 0]) {
    import("../models/500ml/flask.stl");
}

translate([72, 22, 0]) {
    import("../models/1000ml/holder.stl");
}
translate([72, 0, 0]) {
    import("../models/1000ml/holder_with_flask.stl");
}
translate([72, -22, 0]) {
    import("../models/1000ml/flask.stl");
}
