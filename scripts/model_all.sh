#!/bin/bash

echo "100 ml"
lua src/flask.lua models/100ml/measurements.yaml models/100ml/flask.scad
lua src/holder.lua models/100ml/measurements.yaml models/100ml/holder.scad
lua src/holder.lua models/100ml/measurements.yaml models/100ml/holder_with_flask.scad true

echo "250 ml"
lua src/flask.lua models/250ml/measurements.yaml models/250ml/flask.scad
lua src/holder.lua models/250ml/measurements.yaml models/250ml/holder.scad
lua src/holder.lua models/250ml/measurements.yaml models/250ml/holder_with_flask.scad true

echo "500 ml"
lua src/flask.lua models/500ml/measurements.yaml models/500ml/flask.scad
lua src/holder.lua models/500ml/measurements.yaml models/500ml/holder.scad
lua src/holder.lua models/500ml/measurements.yaml models/500ml/holder_with_flask.scad true

echo "1000 ml"
lua src/flask.lua models/1000ml/measurements.yaml models/1000ml/flask.scad
lua src/holder.lua models/1000ml/measurements.yaml models/1000ml/holder.scad
lua src/holder.lua models/1000ml/measurements.yaml models/1000ml/holder_with_flask.scad true

echo "2000 ml"
lua src/flask.lua models/2000ml/measurements.yaml models/2000ml/flask.scad
lua src/holder.lua models/2000ml/measurements.yaml models/2000ml/holder.scad
lua src/holder.lua models/2000ml/measurements.yaml models/2000ml/holder_with_flask.scad true

