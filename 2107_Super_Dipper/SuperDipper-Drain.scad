include <dipLib.txt>;
include <200420Lib.txt>;
include <tubParameters.txt>;

countX = 6;
countY = 6;
res = 0.1; // 1 for full resolution, <1 for lower poly (faster render)

xfall = 5;
yfall = 10;


module singlePos(){
}

centreBlockZ = 5;
drainDims = [50,50,100];
dSkin = 3;
couplerDims = [50,5,35];
couplerJDims = [50,8,35];
couplerBDims = [12,headOS-pipeDia/2,43];

module tubeNeg_drain(){
    xrange = (countX-1)*headOS/2;
    xgrad = xfall/xrange;
    yrange = (countY-1)*headOS;
    ygrad = yfall/yrange;
    
    for (xOS = [-(countX-1)*headOS/2:headOS:(countX-1)*headOS/2]){
        for (yOS = [-(countY-1)*headOS/2:headOS:(countY-1)*headOS/2]){    
            translate([xOS,yOS,0]){
                qCyl(rad=pipeDia / 2,hei=socZ,res=res,os=[0,0,0],rot=[0,0,0]); //Pipe socket
                qCone(rad1=pipeDia / 2,rad2=pipeDia / 2 - stopRdelta,hei=stopZ,res=res,os=[0,0,socZ],rot=[0,0,0]); //Block at the top of the pipe
                qCyl(rad=pipeDia / 2 - stopRdelta,hei=xfall - abs(xOS) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad,res=res,os=[0,0,socZ + stopZ],rot=[0,0,0]); //vertical section above the blocker
            }
        }
    }
    
    //Build the X-channels
    xOS2 = [-(countX-1)*headOS/2,0,(countX-1)*headOS/2];
    for (x = [0,1]){
        for (yOS = [-(countY-1)*headOS/2:headOS:(countY-1)*headOS/2]){    
            hull(){
                for (i = [0,1]){
                    translate([xOS2[x + i],yOS,xfall - abs(xOS2[x + i]) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad]) 
                    qCone(rad1=pipeDia / 2 - stopRdelta,rad2=1,hei=pipeDia / 2 - stopRdelta,res=res,os=[0,0,socZ + stopZ]);//vertical section above the blocker
                }
            }
        }
    }
    
    //Build the Y-channels
    hull(){
        xOS3 = 0;
        for (yOS = [-(countY-1)*headOS/2,(countY)*headOS/2]){    
            translate([xOS3,yOS,xfall - abs(xOS3) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad + socZ + stopZ]) 
            scale([2,1,2]) qCone(rad1=pipeDia / 2 - stopRdelta,rad2=1,hei=pipeDia / 2 - stopRdelta,res=res,os=[0,0,0]);//vertical section above the blocker
        }
    }


    //Build the bottom Y-Block
    hull(){
        xOS3 = 0;
        for (yOS = [-(countY-1)*headOS/2,(countY)*headOS/2]){    
            translate([xOS3,yOS,xfall - abs(xOS3) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad + centreBlockZ]) 
            qCone(rad1=(headOS - pipeDia)/2-skin,rad2=1,hei=pipeDia / 2 - stopRdelta,res=res,os=[0,0,0]);//vertical section above the blocker
            translate([xOS3,yOS,0])qCyl(rad=(headOS - pipeDia)/2-skin,hei=xfall - abs(xOS3) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad  + centreBlockZ,res=res,os=[0,0,0],rot=[0,0,0]);
        }
    }

    qCube(dims = drainDims, os = [0,(countY-1) * headOS/2 + drainDims[1]/2 + pipeDia/2 + dSkin,0], rot = [0,0,0]);
    
    //Blockouts for the coupler
    for(xOS = [-headOS,headOS]){
       for(i = [1,2]){
           translate([i * xOS,0,0]){
               #for(zOS = [5,couplerBDims[2]]){
                   nutNboltLong(os = [0,0,zOS], rot = [0,0,0]);
               }
               for(i = [-1,1]){
                   hull(){
                       qCube(dims = [12,20,5], os = [0,i * (couplerBDims[1]/2 + 10),0], rot = [0,0,0]);    
                       qCube(dims = [2,20,10], os = [0,i * (couplerBDims[1]/2 + 10),0], rot = [0,0,0]);
                   }    
               }
           }           
       }
   }

}    



