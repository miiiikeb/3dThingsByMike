big = 1000;
lil = 0.001;
res = 1;

tail1OS = [65,0,0];
tail1Scale = [0.6, 0.3, 1];
tail2OS = [50,0,25];
tail2Scale = [0.8, 0.62, 1];
tail3OS = [65,0,50];
tail3Scale = [0.6, 0.3, 1];

gutsOS = [0,0,2];
gutsScale = [1, 0.4, 1];

rodOS = [60,0,tail2OS[2] + gutsOS[2]/2];
rodR = 2.03;
rodL = 9;
rodSkin = 0.8;

module tail2Pos(){
    
    chord_len = 45;
    NACA0024=[[1.0000,0.00252],[0.9500,0.01613],[0.9000,0.02896],[0.8000,0.05247],[0.7000,0.07328],[0.6000,0.09127],[0.5000,0.10588],[0.4000,0.11607],[0.3000,0.12004],[0.2500,0.11883],[0.2000,0.11475],[0.1500,0.10691],[0.1000,0.09365],[0.0750,0.08400],[0.0500,0.07109],[0.0250,0.05229],[0.0125,0.03788],[0.0000,0.00000],[0.0125,-0.03788],[0.0250,-0.05229],[0.0500,-0.07109],[0.0750,-0.08400],[0.1000,-0.09365],[0.1500,-0.10691],[0.2000,-0.11475],[0.2500,-0.11883],[0.3000,-0.12004],[0.4000,-0.11607],[0.5000,-0.10588],[0.6000,-0.09127],[0.7000,-0.07328],[0.8000,-0.05247],[0.9000,-0.02896],[0.9500,-0.01613],[1.0000,-0.00252]];
    hull(){
        translate(tail1OS) scale(tail1Scale) linear_extrude(height = lil) polygon(points=chord_len*NACA0024);
        translate(tail2OS) scale(tail2Scale) linear_extrude(height = lil) polygon(points=chord_len*NACA0024);
    }
    hull(){
        translate(tail2OS) scale(tail2Scale) linear_extrude(height = lil) polygon(points=chord_len*NACA0024);
        translate(tail2OS + gutsOS) scale(tail2Scale) linear_extrude(height = lil) polygon(points=chord_len*NACA0024);
    }
    hull(){
        translate(tail2OS + gutsOS) scale(tail2Scale) linear_extrude(height = lil) polygon(points=chord_len*NACA0024);
        translate(tail3OS + gutsOS) scale(tail3Scale) linear_extrude(height = lil) polygon(points=chord_len*NACA0024);
    }
    
    translate(rodOS) rotate([0,-90,0]) cylinder(r = rodR+rodSkin, h = rodL, $fn = res * 180);
}


module tail2Neg(){
    translate(rodOS + [10,0,0]) rotate([0,-90,0]) cylinder(r = rodR, h = big, $fn = res * 180);
    translate([-big/2 + rodOS[0] - rodL,0,0]) cube(size = big, center = true);
}

difference(){
    tail2Pos();
    tail2Neg();
}
