
module pos(){
    os_r = 0.5;
    res = 3;         //this is the cut height-set to layer height for build
    pi = 3.14159265359;
    overprint = 0.5;

    tamper_ro = 26 - overprint - os_r;
    curve_h = 50;
    tamper_core_ri = os_r; //8.5 + overprint + os_r;
    
    base_h = 10;

    xg_min = 0.68058;
    xg_max = 3.34705;
    yg_max = 2.177254;



    cuts = (curve_h + base_h)/res;
    
    cut_h = res;
    base_cuts = round(base_h/cut_h);
    curve_cuts = round(curve_h/cut_h);
    //echo("cut height = ", cut_h);
    rotate_extrude(convexity = 10, $fn = 360) rotate([0,0,90]) offset(r=os_r){
        projection(){
            for(i=[0:cuts]){
                if(i<base_cuts){
                    //echo("base cut ", i);
                    translate([i*cut_h,0,0]){
                        xg= xg_min + i * (xg_max-xg_min)/cuts;
                        seg_base = tamper_core_ri;
                        seg_top = tamper_ro;
                        translate([0,seg_base,0]) cube(size=[cut_h,seg_top-seg_base,0.001],center=false);
                    }
                }
    
 
                else {
                    //echo("curve cut ", i);
                    translate([i*cut_h,0,0]){
                        xg= xg_min + (i - base_cuts) * (xg_max-xg_min)/curve_cuts;
                        seg_base = tamper_core_ri;
                        seg_top = (tamper_ro/yg_max)*(1.5+0.3*(sin(180*xg/pi)+2*sin(2.5*xg*180/pi)+1/(xg-3.5)));
                        //echo("seg_top = ", seg_top,", xg = ",xg);
                        translate([0,seg_base,0]) cube(size=[cut_h,seg_top-seg_base,0.001],center=false);
                    }
                }
            }
        }
    }
}

pos(); //uncomment to build
    