xOS = 165;
yOS = 125;

screwR = 2.2;
cnrR = 7.5;
edgeChamfer = 1;
escDepth = 5;

snapR = 1;
snapOS = 0.3;
hSnapLen = 30;
hSnapOS = 65;

lidDepth = 25;
lidThickness = 3;
lidMargin = 0.2;
snapMargin = 0.1;
gripR = 4;
gripOS = -1;
gripZOS = 10;
gripRot = 10;

module corners(xOS,yOS,topR,baseR,depth = escDepth){
    for (x = [-xOS/2,xOS/2]){
        for (y = [-yOS/2,yOS/2]){
            translate([x,y,0]) cylinder(h = depth, r1 = baseR, r2 = topR, $fn = baseR * 15);
        }
    }
}

module bigVoid(depth=escDepth){
    module cornerChamfer(){
        for (x = [-xOS/2,xOS/2]){
            for (y = [-yOS/2,yOS/2]){
                translate([x,y,0]) rotate([0,0,45]) cube(size = [26,26,1000], center = true);
            }
        }
    } 
    linear_extrude(height = depth * 2){
        offset(8) offset(-8) projection(cut=true) difference(){
            hull() corners(xOS,yOS,0.01,0.01);
            cornerChamfer();
        }
    }
}

module snapRidges(snapR = snapR,depth=escDepth, zScale = 1){
    for (x = [-1,1]){
        edgeOS = x * (snapOS + xOS / 2 + cnrR);
        #hull() for (y = [-yOS/2,yOS/2]){
            translate([edgeOS,y,depth/2]) scale([1,1,zScale]) sphere(r = snapR,$fn = 8);
        }
    }
    for (y = [-1,1]){
        edgeOS = y * (snapOS + yOS / 2 + cnrR);
        for (hSOS = [-hSnapOS,0,hSnapOS]){
            #hull() for (x = [-hSnapLen/2,hSnapLen/2]){
                translate([x + hSOS,edgeOS,depth/2]) scale([1,1,zScale]) sphere(r = snapR,$fn = 8);
            }
        }
    }
}

module gripRidges(snapR = gripR,depth=lidDepth, zScale = 1.5){
    for (x = [-1,1]){
        edgeOS = x * (gripOS + xOS / 2 + cnrR);
        #hull() for (y = [-yOS/2,yOS/2]){
            translate([edgeOS,y,depth]) rotate([0,-x * gripRot,0]) scale([1,1,zScale]) sphere(r = gripR,$fn = 8);
        }
    }
}

module buildEscutcheon(){
    snapRidges();
    difference(){
        hull() corners(xOS,yOS,cnrR,cnrR + edgeChamfer,escDepth);
        corners(xOS,yOS,screwR,screwR);
        bigVoid();
    }
}


//buildEscutcheon();
translate([0,0,00]) rotate([0,180,0]) buildLid();


module buildLid(){
    difference(){
        union(){
            hull() corners(xOS,yOS,lidThickness + cnrR - ((lidDepth-escDepth + lidThickness)/escDepth)*edgeChamfer,cnrR + edgeChamfer + lidThickness,lidDepth + lidThickness);
            gripRidges(gripR,lidDepth - gripZOS,1.5);
        } 
        hull() corners(xOS,yOS,lidMargin + cnrR - ((lidDepth-escDepth)/escDepth)*edgeChamfer,lidMargin + cnrR + edgeChamfer,lidDepth);
        snapRidges(snapR + snapMargin, escDepth,1.5);
    }
}
    