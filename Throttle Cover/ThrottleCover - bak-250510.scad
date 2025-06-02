

include <BOSL2/screws.scad>
include <BOSL2/std.scad>

width1 = 130;
width2 = 210;
thin = 0.001;

minkR = 5;

obj1 = [[0, 0, 0], thin, width1];
obj2 = [[20, 0, 120], thin, width1];
obj3 = [[0, 0, 245], thin, width1];
obj4 = [[60, 0, 245], thin, width1];
obj5 = [[153, 0, 120], thin, width1];
obj6 = [[168,0, 0], thin, width1];

obj7 = [[60, 0, 0], thin, width2];
obj8 = [[0, 0, 245], thin, width2];
obj9 = [[60, 0, 245], thin, width2];
obj10 = [[150, 0, 0], thin, width2];

module quickHull(objectList){
    hull(){
        for (o = objectList){
            translate(o[0]) cube(size = [o[1], o[2] ,o[1]],center = true);
        }
    }
}

module internalBlockout(){
    quickHull([obj1, obj2, obj5, obj6]);
    quickHull([obj2, obj3, obj4, obj5]);
    quickHull([obj7, obj8, obj9, obj10]);
}

module screwSlotBlank(){
    screwBodyR = 6;
    screwHoleR = 2.7;
    screwBodyLen = 40;

    difference(){
        hull(){
            translate([0,0,screwBodyR]) rotate([90,0,0]) cylinder(r = screwBodyR, h = screwBodyLen, center = true);
            translate([0,0,thin/2]) cube(size = [6 * screwBodyR, screwBodyLen, thin], center = true);
        }
        translate([0,0,screwBodyR]) rotate([90,0,0]) cylinder(r = screwHoleR, h = screwBodyLen, center = true);
    }
}

module screwSlot1(topObj, bottomObj, OS){
    translate(bottomObj[0]) rotate([0,-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,minkR - 0.5]) screwSlotBlank();
}



module screwSlot2(topObj, bottomObj, OS){
    translate(bottomObj[0]) rotate([0,180-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,(minkR - 0.5)]) screwSlotBlank();
}


module build(){
    difference(){
        minkowski(){
            internalBlockout();
            sphere(r = minkR,$fn = 30);
        }
        translate([0,0,-20]) cube(size = [800,800,40], center = true);
        internalBlockout();
    }
    screwSlot1(obj5,obj6,60);
    screwSlot1(obj4,obj5,35);
    screwSlot1(obj4,obj5,110);
    screwSlot2(obj3,obj2,-35);
    screwSlot2(obj3,obj2,-95);
    screwSlot1(obj2,obj1,-55);
}


module partBuild1(){
    slice = -15;
    difference(){
        build();
        translate([0,400 + slice,0]) cube(size = 800, center = true);   
        translate([0,0,380]) cube(size = [800,800,400], center = true);
    }
}

module partBuild2(){
    slice = -15;
    difference(){
        build();
        translate([0,- (400 + slice),0]) cube(size = 800, center = true);   
        translate([0,0,380]) cube(size = [800,800,400], center = true);
    }
}

module partBuild3(){
    slice = -15;
    difference(){
        build();
        translate([0,400 + slice,0]) cube(size = 800, center = true);   
        //#translate([0,0,380]) cube(size = [800,800,400], center = true);
        translate([0,0,-20]) cube(size = [800,800,400], center = true);
    }
}

//partBuild1();
//partBuild2();
rotate([0,180,0]) partBuild3();
