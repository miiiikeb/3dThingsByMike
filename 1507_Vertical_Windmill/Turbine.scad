  


build();   //Uncomment to build a view of all three complete blades. This is  only useful for getting an idea of the shape. Don't try to print this :)

//rotate([0,0,-70]) segment(1); //Uncomment to generate segment 1
//rotate([0,0,-30]) segment(2); //Uncomment to generate segment 2
//rotate([0,0,10]) segment(3);    //Uncomment to generate segment 3
//th_mount();                //Uncomment to build the central mount for straight rod

/****PLUG & SOCKET SETTINGS****/
//You may need to tinker with these slightly to get a good push fit between the plug and socket pieces of the blade segments
shell_os = 1.7;         //Thickness of the blade skin
plug_os = 2.1;          //Difference between the blades outer skin & the plug
joiner_len = 40;        //Length of the plug


/****STRUT SETTINGS****/
//These may have to change too to suit whatever strut diameter you're using (or just leave them and drill it out to suit!)
strut_id = 4.1;     //internal diamter of the hole for the strut. On my printer this comes out about 0.5mm smaller than stated.
strut_od1 = 7;      //outer diamter of the cone shaped socket that the strut goes into
strut_od2 = 14;     //diamter of the other end of the cone shaped socket (inside the blade)
strut_depth = 8;    //you may need to adjust this with different blade settings if the penetration for the strut doesn't go right through the blade skin


/**** BLADE SETTINGS ****/
blade_cl = 150;         //distance from axle to blade centre-line
chord_len=40;           //chord length of the blade
piv = 0.295;            //scale factor to shift the blade forwards / backwards
blade_height = 440;     //total height of the blade
blade_rot = 120;        //angle of rotation of each blade
blade_slices = 100;    //number of vertical slices to built the blade. Use 100 for draft tinkering then 1000 to print (1000)
num_segs = 3;           //number of blade segments to print (3)
plug_base = 5;          //mm's of solid fill to go below the narrow plug.(5)
plug_len = 20;          //length of the plug between blade segments(20)
num_blades = 3;         //number of blades
end_os = 70;            //distance from top and bottom for strut sockets (70)
num_sockets = 3;        //number of strut sockets

/****MOUNT SETTINGS (STRAIGHT ROD)****/
st_mnt_big_r = 30;         //radius of the 'outer' cylinder
st_mnt_core = 8.4;         //diameter of the pentration for the central shaft.
st_mnt_depth = 10;         //thickness of the rim of the mount
st_mnt_screw = 3.4;        //diameter of the blockout for the screw-holes
st_mnt_screw_head = 7;     //diameter of the blockout for the screw-head
st_mnt_screw_head_depth = 3;   //depth of the blockout for the screw-head
st_mnt_height = 30;        //overall height of the mount
st_mnt_lil_r = 15;         //radius of the 'inner' cylinder
st_mnt_cross_hole = 3.4;   //diameter of the hole through the inner cylinder
st_mnt_nut_d = 6.1;        //width of nut to suit the hole through the inner cylinder




/*****MAIN SCRIPT*******/

NACA0024=[[1.0000,0.00252],[0.9500,0.01613],[0.9000,0.02896],[0.8000,0.05247],[0.7000,0.07328],[0.6000,0.09127],[0.5000,0.10588],[0.4000,0.11607],[0.3000,0.12004],[0.2500,0.11883],[0.2000,0.11475],[0.1500,0.10691],[0.1000,0.09365],[0.0750,0.08400],[0.0500,0.07109],[0.0250,0.05229],[0.0125,0.03788],[0.0000,0.00000],[0.0125,-0.03788],[0.0250,-0.05229],[0.0500,-0.07109],[0.0750,-0.08400],[0.1000,-0.09365],[0.1500,-0.10691],[0.2000,-0.11475],[0.2500,-0.11883],[0.3000,-0.12004],[0.4000,-0.11607],[0.5000,-0.10588],[0.6000,-0.09127],[0.7000,-0.07328],[0.8000,-0.05247],[0.9000,-0.02896],[0.9500,-0.01613],[1.0000,-0.00252]];

