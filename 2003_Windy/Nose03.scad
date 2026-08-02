big = 1000;
lil = 0.001;
res = 1;

rodR = 2.05;
rodZ = 40;
rodSkin = 0.8;

bulgeR = 5;

noseOS = [-60,0,0];
noseScale = [3,1,1];
noseR = 2;

steps = 50;
topZ = 20;
baseZ = 30;

function formula1(x) = sqrt(1 - pow(x/steps,2));
function formula2(x) = rodR + rodSkin + ((5 - rodR - rodSkin)/2) * (1 + sin(180 * x / steps - 90));

module nose1(){
    translate([0,0,baseZ]) for (i = [0:steps-1]){
        translate([0,0,i * topZ / steps]) cylinder(r1 = 5 * formula1(i),r2 = 5 * formula1(i+1), h = topZ/steps,$fn = res * 90);
        echo(formula1(i));
    }
}
module nose2(){
    for (i = [0:steps-1]){
        translate([0,0,i * baseZ / steps]) cylinder(r1 = formula2(i),r2 = formula2(i+1), h = baseZ/steps,$fn = res * 90);
    }
}


module build(n1=false,n2=false){
    difference(){
        union(){
            if (n1 == true){nose1();}
            if (n2 == true){nose2();}
        }
        translate([0,0,-lil]) cylinder(r = rodR, h = rodZ, $fn = res * 90);
    }
}

//build(true,true); //all
translate([20,0,-baseZ]) build(true,false);
translate([40,0,baseZ]) rotate([180,0,0]) build(false,true);

