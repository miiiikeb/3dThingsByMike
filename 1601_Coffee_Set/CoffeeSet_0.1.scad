module serial_hull(){
for(i=[0:$children-2])
    hull(){
        children(i); // use child() in older versions of Openscad!
        children(i+1); // this shape is i in the next iteration!
    }
}
 module tube_hull(t1,r1,t2,r2){
    difference(){
         hull(){
            translate([0,0,t1]) cylinder(r=r1+min_wall, h=0.01, $fn=res, center = false);
            translate([0,0,t2]) cylinder(r=r2+min_wall, h=0.01, $fn=res, center = false);
        }
         hull(){
            translate([0,0,t1]) cylinder(r=r1, h=0.01, $fn=res, center = false);
            translate([0,0,t2]) cylinder(r=r2, h=0.01, $fn=res, center = false);
        }
    }
}

overprint = 0.5;
min_wall = 1.5;

overhang_h = 2;
overhang_ri = 39.5 + overprint;
straight_tube_h = 10;
straight_tube_ri = 35.5;

curve_tube_h = 30;
curve_top_ri = 45;
curve_slices = 25;
curve_max_a = 90;
exp_factor = 5;

     




tube_re = overhang_ri + min_wall;

tube_h = overhang_h +straight_tube_h;
curve_slice_h = curve_tube_h / curve_slices - 0.0001;
curve_slice_exp = exp_factor/curve_slices;
res = 100;

difference(){
    cylinder(r1=tube_re,r2=straight_tube_ri+min_wall, h=tube_h, $fn=res, center = false);
    cylinder(r=overhang_ri, h=overhang_h, $fn=res, center = false);
    translate([0,0,overhang_h]) cylinder(r=straight_tube_ri, h=straight_tube_h, $fn=res, center = false);
}

    for(i=[0 : curve_slices-1]){
        k=i+1;
        offset1 = overhang_h+straight_tube_h+curve_slice_h*i;
        offset2 = overhang_h+straight_tube_h+curve_slice_h*k;
        curve_ri_1 = straight_tube_ri + (1/(exp_factor-i*curve_slice_exp))*(curve_top_ri-straight_tube_ri)-(1/(exp_factor))*(curve_top_ri-straight_tube_ri);       
        curve_ri_2 =  straight_tube_ri + (1/(exp_factor-k*curve_slice_exp))*(curve_top_ri-straight_tube_ri)-(1/(exp_factor))*(curve_top_ri-straight_tube_ri);        
        tube_hull(offset1,curve_ri_1,offset2,curve_ri_2);
      }
