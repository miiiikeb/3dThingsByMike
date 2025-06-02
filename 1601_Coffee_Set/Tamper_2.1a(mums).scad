runRes = 0.15;


module pos(res = 3){
    //res = 3;
    pi = 3.14159265359;
    overprint = 0.0;

    tamper_ro = 25;
    curve_h = 50;
    tamper_core_ri = 8.5;
    
    fillCore = true;  //set to true to fill in the core
    
    
    base_h = 10;

    xg_min = 0.68058;
    xg_max = 3.34705;
    yg_max = 2.177254;



    cuts = (curve_h + base_h)/res;
	rotateCuts = 360;
    
    cut_h = res;
    base_cuts = round(base_h/cut_h);
    curve_cuts = round(curve_h/cut_h);
	for(i=[0:cuts]){
		if(i == 0){
			difference(){
				cylinder(h = base_h, r = tamper_ro, $fn = rotateCuts);
				if(fillCore != true){
					cylinder(h = base_h, r = tamper_core_ri, $fn = rotateCuts);
				}
			}
        }
		
		if(i >= base_cuts){
			translate([0,0,i*cut_h]){
                xg= xg_min + (i - base_cuts) * (xg_max-xg_min)/curve_cuts;
                seg_base = tamper_core_ri;
                seg_top = (tamper_ro/yg_max)*(1.5+0.3*(sin(180*xg/pi)+2*sin(2.5*xg*180/pi)+1/(xg-3.5)));					
                
                difference(){
                    cylinder(h = cut_h, r = seg_top, $fn = rotateCuts);
                    if(fillCore != true){
                        cylinder(h = base_h, r = tamper_core_ri, $fn = rotateCuts);
                    }
                }	
            }
        }
	}

}

pos(res = runRes);

