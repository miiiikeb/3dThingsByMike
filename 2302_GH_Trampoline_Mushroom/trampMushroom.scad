include<mbLib.scad>;

res = 1;

radPos1 = [13.5,15,15,14];
hPos1 = [0,1.5,4,5,5];
ySlice = 0.15;

radNeg = [6,6,3.1,3.1];
hNeg = [0,1,3.9,15,15];

module pos(){
    for(y = [5:ySlice:15 - ySlice]){
        rad1 = 2*((y-10)/5)*((y-10)/5) + 7.5;
        rad2 = 2*(((y + ySlice)-10)/5)*(((y + ySlice)-10)/5) + 7.5;
        qCone(rad1=rad1,rad2=rad2,hei=ySlice,res=res,os=[0,0,y]);
    }
    for(i = [0:len(radPos1)-1]){
        qCone(rad1=radPos1[i],rad2=radPos1[i+1],hei=hPos1[i+1] - hPos1[i],res=res,os=[0,0,hPos1[i]]);
    }
    
    
}

module neg(){
    for(i = [0:len(radNeg)-1]){
        qCone(rad1=radNeg[i],rad2=radNeg[i+1],hei=hNeg[i+1] - hNeg[i],res=res,os=[0,0,hNeg[i]]);
    }
}

difference(){
    pos();
    neg();
}