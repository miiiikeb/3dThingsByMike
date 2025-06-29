pegD = 2.4;

for(a = [0,120,240]){
    rotate([a,0,0]) cube(size = [5,2 * (pegD / 2) * tan(30), pegD], center = true);
}
