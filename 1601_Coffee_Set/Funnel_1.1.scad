
module pos(){
    overprint = 0.5;
    min_wall = 1.5;

    overhang_h = 2;
    overhang_ri = 39.5 + overprint;
    straight_tube_h = 10;
    straight_tube_ri = 35.5;

    curve_tube_h = 30;
    curve_rad_delta = 15;
    curve_slices = 25;
    curve_max_a = 90;
    curve_factor = 3;
    xg_min = 1;
    xg_max = 6;

    cuts = 400;
    os_r = 0.5;
    
    cut_h = (overhang_h + straight_tube_h + curve_tube_h)/cuts;
    oh_cuts = round(overhang_h/cut_h);
    st_cuts = round((curve_factor-xg_min)/(xg_max)*(overhang_h + straight_tube_h + curve_tube_h)/(cut_h));   
    curve_cuts = round(curve_tube_h/cut_h);
    
    rotate_extrude(convexity = 10, $fn = 360) rotate([0,0,90]) offset(r=0.5){
        projection(){
            for(i=[0:cuts]){
                if(i<=oh_cuts){
                    translate([i*(cut_h),0,0]){
                        xg= xg_min + i * (xg_max-xg_min)/cuts;
                        seg_base = overhang_ri+os_r;
                        seg_top = straight_tube_ri + curve_rad_delta * (xg/curve_factor-1)*(xg/curve_factor-1) +  os_r + 0.5;
                        translate([0,seg_base,0]) cube(size=[cut_h,seg_top-seg_base,0.001]);
                    }
                }
                else if(i<=oh_cuts+st_cuts){
                    translate([i*cut_h,0,0]){
                        xg= xg_min + i * (xg_max-xg_min)/cuts;
                        seg_base = straight_tube_ri + os_r;
                        seg_top = straight_tube_ri + curve_rad_delta * (xg/curve_factor-1)*(xg/curve_factor-1) + os_r + 0.5;
                        translate([0,seg_base,0]) cube(size=[cut_h,seg_top-seg_base,0.001]);
                    }
                }
                else {
                    translate([i*cut_h,0,0]){
                        xg= xg_min + i * (xg_max-xg_min)/cuts;
                        seg_base = straight_tube_ri + curve_rad_delta * (xg/curve_factor-1)*(xg/curve_factor-1)+os_r;
                        seg_top = seg_base + 0.5;
                        translate([0,seg_base,0]) cube(size=[cut_h,seg_top-seg_base,0.001]);
                    }
                }
            }
        }
    }
}

translate([0,0,3]) rotate([180,0,0]) pos();
    