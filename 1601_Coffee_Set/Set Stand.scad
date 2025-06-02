
funnelOuterR = 63.6 / 2;      //CHECK THESE BEFORE PRINTING!!!!
funnelInnerR = 53 / 2;    //CHECK THESE BEFORE PRINTING!!!!
coreR = 5.5;            //CHECK THESE BEFORE PRINTING!!!!


baseHeight = 2;   //Needs to be greater than 2 x minkR
wallThickness = 5;
wallHeight = 5;
standHeight = 20;

res = 30;   //240 for a clean build (5 hours rendering time)

minkR = 1;
clearance = 0.5;

// format is: [cylinder height, cylinder radius]
cylDims = [
    [5, funnelOuterR - minkR],
    [20, funnelInnerR - minkR - clearance]
    ];

module make(){
    difference(){
        translate([0,0,minkR]) cylinder(h = baseHeight + wallHeight - 2 * minkR, r = funnelOuterR + wallThickness + clearance - minkR, $fn = res);
        #translate([0,0,baseHeight - minkR]) cylinder(h = 200, r = funnelOuterR + clearance + minkR, $fn = res);
    }
    difference(){
        translate([0,0,minkR]) cylinder(h = baseHeight + standHeight - 2 * minkR, r = funnelInnerR - clearance - minkR, $fn = res);
        translate([0,0,0]) cylinder(h = 200, r = coreR + minkR, $fn = res);
    }

}

module addBase(){
    cylinder(h = minkR, r1 = funnelOuterR + wallThickness + clearance - minkR, r2 = funnelOuterR + wallThickness + clearance);
    translate([0,0,minkR]) cylinder(h = baseHeight - minkR, r = funnelOuterR + wallThickness + clearance);
}
     
module makeWithMink(){
    minkowski(){
        make();
        minkShape();
    }
}

module minkShape(){
    rotate([180,0,0]) difference(){
        sphere(r = minkR, $fn = res / 5);
        translate([0,0,100]) cube(size = 200,center = true);
    }
}

//minkShape();

makeWithMink();
addBase();