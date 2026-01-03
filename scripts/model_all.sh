#!/bin/bash

echo "100 ml"
lua src/flask.lua 100ml/measurements.yaml 100ml/flask.scad
lua src/holder.lua 100ml/measurements.yaml 100ml/holder.scad
lua src/holder.lua 100ml/measurements.yaml 100ml/holder_with_flask.scad true

echo "250 ml"
lua src/flask.lua 250ml/measurements.yaml 250ml/flask.scad
lua src/holder.lua 250ml/measurements.yaml 250ml/holder.scad
lua src/holder.lua 250ml/measurements.yaml 250ml/holder_with_flask.scad true

echo "500 ml"
lua src/flask.lua 500ml/measurements.yaml 500ml/flask.scad
lua src/holder.lua 500ml/measurements.yaml 500ml/holder.scad
lua src/holder.lua 500ml/measurements.yaml 500ml/holder_with_flask.scad true

echo "1000 ml"
lua src/flask.lua 1000ml/measurements.yaml 1000ml/flask.scad
lua src/holder.lua 1000ml/measurements.yaml 1000ml/holder.scad
lua src/holder.lua 1000ml/measurements.yaml 1000ml/holder_with_flask.scad true

echo "2000 ml"
lua src/flask.lua 2000ml/measurements.yaml 2000ml/flask.scad
lua src/holder.lua 2000ml/measurements.yaml 2000ml/holder.scad
lua src/holder.lua 2000ml/measurements.yaml 2000ml/holder_with_flask.scad true

