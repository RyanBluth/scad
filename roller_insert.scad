
$fa = 2;
$fn = 500;

indented_diameter = 57.4;
indented_radius = indented_diameter / 2;
section_height = 35;
peg_radius = 3;
smooth_diameter = 65.95;
smooth_radius = smooth_diameter / 2;
shaft_hole_radius = 11.5;

difference() {

    union() {
        
        // Smooth piece
        cylinder(h = section_height, r = smooth_radius);
        
      
        translate([0, 0, section_height]) {   
            // Indented piece
            difference() {
                cylinder(h = section_height, r = indented_radius);
                for (i = [0, 120, 240]) {
                    x = indented_radius * cos(i);
                    y = indented_radius * sin(i);
                    
                    // -1 and +2 so we don't have z-fighting
                    translate([x, y, -1]) {
                        cylinder(h = section_height + 2, r = peg_radius);
                    }
                }
            }
        }

    }
       
    translate([0, 0, -0.5]) {
        cylinder(h=section_height * 2.1, r = shaft_hole_radius);
    }

}