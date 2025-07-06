include <../0000_StdLibraries/mbLib.scad>;

//Parameter Set 03
tipR = 8.5;
tipScale = [1,1,1.5 * 11/tipR];
baseScale = [1,1,2.5 * 11/tipR];
skin = 1.7;

holes = 5;
holeR = 2.5;
holeA = 45;
holeZOS = 0; 


shaftR = 4;
shaftTaperA = 5; //degrees (for a point)
taperLen = 22;
collarDepth = 5.35;
taperZOS = -(20 + collarDepth);
coneR = 7;


socketD = 22;

res = 3;


//Program Version 04a
module blank(grow = 0){
    tipScale_ = [tipScale[0] + grow/tipR,tipScale[1] + grow/tipR,tipScale[2] + grow/tipR];
    baseScale_ = [baseScale[0] + grow/tipR,baseScale[1] + grow/tipR,baseScale[2] + grow/tipR];
    difference(){
        scale(tipScale_) sphere(r = tipR, $fn = res * 32);
        translate([0,0,-500]) cube(size = 1000, center = true);
    }
        difference(){
        scale(baseScale_) sphere(r = tipR, $fn = res * 32);
        translate([0,0,500]) cube(size = 1000, center = true);
    }
}


module taper(shaftR = 4,skin = 0,taperLen = 16, taperA = 5, collarLen = 10){
    taperPoint = shaftR * tan(90 - shaftTaperA);
    cylinder(r = shaftR+skin, h = collarLen , $fn = res * 32); 
    translate([0,0,collarLen]) intersection(){
        cylinder(r1 = shaftR+skin, r2 = 0.0001+skin, h = taperPoint , $fn = res * 32);
        translate([0,0,taperLen/2]) cube(size = taperLen,center = true);
    }
}

module shell(){
    difference(){
        blank(grow = skin);
        blank();    
    }
}

module negs(){
    for (a = [0:360/holes:360]){
        rotate([0,holeA,a]) cylinder(r = holeR, h = 100,$fn = 30);
    }
    translate([0,0,-100]) cylinder(r = shaftR+skin, h = 100, $fn = res * 32);
    qCube(dims = [100,100,100], os = [0,0,-100 + taperZOS]);
}

buildShell = true;
buildTaper = true;
buildHead = true;
crossSection = false;
buildMe = true;



module build(){
    if (buildShell == true){
        difference(){
            shell();
            negs();
        }
    }

    //Tapper and collar
    if (buildTaper == true){
        intersection(){
            translate([0,0,taperZOS]) difference(){
                taper(shaftR = shaftR,skin = skin,taperLen = taperLen, taperA = shaftTaperA, collarLen = collarDepth);
                taper(shaftR = shaftR,skin = 0,taperLen = taperLen, taperA = shaftTaperA, collarLen = collarDepth);
            }
            blank(grow = skin);
        }
    }

    if (buildHead == true){
        intersection(){
            hull(){
                intersection(){
                    translate([0,0,taperZOS]) taper(shaftR = shaftR,skin = skin,taperLen = taperLen, taperA = shaftTaperA, collarLen = collarDepth);
                    #translate([0,0,taperZOS + taperLen + collarDepth]) cube(size = [4 * shaftR,4 * shaftR,0.01],center = true);
                }
                translate([0,0,tipScale[2] * tipR]) cylinder(r = coneR, h = 0.01, $fn = 60);
            }
            blank();
        }
    }
}

if (crossSection == true){
    difference(){
        build();
        
        translate([0,200,0]) cube(size = 400, center = true);
    }
}
else{
    build();
}