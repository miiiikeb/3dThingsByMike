

//include <BOSL2/screws.scad>
//include <BOSL2/std.scad>

width1 = 130;
width2 = 212; //210;
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

shockCordBlockZ = 10;

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

module shockCordBlockout(){
    for(mod = [-1,1]){
        yOS = width1/2 + minkR;
        translate([0,mod * (yOS + 100), 0]) cube(size = [800,200,2 * (shockCordBlockZ - minkR)], center = true);
        translate([0,mod * (yOS + minkR), shockCordBlockZ - minkR]) rotate([0,90,0]) cylinder(r = minkR, h = 800, $fn = 60, center = true);
    }
}

module screwSlotBlank(screwBodyLen){
    screwBodyR = 6;
    screwHoleR = 2.7;
//    screwBodyLen = 40;

    difference(){
        hull(){
            translate([0,0,screwBodyR]) rotate([90,0,0]) cylinder(r = screwBodyR, h = screwBodyLen, center = true);
            translate([0,0,thin/2]) cube(size = [6 * screwBodyR, screwBodyLen, thin], center = true);
        }
        translate([0,0,screwBodyR]) rotate([90,0,0]) cylinder(r = screwHoleR, h = screwBodyLen, center = true);
    }
}

module screwSlot1(topObj, bottomObj, OS, screwBodyLen = 40){
    translate(bottomObj[0]) rotate([0,-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,minkR - 0.5]) screwSlotBlank(screwBodyLen);
}

module screwSlot2(topObj, bottomObj, OS, screwBodyLen = 40){
    translate(bottomObj[0]) rotate([0,180-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,(minkR - 0.5)]) screwSlotBlank(screwBodyLen);
}

module shockCordGrab(){
    yOS = 30;
    
    for(pm = [-1,1]){
        translate([0, pm * yOS, 0]) screwSlot1(obj2,obj1,-8,20);
    }
}

module breatherPos1(){
    blockR = 5;
    //total width of the blockout
    blockY = 20;
    blockZ = 35;
    
    //translate([minkR / 2, 0,0]) cube(size = [minkR, blockY, blockZ], center = true);
    
    hull() difference(){
        union(){
            for(yOS = [-blockY/2 + minkR, blockY/2 - minkR]){
                translate([0,yOS,0]) cylinder(r = blockR, h = blockZ, $fn = 30, center = true);
            }
            translate([0,0,blockR]) cube(size = [0.01, blockY - 2 * blockR, blockZ], center = true);
        }
        translate([-500,0,0]) cube(size = 1000, center = true);
    }   
}

module breatherBlank(blockR = 5,zAdj = 0,neg = false){
    
    maxBridge = 5;
    overhangAngle = 40;
    
    difference(){
        minkowski(){
            translate([0,0,zAdj/2]) cube(size = [0.01, breatherBlockY, breatherBlockZ - zAdj], center = true);
            difference(){
                cylinder(r1 = blockR, r2 = 0, h = 2 * blockR, $fn = 30);
                translate([-500,0,0]) cube(size = 1000, center = true);
            }
        }
        if(neg == true){
            for(pm = [-1,1]){
                translate([0,0,-breatherBlockZ/2 + zAdj]) rotate([-pm * overhangAngle,0,0]) translate([0,pm * (50 + maxBridge/2),0]) cube(size = 100, center = true);
            }
        }
    }
}

breatherBlockY = 10;
breatherBlockZ = 35;
breatherROut = 5;
breatherRIn = 3;

module breatherPos(type = "breather"){
    if(type == "breather"){
        difference(){
            breatherBlank(breatherROut);
            breatherBlank(breatherRIn);
        }
    }
    if(type == "connectorBulkInside"){
        translate([-5,0,0]) scale([1,1,2]) sphere(r = 5, $fn = 18);
    }
    if(type == "connectorBulkOutside"){
        translate([-10,0,0]) scale([1,1,2]) sphere(r = 5, $fn = 18);
    }
}

module breatherNeg(type = "breather"){
    if(type == "breather"){
        hull(){
            breatherBlank(breatherRIn,7,true);
            translate([-10,0,0]) breatherBlank(breatherRIn,7,true);
        }
    }
}

module breatherPos1(topObj, bottomObj, OS, type = "breather"){
    translate(bottomObj[0]) rotate([0,-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,minkR - 0.5]) rotate([0,-90,0]) breatherPos(type);
}
module breatherNeg1(topObj, bottomObj, OS, type = "breather"){
    translate(bottomObj[0]) rotate([0,-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,minkR - 0.5]) rotate([0,-90,0]) breatherNeg(type);
}       

