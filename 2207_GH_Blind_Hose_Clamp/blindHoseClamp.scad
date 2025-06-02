include<mbLib-0.1.scad>;
include<screwDims.conf>;

res = 1;

hoseR = 23;
clampR = 2;
bevel = 5;

width = 2;
overWidth = 3;
baseZ = 35;

transitionR = 5;

big = 200;
lil = 0.001;


baseDims = [2 * (hoseR + clampR + overWidth),width,lil];
screwXOS = hoseR + M5printedInNutDia/2 + 1;
screwHeadZOS = 33;

nutZOS = 15;

nutCarrierR = 10;

nutCarrierCover = 1;
nutCarrierH = M5printedInNutHei + 2 * nutCarrierCover;

module pos1(){
    hull(){
        qCyl(rad=hoseR+clampR,hei=width,res=res,os=[0,width/2,hoseR],rot=[90,0,0]);
        for(i = [-1,1]){
            qCyl(rad=transitionR,hei=width,res=res,os=[i * (hoseR + clampR + overWidth-transitionR),width/2,baseZ-transitionR],rot=[90,0,0]);
        }
        qCube(dims = baseDims, os = [0,0,0], rot = [0,0,0]);
    }
}

module neg(){
    qCube(dims = [big,big,big], os = [0,0,-big], rot = [0,0,0]);
    qCyl(rad=hoseR,hei=big,res=res,os=[0,big/2,hoseR],rot=[90,0,0]);
    qCube(dims = [2 * (hoseR),big,hoseR], os = [0,0,-0.001], rot = [0,0,0]);
    
    for(i=[-1,1]){
        qCyl(rad=M5ShaftR,hei=big,res=res,os=[i * screwXOS,0,0],rot=[0,0,0]);
        qCyl(rad=M5ButtonHeadR,hei=big,res=res,os=[i * screwXOS,0,screwHeadZOS],rot=[0,0,0]);
    //nut(nutDia, nut_height = nutHei,os = [i * screwXOS,15,nutZOS], rot = [0,0,0]);
    }
}

module makeHoseClamp(){
    difference(){
        minkowski(){
            pos1();
            scale([1,2,1]) minkShape(bevel=bevel,type=4,res=res,showDoc = false);
        }
        neg();
    }
}


module nutCarrierPos(){
    for(i=[-1,1]){
        qCyl(rad=nutCarrierR,hei=nutCarrierH,res=res,os=[i * screwXOS,0,-nutCarrierH],rot=[0,0,0]);
    }
    hull() for(i=[-1,1]){
        qCyl(rad=nutCarrierR,hei=nutCarrierCover,res=res,os=[i * screwXOS,0,-nutCarrierCover],rot=[0,0,0]);
    }
}

module nutCarrierNeg(){
    #for(i=[-1,1]){
        nut(M5printedInNutDia, nut_height = M5printedInNutHei,os = [i * screwXOS,0,-M5printedInNutHei-nutCarrierCover], rot = [0,0,0]);
        qCyl(rad=M5ShaftR,hei=big,res=res,os=[i * screwXOS,0,-big],rot=[0,0,0]);
    }
}

module makeNutCarrier(){
    difference(){
        nutCarrierPos();
        nutCarrierNeg();
    }
}
makeNutCarrier();
//makeHoseClamp();