module couplerDrain(){
    difference(){
        translate([0,(countY-1) * headOS/2 + couplerDims[1]/2 + pipeDia/2 + 0.8 * dSkin,0]){
            qCube(dims = couplerDims , os = [0,0,0], rot = [0,0,0]);
            qCyl(rad=couplerDims[0]/2,hei=couplerDims[1],os=[0,couplerDims[1]/2,couplerDims[2]],rot=[90,0,0]);
        }
        xrange = (countX-1)*headOS/2;
        xgrad = xfall/xrange;
        yrange = (countY-1)*headOS;
        ygrad = yfall/yrange;
        hull(){
            xOS3 = 0;
            for (yOS = [-(countY-1)*headOS/2,(countY)*headOS/2]){    
                translate([xOS3,yOS,xfall - abs(xOS3) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad + socZ + stopZ]) 
                scale([2,1,2]) qCone(rad1=pipeDia / 2 - stopRdelta,rad2=1,hei=pipeDia / 2 - stopRdelta,res=res,os=[0,0,0]);//vertical section above the blocker
            }
        }
        #nutNbolt(os = [0,(countY-1) * headOS/2 + couplerDims[1] + pipeDia/2 + 0.8 * dSkin,20], rot = [0,0,0]);
        for(a = [-50,0,50]){
            translate([0,0,couplerDims[2]]) rotate([0,a,0]) nutNbolt(os = [0,(countY-1) * headOS/2 + couplerDims[1] + pipeDia/2 + 0.8 * dSkin,couplerDims[0]/2-5], rot = [0,0,0]);
        }
    }
}


module couplerJoint(){
    difference(){
        translate([0,0,0]){
            qCube(dims = couplerJDims , os = [0,0,0], rot = [0,0,0]);
            qCyl(rad=couplerJDims[0]/2,hei=couplerJDims[1],os=[0,couplerJDims[1]/2,couplerJDims[2]],rot=[90,0,0]);
        }
        xrange = (countX-1)*headOS/2;
        xgrad = xfall/xrange;
        yrange = (countY-1)*headOS;
        ygrad = yfall/yrange;
        hull(){
            xOS3 = 0;
            for (yOS = [-(countY-1)*headOS/2,(countY)*headOS/2]){    
                translate([xOS3,yOS,xfall - abs(xOS3) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad + socZ + stopZ]) 
                scale([2,1,2]) qCone(rad1=pipeDia / 2 - stopRdelta,rad2=1,hei=pipeDia / 2 - stopRdelta,res=res,os=[0,0,0]);//vertical section above the blocker
            }
        }
        for(z = [6,15]) nutNbolt(os = [0,0,z], rot = [0,0,0]);
        for(a = [-75,-40,0,40,75]){
            translate([0,0,couplerJDims[2]]) rotate([0,a,0]) nutNbolt(os = [0,0,couplerJDims[0]/2-5], rot = [0,0,0]);
        }
    }
   


}



legR = 7;
footR = 13;
legZ1 = 50;
legZ2 = 10;
footZ = 3;
module legs(){
    difference(){
        for (yOS = [-(countY-1)*headOS/2,-headOS/2,headOS/2,(countY-1)*headOS/2]){ 
            for (xOS = [-(countX-1)*headOS/2,(countX-1)*headOS/2]){
                translate([xOS,yOS,0]){
                    qCyl(rad=legR,hei=legZ1,res=res,os=[0,0,0],rot=[0,0,0]); 
                    qCone(rad1=legR,rad2=footR,hei=legZ2,res=res,os=[0,0,legZ1]);
                    qCyl(rad=footR,hei=footZ,res=res,os=[0,0,legZ1 + legZ2],rot=[0,0,0]); 
                }
            }
        }
        tubeNeg_drain();
    }
}



module posBlock(){
    xrange = (countX-1)*headOS/2;
    xgrad = xfall/xrange;
    yrange = (countY-1)*headOS;
    ygrad = yfall/yrange;
    