module breatherPos2(topObj, bottomObj, OS, type = "breather"){
    translate(bottomObj[0]) rotate([0,180-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,(minkR - 0.5)]) rotate([0,90,0]) rotate([0,0,180]) breatherPos(type);
}

module breatherNeg2(topObj, bottomObj, OS, type = "breather"){
    translate(bottomObj[0]) rotate([0,180-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,(minkR - 0.5)]) rotate([0,90,0]) rotate([0,0,180]) breatherNeg(type);
}

module breatherPos3(topObj, bottomObj, OS, type = "breather"){
    translate(bottomObj[0]) rotate([0,-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,minkR - 0.5]) rotate([180,-90,0]) breatherPos(type);
}
module breatherNeg3(topObj, bottomObj, OS, type = "breather"){
    translate(bottomObj[0]) rotate([0,-atan((topObj[0][2] - bottomObj[0][2]) / (topObj[0][0] - bottomObj[0][0])),0]) translate([-OS,0,minkR - 0.5]) rotate([180,-90,0]) breatherNeg(type);
}   

breatherYOS = [-45,-15,15,45];

breather1aYOS = breatherYOS;
breather1aZOS = [85];            

breather1bYOS = breatherYOS;
breather1bZOS = [85]; 

breather2aYOS = breatherYOS;
breather2aZOS = [-65]; 

breather3aYOS = breatherYOS;
breather3aZOS = [-85]; 


connectorBulk1aYOS = [-50,0,50];
connectorBulk1aZOS = [10];   

connectorBulk2aYOS = [-50,0,50];
connectorBulk2aZOS = [10]; 

module breatherTest(){
    breatherNeg();
    breatherPos();
}

//breatherTest();

module build(){
    difference(){
        minkowski(){
            internalBlockout();
            sphere(r = minkR,$fn = 30);
        }
        translate([0,0,-20]) cube(size = [800,800,40], center = true);
        internalBlockout();
        shockCordBlockout();
        
        //Breather Pos -- Hang on!!
//        #breatherPos2(obj3,obj2,-35);
        
        for(yOS = breather1aYOS){
            for(zOS = breather1aZOS){
                translate([0,yOS,0]) breatherNeg1(obj5,obj6,zOS);
            }
        }

        for(yOS = breather1bYOS){
            for(zOS = breather1bZOS){
                translate([0,yOS,0]) breatherNeg1(obj4,obj5,zOS);
            }
        }
        
        for(yOS = breather2aYOS){
            for(zOS = breather2aZOS){
                translate([0,yOS,0]) breatherNeg2(obj3,obj2,zOS);
            }
        }
        for(yOS = breather3aYOS){
            for(zOS = breather3aZOS){
                translate([0,yOS,0]) breatherNeg3(obj2,obj1,zOS);
            }
        }
    }
    
    for(yOS = breather1aYOS){
        for(zOS = breather1aZOS){
            translate([0,yOS,0]) breatherPos1(obj5,obj6,zOS);
        }
    }
    
    for(yOS = breather1bYOS){
        for(zOS = breather1bZOS){
            translate([0,yOS,0]) breatherPos1(obj4,obj5,zOS);
        }
    }

    for(yOS = breather2aYOS){
        for(zOS = breather2aZOS){
            translate([0,yOS,0]) breatherPos2(obj3,obj2,zOS);
        }
    }
    for(yOS = breather3aYOS){
        for(zOS = breather3aZOS){
            translate([0,yOS,0]) breatherPos3(obj2,obj1,zOS);
        }
    } 
    
    for(yOS = connectorBulk1aYOS){
        for(zOS = connectorBulk1aZOS){
            translate([0,yOS,0]) breatherPos1(obj4,obj5,zOS,"connectorBulkInside");
        }
    }
    #for(yOS = connectorBulk2aYOS){
        for(zOS = connectorBulk2aZOS){
            translate([0,yOS,0]) breatherPos3(obj3,obj2,zOS,"connectorBulkOutside");
        }
    }
    
    
    
    difference(){
        union(){
            screwSlot1(obj5,obj6,8); //Front Shock-cord loop
            shockCordGrab(); //Back Shock Cord loop
        }
        translate([0,0,-400]) cube(size = 800, center = true);
    }


    //screwSlot1(obj5,obj6,60);
    //screwSlot1(obj4,obj5,35);
    //screwSlot1(obj4,obj5,110);
    //screwSlot2(obj3,obj2,-35);
    //screwSlot2(obj3,obj2,-95);
    //screwSlot1(obj2,obj1,-55);
    
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

build();

//partBuild1();
//partBuild2();
//rotate([0,180,0]) partBuild3();
