include <../0000_StdLibraries/BOSL2/std.scad>
include <../0000_StdLibraries/BOSL2/hinges.scad>

depth = 5;

screwBorder = 5;

usbD = 28;
usbBorder = 8;
usbYOS = 0.5;

usbNutD = 40;

screwD = 4;
screwOS = 30;
bevel = 2;
minkR = 2;
minkRes = 1;
minA = 0.1;

module minkShape(bevel=1,type=0,res=0.25,showDoc = false){
	
	if (showDoc == true){
		echo(
			"\nminkShape(bevel=1,type=0,res=0.25,showDoc = false)\n
			\n***minkShape TYPE List*** \n
            0: pyramid (scaled and with 45deg rotation)\n
            1: vertical cone\n
            2: back-to-back horizontal cones\n
            3: hemisphere\n
            4: sphere\n
			5: half cylinder\n
            6: back-to-back vertical cones.\n
			7: vertical cylinder (z = 0.0001).\n");
		
	}
    if (showDoc == false){
		if (type == 0){
			scale([0.707,0.707,0.707]) rotate([0,0,45]) hull(){
					cube(size = [bevel * 2, bevel * 2, 0.0001], center = true);
					translate([0,0,bevel]) cube(size = 0.0001, center = true);
			}
		}
		   
		else if (type == 1){
			cylinder(r1 = bevel, r2 = 0.0001, h = bevel,$fn = res * 32);
		}
		else if (type == 2){
			difference(){
				rotate([90,0,0]) union(){
					cylinder(r1 = bevel, r2 = 0.0001, h = bevel, $fn = res * 32);
					mirror ([0,0,1]) cylinder(r1 = bevel, r2 = 0.0001, h = bevel,$fn = res * 32);
				}
				translate([0,0,-10000/2]) cube(size = 10000, center = true);
			}
		}
		else if (type == 3){
			difference(){
					sphere(r = bevel, $fn = res * 32);
					translate([0,0,-500]) cube(size = 1000, center = true);
			}
		}
		else if (type == 4){
			sphere(r = bevel, $fn = res * 32);
		}
		else if (type == 5){
			difference(){
			    rotate([0,90,0]) cylinder(r = bevel, $fn = bevel * 64 * res);
				translate([0,0,-500]) cube(size = 1000, center = true);
		    }
		}
		else if (type == 6){
			cylinder(r1 = bevel, r2 = 0.0001, h = bevel, $fn = res * 32);
			rotate([180,0,0]) cylinder(r1 = bevel, r2 = 0.0001, h = bevel, $fn = res * 32);
		}
        else if (type == 7){
			cylinder(r1 = bevel, r2 = bevel, h = 0.0001, $fn = res * 32);
			rotate([180,0,0]) cylinder(r1 = bevel, r2 = 0.0001, h = bevel, $fn = res * 32);
		}
        else if (type == 8){
			cylinder(r1 = bevel, r2 = bevel, h = 0.0001, $fn = res * 32);
            
		}
    }
	

}

module pos(){


    hull(){
        for(xos = [-screwOS,screwOS]){
            translate([xos,0,0]) cyl(r1 = screwD/2 + screwBorder + bevel, r2 = screwD/2 + screwBorder, h = depth - minkR, $fn = 120, anchor = BOTTOM);
        }
        cyl(r1 = usbD/2 + usbBorder + bevel, r2 = usbD/2 + usbBorder, h = depth - minkR, $fn = 180, anchor = BOTTOM);
    }

}

module neg(){
    hull() for(yos = [-usbYOS,usbYOS]){
            translate([0,yos,0]) cyl(r = usbD/2, h = 100, $fn = 60,center = true);
        }
    
    
    translate([0,0,depth]) for(xos = [-screwOS,screwOS]){
            translate([xos,0,0]) screw_hole("M4",head="pan",length = 20,$fn = 32,anchor = TOP);
    }
}

difference(){
    minkowski(){
        pos();
        minkShape(bevel=minkR,type=3,res=minkRes);
    }
    neg();
}

