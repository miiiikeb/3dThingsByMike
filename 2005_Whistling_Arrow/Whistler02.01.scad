include <mblib.scad>;

tipR = 11;
tipScale = [1,1,1.5];
baseScale = [1,1,2];
skin = 2;

holes = 5;
holeR = 2.5;
holeA = 45;
holeZOS = 0; 


shaftR = 4;
shaftTaperA = 5; //degrees (for a point)
taperLen = 20;
collarDepth = 5.35;
taperZOS = -(16 + collarDepth);
coneR = 7;


socketD = 22;

res = 2;

minkShape(showDoc = true);
module blank(){
    hull(){
        scale(tipScale) minkShape(bevel = tipR,type = 3,res = res);
        scale(baseScale) rotate([180,0,0]) minkShape(bevel = tipR,type = 3,res = res);
    }
}

module taper(shaftR = 4,skin = 0,taperLen = 16, taperA = 5, collarLen = 10){
    taperPoint = shaftR * tan(90 - shaftTaperA);
    cylinder(r = shaftR+skin, h = collarLen , $fn = 60); 
    translate([0,0,collarLen]) intersection(){
        cylinder(r1 = shaftR+skin, r2 = 0.0001+skin, h = taperPoint , $fn = 60);
        translate([0,0,taperLen/2]) cube(size = taperLen,center = true);
    }
}

module build(){
    difference(){
        minkowski(){
            blank();
            sphere(r = skin,$fn = 30);
        }
        blank();
        for (a = [0:360/holes:360]){
            rotate([0,holeA,a]) cylinder(r = holeR, h = 100,$fn = 30);
        }
        translate([0,0,-100]) cylinder(r = shaftR+skin, h = 100, $fn = 60);
        qCube(dims = [100,100,100], os = [0,0,-100 - socketD]);
    }

    translate([0,0,taperZOS]) difference(){
        taper(skin = skin);
        taper();
    }

    intersection(){
        hull(){
            intersection(){
                translate([0,0,taperZOS]) taper(skin = skin);
                translate([0,0,taperZOS + taperLen + collarDepth]) cube(size = [4 * shaftR,4 * shaftR,0.01],center = true);
            }
            translate([0,0,tipScale[2] * tipR]) cylinder(r = coneR, h = 0.01, $fn = 60);
        }
        blank();
    }
}

//difference(){
    build();
//    translate([0,200,0]) cube(size = 400, center = true);
//}