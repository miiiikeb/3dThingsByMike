overprint = 1;

cyl_z = 50;
cyl_r = 4.6 - overprint/2;
key_r = cyl_r - 1;
key_z = 10;
keyhole_r = key_r + overprint/2;
nose_z = 27;
nose_r = 8 - overprint/2;

res = 200;

translate([40,0,0]) {
    cylinder(r = cyl_r, h = cyl_z, $fn = res);
    cylinder(r = key_r, h = cyl_z + key_z, $fn = res);
}



/*
difference(){
    minkowski(){
        difference(){
            scale([nose_r-1,nose_r-1,nose_z-1]) sphere(r=1, $fn = res);
            translate([0,0,-48.999]) cube(size=[100,100,100], center = true);
        }
        sphere(r=1,$fa = 10);
    }
    cylinder(r = keyhole_r, h = key_z+1, $fn = res);
}
        