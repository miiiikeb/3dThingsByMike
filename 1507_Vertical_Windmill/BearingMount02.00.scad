bearing_d=22.7;     //bearing diameter
bearing_h=7.7;        //bearing height
end_depth = 16;     //thickness of the block
edge_h = 25;        //wall height at the ends
edge_w = 80;        //overall width
chamfer=1;          //Also the amount that the inner plug is recessed by.
body_width = 10; //The amount of body around the edge of the bearing.
bulge = 1;
screw_os = 30;
screw_d = 5;
screw_shaft_len=23;
screw_head_d=13;
shaft_d = 22.4;

body_depth = 80;
body_thickness = 2;
//mount_body();
//mount_blockouts();
rotate([90,0,0]) build_mount();
//mount_core(end_depth);
module build_everything(){
    build_spacer();
    translate([0,body_depth,0]) build_mount();
    mirror([0,1,0]) translate([0,body_depth,0]) build_mount();
}

module mount_core(mc_end_depth){
    hull(){
        translate([0,0,(bearing_d/2+body_width)]) rotate([90,0,0]) cylinder(d=bearing_d+2*body_width-4*chamfer, h=mc_end_depth, $fn=120, center = true);

        translate([0,0,edge_h/2]) cube(size=[edge_w,mc_end_depth,edge_h-4*chamfer],center=true);
        
    }
    translate([0,bulge,bearing_d/2 + body_width]) rotate([90,0,0]) cylinder(d=shaft_d+2*bulge,h=mc_end_depth+bulge,$fn=40,center=true);   
}
    

module mount_body(){
//    difference(){
        minkowski(){
            mount_core(end_depth-2*chamfer);
            sphere(r=chamfer, $fa=10);
//        }
//        translate([0,-end_depth/2-50,0]) cube(size=[100,100,200],center=true);     
    }
/*    intersection(){
        translate([0,-2,0]) mount_core(end_depth);
        translate([0,-end_depth,0]) cube(size=[100,end_depth,200],center=true);
    }*/
}

module mount_blockouts(){
    for (i=[-1,1]){
        translate([i*screw_os,0,0])  cylinder(d=screw_d,h=2*bearing_d,$fn=60);
        translate([i*screw_os,0,screw_shaft_len])  cylinder(d=screw_head_d,h=2*bearing_d,$fn=60);
        translate([0,i*(end_depth/2-bearing_h/2+chamfer),bearing_d/2 + body_width]) rotate([90,0,0]) cylinder(d=bearing_d,h=bearing_h+0.1,$fn=120,center=true);
            }

    translate([0,0,bearing_d/2 + body_width]) rotate([90,0,0]) cylinder(d=shaft_d,h=2*end_depth,$fn=40,center=true);   
}


module build_mount(){
    difference(){
        mount_body();
        mount_blockouts();
    }
}

module build_spacer(){
    difference(){
        minkowski(){
            mount_core(body_depth);
            sphere(r=chamfer, $fa=10);
        }
        mount_core(body_depth);
        for (i=[-1,1]){
            translate([0,i*(body_depth-0.2),0]) cube(size=[1000,body_depth,1000],center=true);
        }
    }
}
