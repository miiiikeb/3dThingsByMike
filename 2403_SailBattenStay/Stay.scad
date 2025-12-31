// Version 1.00: Failed very quickly. Not strong enough.


include <../0000_StdLibraries/BOSL2/std.scad>
include <../0000_StdLibraries/BOSL2/screws.scad>


M10Cover = 4;
M10SlotDepth =8;    //nut depth
M10OS = [0,0,5.4 + 0.5 * 8.8 + 2];
M10CoreR = 8.8/2;
M10CoreDepth = 10;
bigCoreR = 17.2 / 2;
bigCoreXOS = 20;

M5XOS1 = -(22 + 27) / 2;
M5XOS2 = M5XOS1 - 44;
M5YOS = (26.5 + 37) / 2 / 2;
M5ZOS = 5.5;
M5R = 5.2 /2;

module neg(){
    translate(M10OS) rotate([0,-90,0]) rotate([0,0,30]){
        translate([0,0,M10Cover]) nut_trap_inline(M10SlotDepth, "M10", $slop=.8, anchor = BOTTOM);
        translate([0,0,bigCoreXOS]) cylinder(h = 80,r = bigCoreR,$fn = 60);
        translate([0,0,-0.01]) cylinder(h = 80,r = M10CoreR ,$fn = 60);
    }

    for(x = [M5XOS1,M5XOS2]){
        for(y = [-1,1]){
            NutOS = [x, y * M5YOS, M5ZOS];
            echo(y * M5YOS);
            translate(NutOS) rotate([0,0,30]) nut_trap_inline(30,"M5", $slop=.1, anchor = BOTTOM);
            CoreOS = [x, y * M5YOS, -0.01];
            translate(CoreOS) cylinder(h = 30,r = M5R,$fn = 60);
        }
    }
}

bigCoreSkin = 5;
lateralRYOS = 49 / 2 - bigCoreR;
lateralRZOS = 1;
lateralRScale = [1,1,1];
lateralX = 80;

module pos(){
    hull() difference(){
        union(){
            translate([0,0,25 - 5 - bigCoreR]) rotate([0,-90,0]) cylinder(h = lateralX,r = bigCoreR + bigCoreSkin,$fn = 60);
            for(y = [-lateralRYOS, lateralRYOS]){
                scale(lateralRScale) translate([0,y,0]) rotate([0,-90,0]) cylinder(h = lateralX,r = bigCoreR,$fn = 60);
                scale(lateralRScale) translate([0,y,lateralRZOS]) rotate([0,-90,0]) cylinder(h = lateralX,r = bigCoreR ,$fn = 60);

            }
        }
        translate([0,0,-25]) cube(size = [200,200,50], center = true);
    }
}

rotate([0,90,0]) difference(){
    pos();
neg();
}