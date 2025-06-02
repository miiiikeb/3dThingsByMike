shaft_r = 10;
top_bulge_r = 15;
top_bulge_zos = 60;
top_bulge_scale = 1.5;

bot_bulge_r = 15;
bot_bulge_zos = 60;
bot_bulge_scale = 0.3;

res = 0.1;

cylinder(r=shaft_r, h=top_bulge_zos, $fn = res*360);

translate([0,0,top_bulge_zos]) scale([1,1,top_bulge_scale]) difference(){
    sphere(r=top_bulge_r, $fa = res * 5, center = true);
    translate([0,0,-100] ) cube(size = 200, center = true);
}

translate([0,0,bot_bulge_zos]) scale([1,1,bot_bulge_scale]) difference(){
    sphere(r=bot_bulge_r, $fa = res * 5, center = true);
    translate([0,0,100] ) cube(size = 200, center = true);
}
