taper_d = 41;       //outer diameter at the narrowest part of the cylinder taper (make it a bit smaller than the inner diameter of your pipe
taper_len = 30;     // length of the cylinder taper
cyl_len = 10;       // lenth of the non-tapered cylinder
cyl_d = 44;         // diamter of the cylinder (widest diameter of the taper)

wall_thickness = 4; // yep, wall thickness
mouth_width = 80;   // inner width of the vacuum mouth
mouth_height = 10;  // inner height of the vacuum mouth
mouth_angle = 30;   // angle to perpendicular to cut the vacuum mouth
mouth_len = 15;     // length of the vacuum mouth before the transition to the cylinder
transition_len=60;  // length of the transition to the cylinder

module blockout(){
    
    inner_cyl = cyl_d - wall_thickness;
    inner_taper = taper_d - wall_thickness;
    
    hull(){
        translate([0,0,mouth_len + transition_len]) cylinder(h=0.1,d=inner_cyl,$fa=3);
        translate([0,0,mouth_len-0.1]) cube(size=[mouth_width,mouth_height,0.1],center=true);
    }
    translate([0,0,mouth_len/2]) cube(size=[mouth_width,mouth_height,mouth_len],center=true);

    translate([0,0,mouth_len + transition_len]) cylinder(h=cyl_len,d=inner_cyl,center=false,$fa=3);
    
    translate([0,0,mouth_len + transition_len + cyl_len]) cylinder(h=taper_len,d1=inner_cyl,d2=inner_taper,center=false,$fa=3);
}

translate([0,0,mouth_len+transition_len+cyl_len+taper_len-1.5]) rotate([180,0,0])    difference(){
        minkowski(){
            blockout();
            cylinder(h=1,d=wall_thickness);
        }
        blockout();
        translate([0,0,mouth_len+transition_len+cyl_len+taper_len]) cube(size=[100,100,3],center=true);
        rotate([mouth_angle,0,0]) cube(size=[100,200,10],center=true);
    }
