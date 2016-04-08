// GLOBALS
xs = 1;
// m3 dimensions
m3_post_sz = 8;
m3_screw_head_h = 2.5;
m3_screw_head_r = 6 / 2;
m3_shaft_r = 3.2 / 2;

// m4 dimensions
m4_post_sz = 9.5;
m4_screw_head_h = 3;
m4_screw_head_r = 8 / 2;
m4_shaft_r = 4.3 / 2;

// Switch here. (So lazy.)
post_sz = m4_post_sz;
screw_head_h = m4_screw_head_h;
screw_head_r = m4_screw_head_r;
shaft_r = m4_shaft_r;

module screw_hole(x, y, z, h) {
  translate([x, y, z]) {
    translate([post_sz/2, post_sz/2, -xs]) {
      cylinder(h, shaft_r + .05, shaft_r + .05, $fn=20);
      cylinder(screw_head_h + .1, 
               screw_head_r + .05, 
               shaft_r + .05, $fn=20);
    }
  }
}

module screw_post(x, y, z, h) {
  translate([x, y, z]) {
    difference() {
      cube([post_sz, post_sz, h]);
      translate([post_sz/2, post_sz/2, -xs]) {
        cylinder(h+2*xs, 
                 shaft_r + .05, 
                 shaft_r + .05, $fn=20);
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
  // Extra space for part interaction.
  clr_off = 0.1;
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