xOS = 165;
yOS = 125;

screwR = 2.2;
cnrR = 7.5;
edgeChamfer = 1;
depth = 5;

snapR = 1;
snapOS = 0.3;
hSnapLen = 30;
hSnapOS = 65;

module corners(xOS,yOS,topR,baseR){

    for (x = [-xOS/2,xOS/2]){
        for (y = [-yOS/2,yOS/2]){
            translate([x,y,0]) cylinder(h = depth, r1 = baseR, r2 = topR, $fn = baseR * 15);
        }
    }
}

module bigVoid(){
    
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

module build(){
    difference(){
        hull() corners(xOS,yOS,cnrR,cnrR + edgeChamfer);
        corners(xOS,yOS,screwR,screwR);
        bigVoid();
    }
}

build();

for (x = [-1,1]){
    edgeOS = x * (snapOS + xOS / 2 + cnrR);
    #hull() for (y = [-yOS/2,yOS/2]){
        translate([edgeOS,y,depth/2]) sphere(r = snapR,$fn = 8);
    }
}

for (y = [-1,1]){
    edgeOS = y * (snapOS + yOS / 2 + cnrR);
    for (hSOS = [-hSnapOS,0,hSnapOS]){
        #hull() for (x = [-hSnapLen/2,hSnapLen/2]){
            translate([x + hSOS,edgeOS,depth/2]) sphere(r = snapR,$fn = 8);
        }
    }
}