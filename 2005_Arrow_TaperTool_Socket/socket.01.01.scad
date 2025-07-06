include<mblib.scad>;

skin = 5;
socD = 14;


module pos(){
    cylinder(r1 = 14.5/2, r2 = 15.1/2, h = socD, $fn = 128);

    difference(){
        cylinder(r = 21.8/2 + skin, h = socD, $fn = 128);
        cylinder(r = 21.8/2, h = socD, $fn = 128);
    }

    translate([0,0,socD]) cylinder(r1 = 21.8/2 + skin, r2 = 7, h = 10, $fn = 128);
}

module neg(){
    cylinder(r = 3, h = 50, $fn = 128);
    hull(){
        nut(nut_dia = 10, nut_height = 4.5);
        cylinder(r = 3, h = 6.5, $fn = 128);
    }
            
}

difference(){
    pos();
    neg();
}