include<mbLib.scad>;

res = 1;
lil = 0.001;
big = 1000;


plateDims = [5,30,35];
bevel = 1;

restR = 0.5;
restH = plateDims[0];
restDims = [plateDims[0],5,0.001];
restOS = [0,0,plateDims[2] - 10]; 
throatW = 6;
throatH = restOS[2] + 3; 

arrowPosTweaker = -3; //Tweak this to get the arrow alignment right

//BB Plate is 5.0mm

bbFrameW = 5.1;

gripDims = [15,14,lil];
gripOS = [gripDims[0]/2,0,plateDims[2]];

gripR = 6/2;
gripH = gripDims[0];
gripOSZ = plateDims[2] + gripR - 12;

frameBlock1Dims = [30,30,lil];
frameBlock1OS = [frameBlock1Dims[0]/2 + plateDims[0] + bbFrameW, frameBlock1Dims[1]/2 + gripDims[1]/2,plateDims[2]];
frameBlock2Dims = [30,30,lil];
frameBlock2OS = [frameBlock2Dims[0]/2 + plateDims[0] + bbFrameW, frameBlock2Dims[1]/2 + gripDims[1] + 1,plateDims[2] - 25];
frameBlock3Dims = [30,30,30];
frameBlock3OS = [frameBlock3Dims[0]/2 + plateDims[0] + bbFrameW + 2.5, frameBlock3Dims[1]/2 + throatW/2, throatH + arrowPosTweaker];

screwYOS = 9;
screwOS = [0,0,0];
screwDims = [3.5, 12,6, 5];

nutDia = 5.8;
nutH = 2;

module pos(){

    qCube(dims = plateDims, os = [plateDims[0]/2,0,0], rot = [0,0,0]);
    qCube(dims = plateDims, os = [plateDims[0]* 3/2 + bbFrameW,0,0], rot = [0,0,0]);
    hull(){
        qCyl(rad=gripR,hei=gripDims[0] ,res=res,os=restOS,rot=[0,90,0]);
        qCube(dims = gripDims, os = gripOS, rot = [0,0,0]);
    }    
}

module neg(){
    translate([0,0,arrowPosTweaker]) hull(){
        qCyl(rad=restR,hei=big ,res=res,os=restOS,rot=[0,90,0]);
        qCube(dims = [big,throatW,big], os = [0,0,throatH], rot = [0,0,0]);
    }
    hull(){
        qCube(dims = frameBlock1Dims, os = frameBlock1OS, rot = [0,0,0]);  
        qCube(dims = frameBlock2Dims, os = frameBlock2OS, rot = [0,0,0]);
    }
    hull(){
        #qCube(dims = frameBlock2Dims, os = frameBlock2OS + [plateDims[0],0,0], rot = [0,0,0]);
        #qCube(dims = frameBlock3Dims, os = frameBlock3OS, rot = [0,0,0]);
    }
    translate([-lil,0,5]) for (i = [-1,1]){
        screw(screwDims, type = "nil",os = screwOS + [0,i * screwYOS,0], rot = [0,90,0], res = 0.25 * res);
        nut(nutDia, nut_height = nutH,os = screwOS + [0,i * screwYOS,0], rot = [0,90,0]);
    }
}

rotate([0,0,0]) difference(){
    pos();
    neg();
}
