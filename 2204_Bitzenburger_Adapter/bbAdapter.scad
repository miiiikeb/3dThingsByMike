include<mbLib.scad>;

res = 3;

appertureR = 12.1 / 2;
appertureH = 17.7;
rimR = 13.1 / 2;
rimH = 0.5;

vaneDims = [15, 3, 20];
vaneZOS = 0.8;

intDims = [4.5, 6.2,12];
intOSZ = -0.01;

gap1R = 7.5 / 2;
gap1H = 2;

gap2R1 = 7.5 / 2;
gap2R2 = 5.5 / 2;
gap2H = 3;


module pos(){
    qCyl(rad=appertureR,hei=appertureH ,res=res,os=[0,0,0]);
    qCyl(rad=rimR,hei=rimH ,res=res,os=[0,0,0]);
}

module neg(){
    qCube(dims = vaneDims, os = [0,0,rimH], rot = [0,0,0], showDoc = false);
    qCube(dims = intDims, os = [0,0,intOSZ], rot = [0,0,0], showDoc = false);
    qCyl(rad=gap1R,hei=gap1H ,res=res,os=[0,0,-0.001]);
    qCone(rad1=gap2R1,rad2=gap2R2,hei=gap2H,res=res,os=[0,0,gap1H-0.002],rot=[0,0,0],showDoc = false);
}

difference(){
    pos();
    neg();
}
