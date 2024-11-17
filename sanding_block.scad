
$fn=500;

radius = 254; // 10 inches

// Subtract 10 from desired width to account for the rounded corners since we use hull to do that
block_width = 79;

module sanding_block(height) {
    difference() {
            difference() {
               
                hull() {
                    translate([0, -radius + 50, 0]) {
                        cube([block_width, radius, height], center = true);
                    }
                    translate([block_width / 2 - 5, 45, 0]) {
                        cylinder(r=10, h=height, center = true);
                    }
                    translate([-block_width / 2 + 5, 45, 0]) {
                        cylinder(r=10, h=height, center = true);
                    }
                }
                translate([0, -radius, -1]) {
                    cylinder(r=radius, h=height + 3, center=true);
                }
            }   
        
        translate([block_width / 2 + 10, 25, -1]) {
            cylinder(r=block_width / 5, h=height + 3, center = true);
        }     
           
        translate([-block_width / 2 - 10, 25, -1]) {
            cylinder(r=block_width / 5, h=height + 3, center = true);
        }
        
    }
}

sanding_block(300);
