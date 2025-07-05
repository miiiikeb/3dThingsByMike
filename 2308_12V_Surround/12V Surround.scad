include <../Library/BOLS2_230327/std.scad>
include <../Library/mbLib-0.1b.scad>


include <../Library/BOLS2_230327/screws.scad>


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

