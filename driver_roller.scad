$fn = 200; // Set the number of facets for smoother curves

length = 157;
end_diameter = 71;
center_diameter = 73;
shaft_diameter = 15.05;


difference() {
       
    crowned_cylinder();

    translate([0, 0, -2]) {
        cylinder(h = length + 4, r = shaft_diameter / 2); 
   }

    translate([0, 0, 6 + 3.55]) {
        rotate([90, 0, 0]) {
            cylinder(h = 400, r = 3.55);
        }
    }
       
    translate([0, 0, length - 6 - 3.55]) {
        rotate([90, 0, 0]) {
            cylinder(h = 400, r = 3.55);
        }
    }

}

module crowned_cylinder() {
    
    crown_size = 10;
    
    hull() {
       cylinder(h=length, d=end_diameter);
        
       // Center the crown vertically
       translate([0, 0, length / 2]) {
            rotate_extrude() {
                // Create an oblong circle and translate so its outermost point is the center diamater
                translate([center_diameter / 2 - crown_size / 2, 0, 0]) {
                    // Scale by 4 to get the oblong shape
                    scale([1, 4, 1]) {
                        // 10 is arbitrary. It controls how round the crown will be
                        circle(d=crown_size);
                    }
                }
            }
        }   
    }
}