    for (yOS = [-(countY-1)*headOS/2:headOS:(countY-1)*headOS/2]){ 
        hull() for (xOS = [-(countX-1)*headOS/2,0,(countX-1)*headOS/2]){
            translate([xOS,yOS,0]){
                z = socZ+stopZ + xfall - abs(xOS) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad - dSkin;
                qCyl(rad=pipeDia / 2 + dSkin,hei=z,res=res,os=[0,0,0],rot=[0,0,0]); 
                qCone(rad1=pipeDia / 2 + dSkin,rad2=5,hei=pipeDia / 2 + 2 * dSkin,res=res,os=[0,0,z]);
            }
        }
    }
    xOS = 0;
    hull() for (yOS = [-(countY-1)*headOS/2,(countY)*headOS/2]){ 
        scale([1.5,1,1]) translate([xOS,yOS,0]){
            z = socZ+stopZ + xfall - abs(xOS) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad;
            qCyl(rad=pipeDia / 2 + dSkin,hei=z,res=res,os=[0,0,0],rot=[0,0,0]); 
            qCone(rad1=pipeDia / 2 + dSkin,rad2=5,hei=pipeDia / 2 + 3 * dSkin,res=res,os=[0,0,z]);
        }
    }
   
   //coupler 
   for(xOS = [-headOS,headOS]){
       for(i = [1,2]){
           translate([i * xOS,0,0]){
               difference(){
                   union(){
                       qCube(dims = couplerBDims, os = [0,0,0], rot = [0,0,0]);
                       qCyl(rad=couplerBDims[0]/2,hei=couplerBDims[1],os=[0,couplerBDims[1]/2,couplerBDims[2]],rot=[90,0,0]);
                   }
               }
           }
       }
   }    

/*    //Build the X-channels
    xOS2 = [-(countX-1)*headOS/2,0,(countX-1)*headOS/2];
    for (x = [0,1]){
        for (yOS = [-(countY-1)*headOS/2:headOS:(countY-1)*headOS/2]){    
            hull(){
                for (i = [0,1]){
                    translate([xOS2[x + i],yOS,xfall - abs(xOS2[x + i]) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad]) 
                    qCone(rad1=pipeDia / 2 - stopRdelta,rad2=1,hei=pipeDia / 2 - stopRdelta,res=res,os=[0,0,socZ + stopZ]);//vertical section above the blocker
                }
            }
        }
    }
    
    //Build the Y-channels
    hull(){
        xOS3 = 0;
        for (yOS = [-(countY-1)*headOS/2,(countY-1)*headOS/2]){    
            translate([xOS3,yOS,xfall - abs(xOS3) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad + socZ + stopZ]) 
            scale([1.5,1,1.5]) qCone(rad1=pipeDia / 2 - stopRdelta,rad2=1,hei=pipeDia / 2 - stopRdelta,res=res,os=[0,0,0]);//vertical section above the blocker
        }
    }
*/
}    

//tubeNeg_drain();

module posBlockOLD(){
    
    xrange = (countX-1)*headOS/2;
    xgrad = xfall/xrange;
    yrange = (countY-1)*headOS;
    ygrad = yfall/yrange;
    xOS = [-(countX-1)*headOS/2,(countX-1)*headOS/2];
    for (yOS = [-(countY-1)*headOS/2:headOS:(countY-1)*headOS/2]){    
        hull(){
            for (i = [0,1]){
                translate([xOS[i],yOS,0]){
                qCyl(rad=pipeDia / 2 + skin,hei=xfall - abs(xOS[i]) * xgrad + (yOS + (countY-1)*headOS/2) * ygrad + socZ + stopZ + pipeDia / 2 - stopRdelta + skin,res=res,os=[0,0,0],rot=[0,0,0]); 
                }
            }
        }
    }
}

difference(){
    union(){
        difference(){
            posBlock();
            tubeNeg_drain();
        }
        couplerDrain();
        couplerJoint();
        legs();
    }
    qCube(dims = [1000,1000,1000] , os = [0,500,0], rot = [0,0,0]);
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

module nutNboltLong(os = [0,0,0],rot = [0,0,0]){
    translate([0,flangeNutH - (flangeNutH + screwDimsLong[3] + screwDimsLong[1])/2,0] + os) rotate(rot) {
        screw(dims = screwDimsLong, os = [0,0,0],rot = [0,90,90]);
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


