use <sous_vide_lid.scad>;

// Use this when extruding to "punch through" faces.
// Clears up rendering artifacts and non-2-manifold errors.
xs = 1;
// Clearance offset to account for the material "oozing" out.
// Required if you have parts that fit together after printing.
clr_off = 0.2;

// TODO: Combine m3 and m4 modules.
module captive_m3nut_post(x, y, z, h) {
  m3nut_h = 2.4;
  m3nut_w = 5.5;  // flat-to-flat side. corners are 6.01
  translate([x, y, z]) {
    difference() {
      cube([8, 8, h]);
      translate([4, 4, 0]) {
        // Hole for bolt shaft, below captive nut.
        cylinder(h-4.5+xs, 1.6, 1.6, $fn=20);
        // captive nut hex hole. 2mm extra height for material.
        translate([0, 0, h-(m3nut_h+2)]) {
          cylinder(h=(m3nut_h+2+xs), 
                   r=(m3nut_w / 2 / cos(180 / 6) + 0.05), $fn=6);
        }
      }
    }
  }
}

module captive_m4nut_post(x, y, z, h) {
  post_x = 9.5;
  nut_h = 2.9;
  nut_w = 7;  // flat-to-flat
  hole_d = 4.3 + clr_off;
  translate([x, y, z]) {
    difference() {
      cube([post_x, post_x, h]);
      translate([post_x/2, post_x/2, 0]) {
        // Hole for bolt shaft.
        cylinder(h-4.5+xs, 
                 hole_d/2, 
                 hole_d/2, $fn=20);
        // captive nut hex hole. 1mm extra height for material.
        translate([0, 0, h-(nut_h+1)]) {
          cylinder(h=(nut_h+2+xs), 
                   r=(nut_w / 2 / cos(180 / 6) + (clr_off/2)), $fn=6);
        }
      }
    }
  }
}

module sous_vide_case() {
  body_x = 120;
  body_y = 140;
  body_z = 36.5;
  wall_thk = 3;
  lip_thk = 1.5;
  // Back lip is smaller to line up with power port clips.
  port_lip_thk = 1.0;  

  // Port cut-out dimensions
  stc_1000_dim = [70, 
                  0,
                  28];
  pwr_out_dim = [22, 
                 0,
                 22];
  pwr_in_dim = [46.1, 
                0,
                27.5];
  probe_dim = [4, 
               0,
               2];
  // Adjust dimensions so port is below lid and "punches" through.
  function port_cutout(dim) = [dim[0] + (clr_off * 2), 
                               wall_thk + 2*xs,
                               dim[2] + clr_off + lip_thk + xs];

  // Center the object in view port, along x and y.
  translate([-(body_x/2), -(body_y/2), 0]) {
    difference() {
      // Case body
      union() {
        cube([body_x, body_y, (body_z - lip_thk)]);
        // case/lid lip.
        translate([lip_thk, lip_thk, lip_thk]) {
          cube([body_x-(2*lip_thk),
                body_y-(lip_thk+port_lip_thk),
                body_z-lip_thk]);
        }
      }
      
      // Extrude interior
      translate([wall_thk, wall_thk, wall_thk]) {
        cube([body_x - 2*wall_thk, //114
              body_y - 2*wall_thk, //156
              body_z]);
      }
      // STC-1000 hole
      translate([(body_x-stc_1000_dim[0])/2,
                 -xs, 
                 body_z - (stc_1000_dim[2]+lip_thk)
                 ]) {
        cube(port_cutout(stc_1000_dim));
      }

      // Pwr out hole
      translate([17, 
                 body_y-wall_thk-xs, 
                 body_z-(pwr_out_dim[2]+lip_thk)]) {
        cube(port_cutout(pwr_out_dim));
        // lip for pwr out
        translate([-port_lip_thk, 0, 0]) {
          cube([port_cutout(pwr_out_dim)[0] + 2*port_lip_thk,
                wall_thk-port_lip_thk+xs,
                port_cutout(pwr_out_dim)[2]]);
        }
      }
      // probe wire hole
      translate([45, 
                 body_y-wall_thk-xs, 
                 body_z-(probe_dim[2]+lip_thk) ]) {
        cube(port_cutout(probe_dim));
      }
      // Pwr in + switch hole
      translate([57, 
                 body_y-wall_thk-xs, 
                 body_z-(pwr_in_dim[2]+lip_thk) ]) {
        cube(port_cutout(pwr_in_dim));
        // 1 mm lip for in+switch.
        translate([0, 0, -port_lip_thk]) {
          cube([port_cutout(pwr_in_dim)[0], 
                wall_thk - port_lip_thk + xs, 
                port_lip_thk + xs]);
        }
      }       
    } // end of case's difference()
    // Lid mounting posts.
    captive_m4nut_post(x=wall_thk, 
                       y=wall_thk, 
                       z=wall_thk, 
                       h=body_z - wall_thk);
    captive_m4nut_post(x=body_x - wall_thk - 9.5, 
                       y=wall_thk, 
                       z=wall_thk, 
                       h=body_z - wall_thk);
    captive_m4nut_post(x=wall_thk, 
                       y=body_y - wall_thk - 9.5, 
                       z=wall_thk, 
                       h=body_z - wall_thk);
    captive_m4nut_post(x=body_x - wall_thk - 9.5, 
                       y=body_y - wall_thk - 9.5, 
                       z=wall_thk, 
                       h=body_z - wall_thk);
//    // Example of stand-alone post.
//    translate([112, 8, 3]) {
//      difference() {
//        cylinder(33.5, 4.75, 4.75);
//        cylinder(35, 2.75, 2.75);
//      }
//    }    

    // Supporting interior walls
    // back divider
    translate([52, body_y-32-wall_thk, 3]) {
      cube([3, 32, 33.5]);
    }
    // side flanges
    translate([wall_thk, 85, wall_thk]) {
      cube([15, wall_thk, body_z-wall_thk]);
    }
    translate([body_x-wall_thk-15, 85, wall_thk]) {
      cube([15, wall_thk, body_z-wall_thk]);
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
