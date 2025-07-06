include <dipLib.txt>;
include <200420Lib.txt>;
include <tubParameters.txt>;
countX = 6;
countY = 6;
res = 0.1; // 1 for full resolution, <1 for lower poly (faster render)



module singlePos(){
}

module tubeNeg(){
    
    for (xOS = [-(countX-1)*headOS/2:headOS:(countX-1)*headOS/2]){
        for (yOS = [-(countY-1)*headOS/2:headOS:(countY-1)*headOS/2]){    
            translate([xOS,yOS,0]){
                qCyl(rad=pipeDia / 2,hei=socZ,res=res,os=[0,0,0],rot=[0,0,0]); //Pipe socket
                qCone(rad1=pipeDia / 2,rad2=pipeDia / 2 - stopRdelta,hei=stopZ,res=res,os=[0,0,socZ],rot=[0,0,0]); //Block at the top of the pipe
                qCyl(rad=pipeDia / 2 - stopRdelta,hei=stopStraightZ + drainZ,res=res,os=[0,0,socZ + stopZ],rot=[0,0,0]); //vertical section above the blocker
                hull(){ //pyramid shaped drain
                    qCube(dims = [lil,lil,lil], os = [0,0,socZ + stopZ + stopStraightZ], rot = [0,0,0]);
                    qCube(dims = [headOS,headOS,lil], os = [0,0,socZ + stopZ + stopStraightZ + drainZ], rot = [0,0,0]);
                }
                hull(){//rest of the tub (but tapered out which gets cut back later)
                    qCube(dims = [headOS,headOS,lil], os = [0,0,socZ + stopZ + stopStraightZ + drainZ], rot = [0,0,0]);
                   qCube(dims = [2 * headOS,2 * headOS,lil], os = [0,0,totalZ - lil], rot = [0,0,0]); 
                }
            }
        }
    }

}    

    //blockouts for the bottom channels
module bottomChannelNeg(){
    for(a = [0,90,180,270]){
        for(flip = [1,-1]){
            for(OS = [headOS:headOS:max(countX,countY) * headOS / 2]){
                rotate([0,0,a]) hull(){
                    qCube(dims = bottomBlockDims1, os = [OS,0,0] + [0,flip * (-flangeDims1[1]/2-big/2),0], rot = [0,0,0]);
                    qCube(dims = bottomBlockDims2, os = [OS,0,0] + [0,flip * (-flangeDims1[1]/2-big/2),0], rot = [0,0,0]);
                }
            }
        }
    }
}


//Block to round off the corners of the tub
module tub(rad1,rad2,hei,os=[0,0,0]){
    translate(os) hull(){
        for (xOS = [-(countX-1)*headOS/2,(countX-1)*headOS/2]){
            for (yOS = [-(countY-1)*headOS/2,(countY-1)*headOS/2]){
                qCone(rad1=rad1,rad2=rad2,hei=hei,res=res * 180,os=[xOS,yOS,0],rot=[0,0,0]);
            }
        }
    }
}




module nutNbolt(os = [0,0,0],rot = [0,0,0]){
    translate([0,flangeNutH - (flangeNutH + screwDims[3] + screwDims[1])/2,0] + os) rotate(rot) {
        screw(dims = screwDims, os = [0,0,0],rot = [0,90,90]);
        nut(nut_dia=flangeNutD, nut_height = flangeNutH, os = [0,0,0], rot = [0,-90,90]);
    }
}


module flangeScrews(){
    
    flangeCLbottom = (countX-1)*headOS/2 + pipeDia/2 + flangeDims1[0]/2;
    flangeCLtop = (countX-1)*headOS/2 + headOS / 2 + skin + flangeDims1[0]/2;
    flangeDelta = flangeCLtop - flangeCLbottom;
    
    function xScrew(zOS) = flangeCLbottom + (zOS / totalZ) * flangeDelta;
    function zScrew(holeNum,totHoles) = 0;


    

    //add the screws to the sides
    for(zOS = [bottomScrewZ:(totalZ - bottomScrewZ + topScrewZ) / (sideScrewCount-1):totalZ + topScrewZ]){
        nutNbolt(os = [xScrew(zOS),0,zOS]);
    }

   
    //add the screws to the bottom    
    for(rowOS = cutRowsX * headOS){
        for(osX = [headOS:headOS:(countX-1) * headOS / 2]){
            nutNbolt(os = [osX,rowOS,baseScrewZ]);
        }
    }
}



module flange(){
    hull(){
        qCube(dims = flangeDims1, os = [(countX-1)*headOS/2 + pipeDia/2 + flangeDims1[0]/2-1,0,0], rot = [0,0,0]);
        qCube(dims = flangeDims2, os = [(countX-1)*headOS/2 + pipeDia/2 + flangeDims2[0]/2-1,0,0], rot = [0,0,0]);
        qCube(dims = flangeDims1, os = [(countX-1)*headOS/2 + headOS / 2 + skin + flangeDims1[0]/2-1,0,totalZ], rot = [0,0,0]);
        qCube(dims = flangeDims2, os = [(countX-1)*headOS/2 + headOS / 2 + skin + flangeDims2[0]/2-1,0,totalZ], rot = [0,0,0]);
    }
}




module body(cutX = false, cutY = false){
//build the bottom taper block
    difference(){
        tub(rad1 = pipeDia/2 + skin, rad2 = pipeDia/2 + skin, hei = bottomTaperZ );
        tubeNeg();
        bottomChannelNeg();
        for(a = [0,90,180,270]){
            rotate([0,0,a]) flangeScrews();    
        }
    }

    
    //build the top taper block
    difference(){
        union(){
            tub(rad1 = pipeDia/2 + skin, rad2 = headOS / 2 + skin, hei = totalZ - bottomTaperZ,os = [0,0,bottomTaperZ]);
            tub(rad1 = headOS / 2, rad2 = headOS / 2 + topTaperR, hei = topTaperZ - lipZ,os = [0,0,totalZ - topTaperZ]);
            tub(rad1 = headOS / 2 + topTaperR, rad2 = headOS / 2 + topTaperR, hei = lipZ,os = [0,0,totalZ - lipZ]);
        }
        intersection(){
            tub(rad1 = pipeDia/2, rad2 = headOS / 2, hei = totalZ - bottomTaperZ,os = [0,0,bottomTaperZ]);
            tubeNeg();
        }
        bottomChannelNeg();
    }
    //add the flanges
    difference(){ ///***CHANGE TO DIFFERENCE ONCE SCREW LENGTH IS CORRECT***
        for(a = [0,90,180,270]){
            rotate([0,0,a]) flange();
        }
        for(a = [0,90,180,270]){
            rotate([0,0,a]) flangeScrews();        
        }
    }
}


    
difference(){
    body();
    qCube(dims = [big,big,big],os = [0,-big/2,0]);
    qCube(dims = [big,big,big],os = [-big/2,0,0]);
}


