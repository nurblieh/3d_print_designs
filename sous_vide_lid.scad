// GLOBALS
// Use this when cutting out to "punch through" faces.
// Clears up rendering artifacts and non-2-manifold errors.
xs = 1;
// Extra space for part interaction.
clr_off = 0.25;

// Generates a tapered hole for a tapered screw of the desired metric size.
module screw_hole(x, y, z, h, screw_spec) {
  if (screw_spec == "m3") {
    _screw_hole(x, y, z, h,
                post_sz=8,
                screw_head_h=2.5, screw_head_d=6,
                shaft_d=3.4);
  } else if (screw_spec == "m4") {
    _screw_hole(x, y, z, h,
                post_sz=9.5,
                screw_head_h=3, screw_head_d=9,
                shaft_d=4.5);
  } else {
    echo("This screw spec not implemented: ", screw_spec);
  }
}

// Private method, see screw_hole().
module _screw_hole(x, y, z, h,
                   post_sz,
                   screw_head_h, screw_head_d,
                   shaft_d) {
  translate([x, y, z]) {
    // Center over the screw post.
    translate([post_sz/2, post_sz/2, -xs]) {
      // Screw shaft
      cylinder(h, 
               d=(shaft_d + clr_off), 
               $fn=20);
      // Screw head
      cylinder(screw_head_h + clr_off, 
               d1=(screw_head_d + clr_off), 
               d2=(shaft_d + clr_off), $fn=20);
    }
  }
}

// Generate a post/mount location with a screw hole of the desired metric size.
module screw_post(x, y, z, h, screw_spec) {
  if (screw_spec == "m3") {
    _screw_post(x, y, z, h,
                post_sz=8,
                shaft_d=3.4);
  } else if (screw_spec == "m4") {
    _screw_post(x, y, z, h,
                post_sz=9.5,
                shaft_d=4.5);
  } else {
    echo("This screw spec not implemented: ", screw_spec);
  }
}

// Private method, see screw_post().
module _screw_post(x, y, z, h,
                   post_sz,
                   shaft_d) {
  translate([x, y, z]) {
    difference() {
      cube([post_sz, post_sz, h]);
      translate([post_sz/2, post_sz/2, -xs]) {
        cylinder(h + 2*xs, 
                 shaft_r + clr_off/2, 
                 shaft_r + clr_off/2, $fn=20);
        // Create a extra space for bolt head to sit flush.
//        translate(0, 0, -xs) {
//          cylinder(.1+xs, 
//                   screw_head_r + .05, 
//                   screw_head_r + .05, $fn=20);
//        }
      }
    }
  }
}

module sous_vide_lid() {
  body_x = 120;
  body_y = 140;
  lid_z = 7;
  wall_thk = 3;
  lip_thk = 1.5;
  // Back lip is 1mm to better line up with power port lips.
  port_lip_thk = 1.0;  
  translate([-(body_x/2), -(body_y/2), 0]) {
    difference() {
      // exterior
      cube([body_x, 
            body_y, 
            lid_z]);
      // cutout interior and builds lip
      translate([lip_thk-clr_off, 
                 lip_thk-clr_off, 
                 wall_thk]) {
        cube([(body_x + 2*clr_off) - 2*(lip_thk), 
              (body_y + 2*clr_off) - (lip_thk+port_lip_thk), 
              lid_z]);
      }
      screw_hole(wall_thk, wall_thk, 0, lid_z);
      screw_hole(body_x-wall_thk-post_sz, 
                 wall_thk, 0, lid_z);
      screw_hole(wall_thk, 
                 body_y-wall_thk-post_sz, 0, lid_z);
      screw_hole(body_x-wall_thk-post_sz, 
                 body_y-wall_thk-post_sz, 0, lid_z);
    } // difference
    post_h = lid_z - wall_thk - lip_thk;
    screw_post(wall_thk, wall_thk, wall_thk, 
               post_h);
    screw_post(body_x-wall_thk-post_sz, 
               wall_thk, 
               wall_thk,
               post_h);
    screw_post(wall_thk, 
               body_y-wall_thk-post_sz, 
               wall_thk, 
               post_h);
    screw_post(body_x-wall_thk-post_sz, 
               body_y-wall_thk-post_sz, 
               wall_thk, 
               post_h);
    // Supporting interior walls
    // back divider
    translate([body_x - 52 - wall_thk, body_y-32-wall_thk, wall_thk]) {
      cube([wall_thk, 32+wall_thk, post_h]);
    }
    // side flanges
    translate([lip_thk-clr_off, 85, wall_thk]) {
      cube([16.5+clr_off, wall_thk, post_h]);
    }
    translate([body_x-wall_thk-15, 85, wall_thk]) {
      cube([16.5+clr_off, wall_thk, post_h]);
    }    
  } // view-port
}
sous_vide_lid();
