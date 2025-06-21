
crossSect = false;
rodR = 2.03;
//[r1,r2,h,ZOS]//
p1 = [4,4,10,0]; //0
p2 = [p1[1],3,1,p1[2]]; //10
p3 = [p2[1],3,5,p2[2] + p2[3]]; //11
p4 = [p3[1],4,1,p3[2] + p3[3]]; //11
p5 = [p4[1],4,1,p4[2] + p4[3]]; //11
p6 = [p5[1],1,3,p5[2] + p5[3]]; //11
echo("top of pivot = ", p6[2] + p6[3]);

pn1 = [2.1,2.1,8,0]; //0

s1 = [6,6,25.5,0]; //0

clear = 0.5;

sn1 = [p1[0] + clear,p1[0] + clear,13.5,0]; //0
sn2 = [sn1[1],p2[1] + clear,1,sn1[2]]; //0
sn3 = [sn2[1],sn2[1],1,sn2[2] + sn2[3]]; //0
sn4 = [sn3[1],sn1[1],1,sn3[2] + sn3[3]]; //0
sn5 = [sn4[1],sn4[1],3,sn4[2] + sn4[3]]; //0
sn6 = [sn5[1],1,3,sn5[2] + sn5[3]]; //0
echo("bearing face = ", sn6[3] + sn6[3]);


p = [p1,p2,p3,p4,p5,p6];
pn = [pn1];
s = [s1];
sn = [sn1,sn2,sn3,sn4,sn5,sn6];

big = 1000;
lil = 0.0001;
res = 1;

module cyl(vec){
    translate([0,0,vec[3]]) cylinder(r1 = vec[0], r2 = vec[1], h = vec[2], $fn = 720 * res);
    
}

module shellPos(){
    for (i = s){
        cyl(i);
    }    
}

module shellNeg(){
    for (i = sn){
        cyl(i);
    }    
}

module pivPos(){
    for (i = p){
    cyl(i);
    }
    translate([0,0,p6[2] + p6[3]]) sphere(r = p6[1],$fn = res * 60);
}

module pivNeg(){
    for (i = pn){
        cyl(i);
    }
}

module cs(){
    translate([0,0,0]) difference(){
        pivPos();
        pivNeg();
        if (crossSect == true) {translate([-big/2,0,0]) cube(size = big);}
    }
    difference(){
        shellPos();
        shellNeg();
        if (crossSect == true) {translate([-big/2,0,0]) cube(size = big);}
    }
}

module head(){
    difference(){
        hull(){
            minkowski(){
                rotate([0,90,0]) cylinder(r = 2, h = lil,$fn = 60 * res);
                translate([0,0,s1[2] + 3]) rotate([0,90,0]) cylinder(r = rodR, h = 2 * s1[0], $fn = 90 * res, center = true);
            }
            shellPos();
        }
        translate([0,0,s1[2] + 3]) rotate([0,90,0]) cylinder(r = rodR, h = big, $fn = 90 * res, center = true);
        shellNeg();
        if (crossSect == true) {translate([-big/2,0,0]) cube(size = big);}
    }
}
cs();
head();