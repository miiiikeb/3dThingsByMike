include<mbLib.scad>;

res = 1;

bottomBevel = 1;

carrierR = 18.6 / 2;
carrierH = 17.1 - bottomBevel;

lockR = 14 / 2;
lockH = 6.5;

//knobR1 = lockR;
knobBevel = 2;
knobR = lockR;
knobH = 15; //excludes the bevel at the top and bottom
cutZOS = 2; //vertical offset for the cuts, to make the join to the lock clean.

//rimR = 13.1 / 2;
//rimH = 0.5;

//vaneDims = [15, 3, 20];
//vaneZOS = 0.8;

intDims = [4.5, 6.1,17.5];
intOSZ = -0.01;

gap1R = 6.1 / 2;
gap1H = 5;

gap2R1 = gap1R;
gap2R2 = 5.5 / 2;
gap2H = 7 - gap1H;

knurlingR = 4;
knurlingXOS = knobR + 2;
cutCount = 5;

notchR = 3 / 2;
notchH = 2;
notchZOS = 4.2;

indicatorR = notchR;
indicatorTweak = [-1.8, 0 , -0.8];

module pos(){
    qCone(rad1=carrierR - bottomBevel,rad2=carrierR,hei=bottomBevel,res=2 * res,os=[0,0,0],rot=[0,0,0]); //bottomBevel
    qCyl(rad=carrierR,hei=carrierH ,res=2 * res,os=[0,0,bottomBevel]);
    qCyl(rad=lockR,hei=lockH ,res=res,os=[0,0,carrierH]);
    
    //qCone(rad1=knobR1,rad2=knobR,hei=knobBevel,res=res,os=[0,0,carrierH + lockH],rot=[0,0,0],showDoc = false);
    minkowski(){
        difference(){
            qCyl(rad=knobR,hei=knobH ,res=res,os=[0,0,carrierH + lockH + knobBevel]);
            for (cuts = [180 / cutCount:360/cutCount:360]){
                rotate([0,0,cuts]) qCyl(rad=knurlingR,hei=knobH,res=0.5 * res,os=[knurlingXOS,0,carrierH + lockH + knobBevel + cutZOS],rot=[0,0,0]);
            }
        }
        minkShape(bevel=knobBevel,type=6,res=0.5 * res,showDoc = false);
    }
    //qCone(rad1=knobR,rad2=knobR1,hei=knobBevel,res=res,os=[0,0,carrierH + lockH  + knobBevel + knobH],rot=[0,0,0],showDoc = false);
    
    qSphere(rad=indicatorR,res=res,os=[knobR,0,carrierH + lockH  + knobBevel + knobH + knobBevel] + indicatorTweak);
}

module neg(){
    //qCube(dims = vaneDims, os = [0,0,rimH], rot = [0,0,0], showDoc = false);
    qCube(dims = intDims, os = [0,0,intOSZ], rot = [0,0,0], showDoc = false);
    qCyl(rad=gap1R,hei=gap1H ,res=res,os=[0,0,-0.001]);
    qCone(rad1=gap2R1,rad2=gap2R2,hei=gap2H,res=res,os=[0,0,gap1H-0.002],rot=[0,0,0],showDoc = false);
    
    for (notches = [0:120:240]){
        #rotate([0,0,notches]) qCyl(rad=notchR,hei=2 * notchH ,res=res,os=[carrierR - notchH,0,notchZOS],rot=[0,90,0]);
    }
}

difference(){
    pos();
    neg();
}