NACA0024_CORE=[[0.7000,0.07328],[0.6000,0.09127],[0.5000,0.10588],[0.4000,0.11607],[0.3000,0.12004],[0.2500,0.11883],[0.2000,0.11475],[0.1500,0.10691],[0.1000,0.09365],[0.0750,0.08400],[0.0500,0.07109],[0.0250,0.05229],[0.0125,0.03788],[0.0000,0.00000],[0.0125,-0.03788],[0.0250,-0.05229],[0.0500,-0.07109],[0.0750,-0.08400],[0.1000,-0.09365],[0.1500,-0.10691],[0.2000,-0.11475],[0.2500,-0.11883],[0.3000,-0.12004],[0.4000,-0.11607],[0.5000,-0.10588],[0.6000,-0.09127],[0.7000,-0.07328]];

socket_span = blade_height - 2 * end_os;                //distance between the two end sockets
socket_os = socket_span / (num_sockets - 1);            //distance between the socket centers
//strut_h = [end_os,blade_height/2,blade_height-end_os];
seg_len = blade_height / num_segs;                      //length of the foil segments for printing

module foil(){

    linear_extrude(height = blade_height, center = false, convexity = 10, twist = blade_rot, slices = blade_slices, scale = 1.0){ 
        translate([blade_cl,piv*chord_len,0]) rotate([0,0,-90]) polygon(points=chord_len*NACA0024);
        }
    for (j=[0:num_sockets-1]){
        strut_h = end_os + j * socket_os;
rotate([0,0,-360*strut_h/(blade_height*num_blades)]) translate([blade_cl-strut_depth,-chord_len/2+piv*chord_len,strut_h]) rotate([0,90,0]) cylinder(d1=strut_od1,d2=strut_od2, h=strut_depth, $fa=3);
        
    }
 }

module foil_core(core_os){
    linear_extrude(height = blade_height, center = false, convexity = 10, twist = blade_rot, slices = blade_slices, scale = 1.0){
        translate([blade_cl,piv*chord_len,0]) rotate([0,0,-90]) offset(r=-core_os){
            polygon(points=chord_len*NACA0024_CORE);
        }
    }
    for (j=[0:num_sockets-1]){
        strut_h = end_os + j * socket_os;
        rotate([0,0,-360*strut_h/(blade_height*num_blades)]) translate([blade_cl-2*strut_depth-0.1,-chord_len/2+piv*chord_len,strut_h]) rotate([0,90,0]) cylinder(d=strut_id,h=strut_depth*2,$fn=20);
    }
}


/* builds a set of 'num_blades' blades. Only really useful for looking at */
module build(){
    for(i=[0:num_blades-1]){
        rotate([0,0,i*(360/num_blades)]){
            for(j=[1:num_segs]){
                segment(j);
            }
        }
    }
    for(i=[0:num_sockets-1]){
        translate([0,0,end_os + i*socket_os]) th_mount(); //this needs to be rotated to suit the height
    }
}

/* module joiner no longer used in rev 03 */
module joiner(){
    difference(){
        foil();
        foil_core(shell_os);
        cylinder(r = 2*blade_cl,h=blade_height/2 - joiner_len/2);
        translate([0,0,blade_height/2+joiner_len/2]) cylinder(r=2*blade_cl,h=blade_height);
    }
}

/* module lower_blade no longer used in rev 03 */
module lower_blade(){
    difference(){
        foil();
        translate([0,0,blade_height/2-joiner_len/2]) cylinder(r=2*blade_cl,h=blade_height);
    }
    difference(){
        foil_core(plug_os);
        translate([0,0,blade_height/2-strut_id*0.75]) cylinder(r=2*blade_cl,h=blade_height);
    }
}

/* module top_blade no longer used in rev 03 */
module top_blade(){
    difference(){
        foil();
        cylinder(r=2*blade_cl,h=blade_height/2+joiner_len/2);
    }
    difference(){
        foil_core(plug_os);
       cylinder(r=2*blade_cl,h=blade_height/2+strut_id*0.75);
    }
}


/* module test_print no longer used in rev 03 */
module test_print(){
    translate([-50,150,-(blade_height/2-joiner_len/2-2)]) difference(){
        union(){
            translate([-100,0,0]) lower_blade();
            translate([-50,0,-2]) joiner();
            translate([-80,0,blade_height]) rotate([0,0,60]) rotate([0,180,0]) top_blade();
        }
        cylinder(r=2*1000,h=blade_height/2-joiner_len/2-2);
    }
}

module hollow_foil(){
    difference(){
        foil();
        foil_core(shell_os);
    }
}

