//Settings//

shimTurns = 2.5; //Set to the desired equivalent number of limb-bolt turns.
withText = false; //Set to true to inclue text / false to omit text
whichBit = 0; //Set to 0 for shim, 1 for text infill (if desired)
threadPitch = 1.25; //ILF thread pitch is 1.25mm (i.e. 8 turns is 10mm) on a W&W.

// Main script //
// I used osifont to get nice printing. The script will run without it, but if you'd
// like to use it and don't already have it installed, please:
// 1. download osifont.ttf from: https://github.com/hikikomori82/osifont/tree/master.
// 2. add it to the same folder as this file (or anywhere else that it's not likely to move from).
// 3. right-click on osifont.ttf -> More Options -> "Install for all Users".
// 4. Check the OpenSCAD font list (under the Help dropdown) to check that it's installed.

//use<osifont.ttf>
//"osifont:style=Medium"


shimSize = shimTurns * threadPitch; 

wideBit = 33;
tabR = 10;
tabXSO = 30;

module shimText(){
    color("blue") linear_extrude(0.6){
        translate([17,0,0.5]) rotate([0,180,-90]) text(str(shimTurns),size = 10, halign = "center", valign = "center", spacing = 0.9, font = "osifont:style=Medium", $fn = 180);
        translate([8.5,0,0.5]) rotate([0,180,-90]) text("turns",size = 6, halign = "center", valign = "center", font = "osifont:style=Medium", $fn = 180);
    }
}

// Quick Cylinder
module qCyl(rad=1,hei=1,res=0.25,os=[0,0,0],rot=[0,0,0],showDoc = false){
    if (showDoc == true){
        echo("
        \nqCyl(rad=1,hei=1,res=0.25,os=[0,0,0],rot=[0,0,0],showDoc = false)\n");
    }
    else if (showDoc == false){
        translate(os) rotate(rot) cylinder(r = rad, h = hei, $fn = 10 * rad * res);
    }
}

module qCube(dims = [10,10,10], os = [0,0,0], rot = [0,0,0], showDoc = false){
    //build a cube centered on the Z-axis with it's base on the X/Y plane
    if (showDoc == true){
		echo("\nqCube(dims = [10,10,10], os = [0,0,0], rot = [0,0,0], showDoc = false)\n");
	}
	else if (showDoc == false){
        translate(os) rotate(rot) translate([0,0,dims[2]/2]) cube(size = dims, center = true);
	}
}

if(whichBit == 0) difference(){
    hull(){
        qCyl(rad=30/2,hei=shimSize + 1 ,res=2,os=[0,0,0]);
        qCube(dims = [0.001,wideBit,2], os = [20,0,0], rot = [0,0,0]);
        qCyl(rad=tabR,hei=2 ,res=2,os=[tabXSO,0,0]);
        for (i = [-1,1]){
            qCyl(rad=tabR,hei=2.1 ,res=2,os=[20,i * (wideBit/2 - tabR),0]);
        }
    }
    qCyl(rad=27.5/2,hei=3,res=2,os=[0,0,shimSize]);
    qCyl(rad=5,hei=10,res=2,os=[0,0,-0.1]);
    qCube(dims = [40,9,10], os = [-20,0,-0.1], rot = [0,0,0]);
    qCyl(rad=tabR-3,hei=20 ,res=2,os=[tabXSO,0,-0.001]);
    if(withText) shimText();
}

else if(whichBit == 1) shimText();



