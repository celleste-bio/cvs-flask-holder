// Auto-generated comparison file
// Each holder.scad translated by 15 mm along X
// Each flask.scad placed 20 mm below its holder

translate([0, -30, 0])
rotate([90, 0, 0])
import("../models/100ml/erlenmeyer-100ml.stl");

translate([0, 20, 0]) {
    // 100 ml holder
    include <../models/100ml/holder.scad>
}
translate([0, 0, 0]) {
    // 100 ml holder
    include <../models/100ml/holder_with_flask.scad>
}
translate([0, -20, 0]) {
    // 100 ml flask
    include <../models/100ml/flask.scad>
}

translate([15, 20, 0]) {
    // 250 ml holder
    include <../models/250ml/holder.scad>
}
translate([15, 0, 0]) {
    // 250 ml holder
    include <../models/250ml/holder_with_flask.scad>
}
translate([15, -20, 0]) {
    // 250 ml flask
    include <../models/250ml/flask.scad>
}

translate([30, 20, 0]) {
    // 500 ml holder
    include <../models/500ml/holder.scad>
}
translate([30, 0, 0]) {
    // 500 ml holder
    include <../models/500ml/holder_with_flask.scad>
}
translate([30, -20, 0]) {
    // 500 ml flask
    include <../models/500ml/flask.scad>
}

translate([45, 20, 0]) {
    // 1000 ml holder
    include <../models/1000ml/holder.scad>
}
translate([45, 0, 0]) {
    // 1000 ml holder
    include <../models/1000ml/holder_with_flask.scad>
}
translate([45, -20, 0]) {
    // 1000 ml flask
    include <../models/1000ml/flask.scad>
}

translate([60, 20, 0]) {
    // 2000 ml holder
    include <../models/2000ml/holder.scad>
}
translate([60, 0, 0]) {
    // 2000 ml holder
    include <../models/2000ml/holder_with_flask.scad>
}
translate([60, -20, 0]) {
    // 2000 ml flask
    include <../models/2000ml/flask.scad>
}
