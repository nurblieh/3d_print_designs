// A small OpenSCAD library for metric screw dimensions.
// Eg, screw_head_d("m3") == 6.0
//
// Indentation is the result of mixing OpenSCAD language
// with Emacs c-mode.
//
// Author: nurblieh@gmail.com

// Lookup table as a multi-dimensional array. Used in
// concert with the screw_dim_lookup() function. Values
// in millimeters.
//
// If you add any screws, be sure to follow the field
// ordering.
// Head dimensions are for flat head screws I had on hand.
// Each mfg will be difference. An example set of specs,
// https://www.fastenal.com/content/product_specifications/M.FHSCS.10.9.BO.pdf
//
// If OpenSCAD implements a hash table (dictionary)
// this (gratefully) will be obsolete.
_screw_dims =
  [
   ["m2.5", [5.0,  // head diameter
             .75,  // head height
             2.9,  // shaft diameter
             2.0,  // nut height
             5.0   // nut width
             ]],
   ["m3", [6.0,  // head diameter
           2.5,  // head height
           3.4,  // shaft diameter
           2.4,  // nut height
           5.5   // nut width
           ]],
   ["m4", [9.0,  // head diameter
           3.0,  // head height
           4.5,  // shaft diameter
           2.9,  // nut height
           7.0   // nut width
           ]],
   ["m5", [10,   // head diameter
           2.3,  // head height
           5.5,  // shaft diameter
           4.4,  // nut height
           8.0   // nut width
           ]],
   ];

// Enum of sorts. Index of field in our lookup table.
_HEAD_D  = 0;
_HEAD_H  = 1;
_SHAFT_D = 2;
_NUT_H   = 3;
_NUT_W   = 4;

// Key lookup on our screw dimension table.
// This could be re-used as a general purpose hash or
// key-value lookup func.
// Args:
//   k: key
//   enum: index of desired screw dimension.
// Returns:
//   value or undef
function _screw_dim_lookup(k, enum) =
  (
   let(ret=search([k], _screw_dims))
   len(ret) > 0 ? _screw_dims[ret[0]][1][enum] : undef
   );

// Function to find the size (in mm) of a screw head.
// Args:
//   spec (string): Metric spec name. Eg, "m3".
// Returns:
//   (float)
function screw_head_d(spec) =
  (
   _screw_dim_lookup(spec, _HEAD_D)
   );

// See above function for docstring.
function screw_head_h(spec) =
  (
   _screw_dim_lookup(spec, _HEAD_H)
   );

// See above function for docstring.
function screw_shaft_d(spec) =
  (
   _screw_dim_lookup(spec, _SHAFT_D)
   );

// See above function for docstring.
function screw_nut_h(spec) =
  (
   _screw_dim_lookup(spec, _NUT_H)
   );

// See above function for docstring.
function screw_nut_w(spec) =
  (
   _screw_dim_lookup(spec, _NUT_W)
   );

// Size of a cubical post to fit a given screw/nut.
// First find the width of the nut, then using cosine,
// determine the diameter at the _points_ of the nut.
// Add 2 mm for the walls on either side.
function screw_post_sz(spec) =
  (
   let (ret = screw_nut_w(spec))
   ret != undef ? ret / cos(180 / 6) + 2 : undef
   );
