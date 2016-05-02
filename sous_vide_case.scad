include <sous_vide_globals.scad>;
include <screw_lib.scad>;
use <sous_vide_lid.scad>;

module captive_nut_post(x, y, z, h, spec) {
  post_sz = screw_post_sz(spec);
  nut_h = screw_nut_h(spec);
  nut_w = screw_nut_w(spec);
  shaft_d = screw_shaft_d(spec);
  translate([x, y, z]) {
    difference() {
      cube([post_sz, post_sz, h]);
      translate([post_sz/2, post_sz/2, 0]) {
        // Hole for bolt shaft.
        cylinder(h=(h - 4.5 + XS),
                 d=(shaft_d + OFFSET),
                 $fn=20);
        // captive nut hex hole. 1mm extra height for material.
        translate([0, 0, h-(nut_h+1)]) {
          cylinder(h=(nut_h + 2 + XS),
                   r=(nut_w / 2 / cos(180 / 6) + (OFFSET/2)), $fn=6);
        }
      }
    }
  }
}

module sous_vide_case() {
  // Port cut-out dimensions
  stc_1000_dim = [69, 0, 28];  // [x, y, z]
  pwr_out_dim = [24, 0, 22];   // BX-6B American power plug
  probe_dim = [4.5, 0, 2];
  pwr_in_dim = [46.1, 0, 27.5];
  post_sz = screw_post_sz(SCREW_SPEC);

  // Adjust dimensions so port is below lid and "punches" through.
  function port_cutout(dim) = [dim[0] + 2*OFFSET,
                               WALL_THK + 2*XS,
                               dim[2] + 2*OFFSET + LIP_THK + XS];

  // Center the object in view port, along x and y.
  translate([-(BODY_X/2), -(BODY_Y/2), 0]) {
    difference() {
      // Case body
      union() {
        cube([BODY_X, BODY_Y, (BODY_Z - LIP_THK)]);
        // case/lid lip.
        translate([LIP_THK, LIP_THK, LIP_THK]) {
          cube([BODY_X-(2*LIP_THK),
                BODY_Y-(2*LIP_THK),
                BODY_Z-LIP_THK]);
        }
      }

      // Cut-out interior
      translate([WALL_THK, WALL_THK, WALL_THK]) {
        cube([BODY_X - 2*WALL_THK, //114
              BODY_Y - 2*WALL_THK, //156
              BODY_Z]);
      }
      // STC-1000 hole
      translate([(BODY_X-stc_1000_dim[0])/2 - OFFSET,
                 -XS,
                 BODY_Z - (stc_1000_dim[2]+LIP_THK+2*OFFSET)
                 ]) {
        cube(port_cutout(stc_1000_dim));
      }

      // Pwr out hole
      translate([17,
                 BODY_Y-WALL_THK-XS,
                 BODY_Z-(pwr_out_dim[2]+LIP_THK)]) {
        cube(port_cutout(pwr_out_dim));
        // lip for pwr out
        translate([-PORT_LIP_DEPTH, 0, 0]) {
          cube([port_cutout(pwr_out_dim)[0] + 2*PORT_LIP_DEPTH,
                WALL_THK-PORT_LIP_THK+XS,
                port_cutout(pwr_out_dim)[2]]);
        }
      }
      // Probe wire hole
      translate([47,
                 BODY_Y-WALL_THK-XS,
                 BODY_Z-(probe_dim[2]+LIP_THK) ]) {
        cube(port_cutout(probe_dim));
      }
      // Pwr in + switch hole
      translate([57,
                 BODY_Y-WALL_THK-XS,
                 BODY_Z-(pwr_in_dim[2]+LIP_THK+2*OFFSET) ]) {
        cube(port_cutout(pwr_in_dim));
        // 1 mm bottom lip for pwr in+switch.
        translate([0, 0, -(PORT_LIP_DEPTH+OFFSET)]) {
          cube([port_cutout(pwr_in_dim)[0],
                WALL_THK - PORT_LIP_THK + XS,
                PORT_LIP_DEPTH + OFFSET + XS]);
        }
      }
    } // END OF CASE'S DIFFERENCE()
    // Lid mounting posts.
    captive_nut_post(x=WALL_THK,
                     y=WALL_THK,
                     z=WALL_THK,
                     h=BODY_Z - WALL_THK,
                     spec=SCREW_SPEC);
    captive_nut_post(x=BODY_X - WALL_THK - post_sz,
                     y=WALL_THK,
                     z=WALL_THK,
                     h=BODY_Z - WALL_THK,
                     spec=SCREW_SPEC);
    captive_nut_post(x=WALL_THK,
                     y=BODY_Y - WALL_THK - post_sz,
                     z=WALL_THK,
                     h=BODY_Z - WALL_THK,
                     spec=SCREW_SPEC);
    captive_nut_post(x=BODY_X - WALL_THK - post_sz,
                     y=BODY_Y - WALL_THK - post_sz,
                     z=WALL_THK,
                     h=BODY_Z - WALL_THK,
                     spec=SCREW_SPEC);

    // Supporting interior walls
    // back divider
    translate([52, BODY_Y-32-WALL_THK, 3]) {
      cube([3, 32, 33.5]);
    }
    // side flanges
    translate([WALL_THK, 85, WALL_THK]) {
      cube([15, WALL_THK, BODY_Z-WALL_THK]);
    }
    translate([BODY_X-WALL_THK-15, 85, WALL_THK]) {
      cube([15, WALL_THK, BODY_Z-WALL_THK]);
    }
  } // view-port translation.
}
sous_vide_case();

// Display lid above case body.
//translate([0, 0, 45]) {
//  rotate([0, 180, 0]) {
//    sous_vide_lid();
//  }
//}
