runRes = 0.15;


module pos(res = 3){
    os_r = 0.5; //offset radius (currently disabled)
    //res = 3;
    pi = 3.14159265359;
    overprint = 0.0;

    tamper_ro = 35 - overprint - os_r;
    curve_h = 50;
    tamper_core_ri = 8.5 + overprint + os_r;
    
    base_h = 10;

    xg_min = 0.68058;
    xg_max = 3.34705;
    yg_max = 2.177254;



    cuts = (curve_h + base_h)/res;
    
    cut_h = res;
    base_cuts = round(base_h/cut_h);
    curve_cuts = round(curve_h/cut_h);
    //echo("cut height = ", cut_h);
    //rotate_extrude(convexity = 10, $fn = 360) rotate([0,0,90]) offset(r=os_r){
    rotate_extrude(convexity = 10, $fn = 360) rotate([0,0,90]){
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

module spiralMask(){
    spiralR = 35;
    armCount = 9;
    maskH = 100;
    res = 0.2;

    armA = 15;
    edgeThickness = 0.0;
    
    for (a = [0:armCount - 1]){
        rotate([0,0,a * 360/armCount]) difference(){
            translate([spiralR + 0.01,0,0]) cylinder(h = maskH, r = spiralR, $fn = res * 360);
            translate([-0.01,0,-0.01]) cube(size = [3 * spiralR, 2 * spiralR, 2 * maskH]);
            rotate([0,0,armA])translate([spiralR - edgeThickness + 0.01,0,0]) cylinder(h = maskH, r = spiralR - edgeThickness, $fn = res * 360);
            
        }
    }
}

module flash(){
    //#translate([0,0,22]) rotate([0,10,0]) cube(size = [100,100,5], center = true);
    //#translate([0,0,32]) rotate([0,10,0]) cube(size = [100,100,5], center = true);
    //#translate([0,0,42]) rotate([0,10,0]) cube(size = [100,100,5], center = true);
}

color1 = true;
color2 = false;

if(color1 == true){
    color("orange") difference(){
        pos(res = runRes);
        flash();
    }
}

if(color2 == true){
    color("blue") intersection(){
        pos(res = runRes);
        flash();
    }
}

