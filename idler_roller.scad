$fn = 100;

roller_diameter = 71.5;
roller_radius = roller_diameter / 2.0;
roller_height = 156;

bearing_inset_depth = 10.5;
bearing_inset_diameter = 31.9;
bearing_inset_radius = bearing_inset_diameter / 2.0;

center_hole_diameter = 22;
center_hole_radius = center_hole_diameter / 2.0;

difference() {
    cylinder(h  = roller_height, r = roller_radius);
    
    translate([0, 0, roller_height - bearing_inset_depth + 0.05]) {
        bearing_inset();
    }
    
    translate([0, 0, bearing_inset_depth - 0.05]) {
            rotate([180, 0, 0]) {
            bearing_inset();
        }
    }
    
    cylinder(h = roller_height, r = center_hole_radius);
}   

module bearing_inset() {
    chamfer_height = 0.5;
    
    
    union() {
        cylinder(h = bearing_inset_depth - 0.01, r = bearing_inset_radius);
        
        // Chamfer
        //translate([0, 0, bearing_inset_depth - chamfer_height - 0.01]) {
        //    cylinder(chamfer_height + 0.01, bearing_inset_radius, bearing_inset_radius * 1.2);  
        //}  
    }
    
}