include<mbLib.scad>;

baseDims = [90,25,3];
baseBev = 1;

cornerRad = 2;
supportX = 8;
supportZ = baseDims[1]/2 - baseDims[2];

screwOS = 25;
screwZOS = baseDims[2]/2;
screwR = 1.5;

arrowGap = 11;
retainerBlockDims = [2, (baseDims[1] - arrowGap) / 2, 18];
retainerBlockOS = baseDims[0]/2 + retainerBlockDims[0]/2 - baseBev * 1.5;


endBlockDims = [6,baseDims[1],retainerBlockDims[2]];
endBlockOS = retainerBlockOS + endBlockDims[0]/2;

res = 02;
lil = 0.001;

module support(){
    translate([0,-baseBev,baseDims[2] - baseBev]) hull(){
        qCyl(rad = cornerRad, hei = supportX, res = res, rot = [0,90,0], os = [-supportX/2,baseDims[1]/2-cornerRad,supportZ - cornerRad]);
        translate([-supportX/2,-(supportZ+cornerRad) + baseDims[1]/2,0,]) cube(size = [supportX,supportZ+cornerRad,lil]);
    }
}

minkowski(){
    for (i = [0,1]){
        for (xOS = [-1,1]){
            translate([xOS * (baseDims[0]/2-supportX/2-baseBev),0,0]) mirror([0,i,0]) support();
        }
    }
    rotate([0,0,90]) minkShape(type = 2, bevel = baseBev, res = res);
}

//Main Base
difference(){
    base(dims = baseDims, bevel = baseBev);
    for (xOS = [-1,1]){
        translate([xOS * screwOS, 0,screwZOS]) cylinder(r1 = screwR, r2 = screwR + baseDims[2]/2, h = baseDims[2]/2, $fn = 60);
        translate([xOS * screwOS, 0,-lil]) cylinder(r = screwR, h = baseDims[2] + lil, $fn = 60);
    }
}
translate([baseDims[0]/2,0,0]) base(dims = [endBlockDims[0], baseDims[1], baseDims[2]], bevel = baseBev);

//End Block
minkowski(){
    translate([endBlockOS,0,0]) qCube(dims = endBlockDims - 2 * [baseBev,baseBev,0] );
    difference(){
        rotate([0,90,0]) minkShape(type = 1, res = 1, bevel = baseBev);
        qCube(dims = [100,100,100], os = [0,0,-100]);
    }
}

//Retainer Block
for (yOS = [-1,1]){
    minkowski(){
        translate([retainerBlockOS,yOS * (baseDims[1]/2 - retainerBlockDims[1]/2),0]) qCube(dims = retainerBlockDims - [baseBev, 2 * baseBev,0] );
        difference(){
            rotate([0,-90,0]) minkShape(type = 1, res = 1, bevel = baseBev);
            qCube(dims = [100,100,100], os = [0,0,-100]);
        }
    }
}

