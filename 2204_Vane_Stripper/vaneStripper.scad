include <../0000_StdLibraries/mbLib.scad>
//include <mbLib.scad>  //Uncomment to generate as standalone (not from github repo)

res = 1;
lil = 0.001;
big = 1000;

bevel = 2;

blockDims = [50,40,20];
blockOS = [0,-5,0];

guardDims = [120,8,7];
guardOS = [-25,blockDims[1]/2 - guardDims[1]/2 + blockOS[1],0];

shaftR = 5.8/2;

bladeDims = [big,0.6,big];
bladeOS = [0,10,shaftR];
bladeZOS = -0.3;
bladeRot = [75,0,0];

chuteDims = [3 * shaftR,big,big];
chuteOS = bladeOS + [0,0,0];
chuteRot = [-15,0,0];

screwXOS = 18;
screwOS = [0,-18,-7];
screwDims = [3.5, 25,6, 5];

nutDia = 5.8;
nutH = 9;

module pos(){
    minkowski(){
        //qCube(dims = guardDims, os = guardOS, rot = [0,0,0]);
        qCube(dims = blockDims, os = blockOS, rot = [0,0,0]);
        minkShape(bevel=bevel,type=4,res=res);
    }
    minkowski(){
        qCube(dims = guardDims, os = guardOS, rot = [0,0,0]);
        //qCube(dims = blockDims, os = blockOS, rot = [0,0,0]);
        minkShape(bevel=bevel,type=4,res=res);
    }
}

module neg(){
    hull(){
        qCyl(rad=shaftR,hei=big ,res=res,os=[0,-big/2,0],rot=[-90,0,0]);
        qCube(dims = [4 * shaftR,big,lil], os = [0,0,-bevel], rot = [0,0,0]);
    }
    qCube(dims = [2 * shaftR,big,big], os = [0,big/2 + 8,0], rot = [0,0,0]);
    translate([0,0,bladeZOS]) qCube(dims = bladeDims, os = bladeOS, rot = bladeRot);
    qCube(dims = chuteDims, os = chuteOS, rot = chuteRot);
    
    for (i = [-1,1]){
        #screw(screwDims, type = "nil",os = screwOS + [i * screwXOS,0,0], rot = [0,0,0], res = 0.25 * res);
        #nut(nutDia, nut_height = nutH,os = screwOS + [i * screwXOS,0,0], rot = [0,0,30]);
    }
        
}

rotate([-90,0,0]) difference(){
    pos();
    neg();
}

