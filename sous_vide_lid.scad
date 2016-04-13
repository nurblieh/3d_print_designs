include <sous_vide_globals.scad>;
include <screw_lib.scad>;

// Generates a tapered hole for a tapered screw.
// TODO: May be able to refactor and re-use with the case.
module screw_hole(x, y, z, h, spec) {
  post_sz = screw_post_sz(spec);
  head_h = screw_head_h(spec);
  head_d = screw_head_d(spec);
  shaft_d = screw_shaft_d(spec);
  translate([x, y, z]) {
    // Center over the screw post.
    translate([post_sz/2, post_sz/2, -XS]) {
      // Screw shaft
      cylinder(h,
               d=(shaft_d + OFFSET),
               $fn=20);
      // Screw head
      cylinder(head_h + OFFSET,
               d1=(head_d + OFFSET),
               d2=(shaft_d + OFFSET), $fn=20);
    }
  }
}

// Generate a post/mount location with a screw hole.
// TODO: May be able to refactor and re-use with the case.
module screw_post(x, y, z, h, spec) {
  post_sz = screw_post_sz(spec);
  shaft_d = screw_shaft_d(spec);
  translate([x, y, z]) {
    difference() {
      cube([post_sz, post_sz, h]);
      translate([post_sz/2, post_sz/2, -XS]) {
        cylinder(h=(h + 2*XS),
                 d=(shaft_d + OFFSET),
                 $fn=20);
      }
    }
  }
}

module sous_vide_lid() {
  post_sz = screw_post_sz(SCREW_SPEC);
  translate([-(BODY_X/2), -(BODY_Y/2), 0]) {
    difference() {
      // exterior
      cube([BODY_X,
            BODY_Y,
            LID_Z]);
      // cutout interior and builds lip
      translate([LIP_THK-OFFSET,
                 LIP_THK-OFFSET,
                 WALL_THK]) {
        cube([(BODY_X + 2*OFFSET) - 2*(LIP_THK),
              (BODY_Y + 2*OFFSET) - (LIP_THK+PORT_LIP_THK),
              LID_Z]);
      }
      screw_hole(WALL_THK, WALL_THK, 0, LID_Z, SCREW_SPEC);
      screw_hole(BODY_X-WALL_THK-post_sz,
                 WALL_THK, 0, LID_Z, SCREW_SPEC);
      screw_hole(WALL_THK,
                 BODY_Y-WALL_THK-post_sz, 0, LID_Z, SCREW_SPEC);
      screw_hole(BODY_X-WALL_THK-post_sz,
                 BODY_Y-WALL_THK-post_sz, 0, LID_Z, SCREW_SPEC);
    } // difference
    post_h = LID_Z - WALL_THK - LIP_THK;
    screw_post(WALL_THK, WALL_THK, WALL_THK,
               post_h, SCREW_SPEC);
    screw_post(BODY_X-WALL_THK-post_sz,
               WALL_THK,
               WALL_THK,
               post_h, SCREW_SPEC);
    screw_post(WALL_THK,
               BODY_Y-WALL_THK-post_sz,
               WALL_THK,
               post_h, SCREW_SPEC);
    screw_post(BODY_X-WALL_THK-post_sz,
               BODY_Y-WALL_THK-post_sz,
               WALL_THK,
               post_h, SCREW_SPEC);
    // Supporting interior walls
    // back divider
    translate([BODY_X - 52 - WALL_THK, BODY_Y-32-WALL_THK, WALL_THK]) {
      cube([WALL_THK, 32+WALL_THK, post_h]);
    }
    // side flanges
    translate([LIP_THK-OFFSET, 85, WALL_THK]) {
      cube([16.5+OFFSET, WALL_THK, post_h]);
    }
    translate([BODY_X-WALL_THK-15, 85, WALL_THK]) {
      cube([16.5+OFFSET, WALL_THK, post_h]);
    }
  } // view-port
}
sous_vide_lid();
