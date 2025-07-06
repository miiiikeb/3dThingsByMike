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
difference(){
    minkowski(){
        blank();
        sphere(r = skin);
    }
    blank();
    for (a = [0:360/holes:360]){
        rotate([0,holeA,a]) cylinder(r = holeR, h = 100,$fn = 30);
    }
    rotate([180,0,0]) cylinder(r = shaftR, h = 200 , $fn = 60);
    qCube(dims = [100,100,100], os = [0,0,-100 - socketD]);
}


translate([0,0,-socketD]) difference(){
    cylinder(r = shaftR + skin, h = socketD + skin, $fn = 60);
    cylinder(r = shaftR, h = socketD , $fn = 60);
}

intersection(){
    blank();
    cylinder(r1 = shaftR + skin, r2 = coneR, h = tipScale[2] * tipR, $fn = 60);
}
    

