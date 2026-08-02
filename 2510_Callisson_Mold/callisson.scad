rad = 25;
os = 30;
depth = 11;

x_count = 7;
y_count = 4;
x_os = 25;
y_os = 45;
rot = 0;


module callisson(instance_os = [0, 0], rot = 0){
    translate(instance_os) rotate([0,0,rot]){
       intersection_for(callisson_curve_os = [-os/2,os/2]) translate([callisson_curve_os,0 ,0]) circle(r = rad, $fn = rad * 12);
    }
}

for (x = [x_os/2:x_os:x_count * x_os]){
    for (y = [y_os/2: y_os: y_count * y_os]){
        callisson(instance_os = [x, y], rot = rot);
    }
}
    