/* builds a plug_end the in position to suit segment 'num' (starts at '1') */
module plug_end(pe_num){
    intersection(){
        foil();
        translate([0,0,pe_num*seg_len-plug_base]) cylinder(r=2*blade_cl,h=plug_base);
    }
    intersection(){
        foil_core(plug_os);
        translate([0,0,pe_num*seg_len-plug_base]) cylinder(r=2*blade_cl,h=plug_base+plug_len);
    }
}

/* prints the blade segment 'num' (starts at '1') */
module segment(num){
    intersection(){
        hollow_foil();
        translate([0,0,(num-1)*seg_len]) cylinder(r=2*blade_cl,h=seg_len);
    }
    if(num<num_segs){
        plug_end(num);
    } else{
        intersection(){
            foil();
            translate([0,0,blade_height-plug_base]) cylinder(r=2*blade_cl,h=seg_len);
        }
    }
    if(num==1){
        intersection(){
            foil();
            cylinder(r=2*blade_cl,h=shell_os);
        }
    }

            
}

        


module build_mount_straight_rod(){
    difference(){
        minkowski(){
            mount_core_str();
            sphere(r=1,$fa=20);
        }
        mount_blockout_str();
    }
}

module mount_core_str(){
    cylinder(r=st_mnt_big_r,h=st_mnt_depth-2,$fa=3, center=true);
    translate([0,0,-(st_mnt_depth-2)/2]) cylinder(r=st_mnt_lil_r,h=st_mnt_height-2,$fa=3);
}

module mount_blockout_str(){
    cylinder(d=st_mnt_core,h=st_mnt_height * 4,$fa=3,center=true); //shaft
        for(i=[0:num_blades-1]){
            rotate([0,90,i*360/num_blades]) cylinder(d=strut_id,h=4*st_mnt_big_r,$fn=20);
            rotate([0,0,i*360/num_blades+ 180/num_blades]) translate([st_mnt_lil_r+(st_mnt_big_r-st_mnt_lil_r)/2,0,0]) cylinder(d=st_mnt_screw,h=2*st_mnt_depth,$fn=20,center=true);  //screw hole
            rotate([0,0,i*360/num_blades+ 180/num_blades]) translate([st_mnt_lil_r+(st_mnt_big_r-st_mnt_lil_r)/2,0,st_mnt_depth-st_mnt_screw_head_depth]) cylinder(d=st_mnt_screw_head,h=st_mnt_depth,$fn=20,center=true);  //screw head
            translate([0,0,(st_mnt_height-st_mnt_depth)/2 + st_mnt_depth/2]) rotate([0,90,0]) cylinder(d=st_mnt_cross_hole,h=st_mnt_height*4,$fn=20,center=true);
            translate([st_mnt_lil_r-st_mnt_screw_head_depth/2,0,(st_mnt_height-st_mnt_depth)/2 + st_mnt_depth/2]) rotate([0,90,0]) cylinder(d=st_mnt_screw_head,h=st_mnt_screw_head_depth*2,$fn=20);
        }
        for(i=[0,120,240]){
            translate([-st_mnt_lil_r,0,(st_mnt_height-st_mnt_depth)/2 + st_mnt_depth/2]) rotate([i,0,0]) cube(size = [3,6*tan(30),6],center=true);
    }
}
    
//****MOUNT SETTINGS (THREADED ROD)****/
th_mnt_big_r = 20;
th_mnt_core = 8.3;
th_mnt_depth = 17;
th_mnt_nut_d = 13.6;
th_mnt_nut_h = 6;
th_chamfer_d = 2;

module th_mount(){
    difference(){
        minkowski(){
            cylinder(r=th_mnt_big_r-4, h=th_mnt_depth-2,$fa=2,center=true);
            sphere(d=th_chamfer_d,$fa=3);
        }
         for(i=[0:num_blades-1]){
            rotate([0,90,i*360/num_blades]) cylinder(d=strut_id,h=4*th_mnt_big_r,$fn=20);
         }
         for(i=[0,120,240]){
             translate([0,0,th_mnt_depth/2 - th_mnt_nut_h / 2]) rotate([0,0,i]) cube(size=[th_mnt_nut_d,th_mnt_nut_d*tan(30),th_mnt_nut_h],center=true);
         }
         cylinder(d=th_mnt_core,h=2*th_mnt_depth,$fn=30,center=true);
     }
 }
        