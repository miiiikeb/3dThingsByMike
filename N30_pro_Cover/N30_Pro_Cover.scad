include <../StdLibraries/BOSL2/std.scad>
include <../StdLibraries/BOSL2/hinges.scad>

bigR = 32.2;
innerR = 24.2;
end2end = 132;
bodyZ = 15.4;
buttonZ = 18;
thumbStickZ = 21.5;

magnetR = 2.6;
magnetZ = 1.6;
magnetZgap = 0.4;
magnetWall = 1;

res = 1;       //Set to 1 for full res

hingeLen = end2end - 2 * bigR - 5;
wallThickness = 2;
minkR = 1;

module minkShape(){
    cylinder(h = minkR, r1 = minkR, r2 = 0, $fn = res * 30);
    translate([0,0,-minkR]) cylinder(h = minkR, r1 = 0, r2 = minkR, $fn = res * 30);
}

module pos(){
    for(i = [-1,1]){
        translate([i * (end2end/2 - bigR),0,0]) cylinder(h = thumbStickZ + 2 * wallThickness - 2 * minkR, r = bigR + wallThickness - minkR, $fn = res *  240, center = true);
    }
    cube(size = [end2end - 2 * bigR, 2 * (bigR + wallThickness) - 2 * minkR, thumbStickZ + 2 * wallThickness - 2 * minkR], center = true);
}

module neg(){
    for(i = [-1,1]){
        translate([i * (end2end/2 - bigR),0,0]) cylinder(h = thumbStickZ, r = innerR, $fn = res *  240, center = true);
        translate([i * (end2end/2 - bigR),0,-thumbStickZ/2]) cylinder(h = bodyZ, r = bigR, $fn = res *  240, center = false);
    }
    cube(size = [end2end - 2 * bigR, 2 * (innerR), thumbStickZ], center = true);
    translate([0,0,bodyZ/2 - thumbStickZ/2]) cube(size = [end2end - 2 * bigR, 2 * (bigR), bodyZ], center = true);    
    magnetBulge(wall = 0, gap = magnetZgap, height = magnetZ);
}    

module makeWithMink(){
    minkowski(){
        hull(){
            pos();
            magnetBulge(wall = wallThickness - minkR, gap = magnetZgap, height = magnetZ);
        }
        minkShape();
    }
    grabbers();
}

module magnetBulge(wall = 0, gap = 0, height = magnetZ){
    for(i = [-1,1]){
        for(a = [-45,45]){
            translate([i * (end2end/2 - bigR), 0,0]) rotate([0,0,a]) translate([i * ( bigR + magnetR + magnetWall), 0,0])   cylinder(h = 2 * height + gap, r = magnetR + wall, $fn = res * 60, center = true);
        }
    }
}

module hingeMeBase(){
    translate([0,bigR + wallThickness - 0.3, 0]) rotate([90,0,180]) knuckle_hinge(length=hingeLen, segs=13, offset=3, in_place = true, arm_height=1, round_bot=1, $fn = 24);
}

module hingeMeTop(){
        translate([0,bigR + wallThickness - 0.3, 0]) rotate([-90,0,0]) knuckle_hinge(length=hingeLen, segs=13, offset=3, in_place=true, arm_height=1, round_bot=1, $fn = 24, inner=true);
}

module makeTop(){
    difference(){
        makeWithMink();
        neg();
        translate([0,0,-500]) cube(size = 1000, center = true);
    }
    hingeMeTop();
}

module makeBase(){
    difference(){
        makeWithMink();
        neg();
        translate([0,0,500]) cube(size = 1000, center = true);
    }
    hingeMeBase();
}

module grabbers(){
    for(i = [-1,1]){
        translate([0,-bigR - wallThickness + 0.3, i * (-6)]) rotate([90,0,0]) hull(){
            cube(size = [20,6,0.01], center = true);
            translate([0,0,2]) cube(size = [16,2,0.01], center = true);
        }
    }
}



makeBase();
translate([0,2 * (3 + bigR + wallThickness - 0.3), 0]) rotate([180,0,0]) makeTop();

