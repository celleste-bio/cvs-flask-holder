// Comparison scene for the original open-rim flask set.
// Each cell shows:
// - holder only at y = 22
// - holder with flask at y = 0
// - flask only at y = -22

translate([0, 22, 0]) {
    include <../models/100ml/holder.scad>
}
translate([0, 0, 0]) {
    include <../models/100ml/holder_with_flask.scad>
}
translate([0, -22, 0]) {
    include <../models/100ml/flask.scad>
}

translate([24, 22, 0]) {
    include <../models/250ml/holder.scad>
}
translate([24, 0, 0]) {
    include <../models/250ml/holder_with_flask.scad>
}
translate([24, -22, 0]) {
    include <../models/250ml/flask.scad>
}

translate([48, 22, 0]) {
    include <../models/500ml/holder.scad>
}
translate([48, 0, 0]) {
    include <../models/500ml/holder_with_flask.scad>
}
translate([48, -22, 0]) {
    include <../models/500ml/flask.scad>
}

translate([72, 22, 0]) {
    include <../models/1000ml/holder.scad>
}
translate([72, 0, 0]) {
    include <../models/1000ml/holder_with_flask.scad>
}
translate([72, -22, 0]) {
    include <../models/1000ml/flask.scad>
}
