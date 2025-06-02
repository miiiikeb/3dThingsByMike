include <Tamper_1.1.scad>

module spiralMask(){
    spiralR = 35;
    armCount = 9;
    maskH = 100;
    res = 0.2;

    armA = 15;
    edgeThickness = 0.0;
    
    for (a = [0:armCount - 1]){
        rotate([0,0,a * 360/armCount]) difference(){
            translate([spiralR + 0.01,0,0]) cylinder(h = maskH, r = spiralR, $fn = res * 360);
            translate([-0.01,0,-0.01]) cube(size = [3 * spiralR, 2 * spiralR, 2 * maskH]);
            rotate([0,0,armA])translate([spiralR - edgeThickness + 0.01,0,0]) cylinder(h = maskH, r = spiralR - edgeThickness, $fn = res * 360);
            
        }
    }
}

difference(){
    import("Tamper_3mm.stl", convexity=3);
    spiralMask();
}
