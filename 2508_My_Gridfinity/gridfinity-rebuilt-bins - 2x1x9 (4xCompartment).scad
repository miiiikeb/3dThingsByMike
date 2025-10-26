// ===== INFORMATION ===== //
/*
 IMPORTANT: Rendering will be better in development builds and not the official release of OpenSCAD, but it makes rendering only take a couple of seconds, even for comically large bins.
 The magnet holes can have an extra cut in them to make it easier to print without supports
 . Tabs will automatically be disabled when gridz is less than 3, as the tabs take up too much space
 . Base functions can be found in "gridfinity-rebuilt-utility.scad"
 Comments like ' //.5' after variables are intentional and used by the customizer
 examples at the end of the file

 #BIN HEIGHT
 The original Gridfinity bins had the overall height defined by 7mm increments.
 A bin would be 7*u millimetres tall with a stacking lip at the top of the bin (4.4mm) added onto this height.
 The stock bins have unit heights of 2, 3, and 6:
 * Z unit 2 -> 7*2 + 4.4 -> 18.4mm
 * Z unit 3 -> 7*3 + 4.4 -> 25.4mm
 * Z unit 6 -> 7*6 + 4.4 -> 46.4mm

 ## Note:
 The stacking lip provided here has a 0.6mm fillet instead of coming to a sharp point.
 Which has a height of 3.55147mm instead of the specified 4.4mm.
 This **has no impact on stacking height and can be ignored.**

https://github.com/kennetek/gridfinity-rebuilt-openscad

*/

include <src/core/standard.scad>
use <src/core/gridfinity-rebuilt-utility.scad>
use <src/core/gridfinity-rebuilt-holes.scad>

// ===== PARAMETERS ===== //

/* [Setup Parameters] */
$fa = 8;
$fs = 0.25; // .01

/* [General Settings] */
// number of bases along x-axis
gridx = 2;
// number of bases along y-axis
gridy = 1;
// bin height. See bin height information and "gridz_define" below.
gridz = 9; //.1
// Half grid-sized bins.  Implies "only corners".
half_grid = false;

/* [Linear Compartments] */
// number of X Divisions (set to zero to have a solid bin)
divx = 4;
// number of Y Divisions (set to zero to have solid bin)
divy = 1;

/* [Cylindrical Compartments] */
// number of cylindrical X Divisions (mutually exclusive to Linear Compartments)
cdivx = 0;
// number of cylindrical Y Divisions (mutually exclusive to Linear Compartments)
cdivy = 0;
// orientation
c_orientation = 2; // [0: x direction, 1: y direction, 2: z direction]
// diameter of cylindrical cutouts
cd = 10; // .1
// cylinder height
ch = 1;  //.1
// spacing to lid
c_depth = 1;
// chamfer around the top rim of the holes
c_chamfer = 0.5; // .1

/* [Height] */
//Determine what the variable "gridz" applies to based on your use case
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimetres, 2:gridz is the overall external height of the bin in millimetres]
// overrides internal block height of bin (for solid containers). Leave zero for the default height. Units: mm
height_internal = 0;
// snap gridz height to nearest 7mm increment
enable_zsnap = false;

/* [Features] */
// the type of tabs
style_tab = 5; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]
//Which divisions have tabs
place_tab = 0; // [0:Everywhere-Normal,1:Top-Left Division]
//How should the top lip act
style_lip = 0; //[0: Regular lip, 1:remove lip subtractively, 2: remove lip and retain height]
// scoop weight percentage. 0 disables scoop, 1 is regular scoop. Any real number will scale the scope.
scoop = 0.5; //[0:0.1:1]

/* [Base Hole Options] */
// only cut magnet/screw holes at the corners of the bin to save unnecessary print time
only_corners = false;
//Use gridfinity refined hole style. Not compatible with magnet_holes!
refined_holes = false;
// Base will have holes for 6mm Diameter x 2mm high magnets.
magnet_holes = false;
// Base will have holes for M3 screws.
screw_holes = true;
// Magnet holes will have crush ribs to hold the magnet.
crush_ribs = false;
// Magnet/Screw holes will have a chamfer to ease insertion.
chamfer_holes = false;
// Magnet/Screw holes will be printed, so supports are not needed.
printable_hole_top = false;
// Enable "gridfinity-refined" thumbscrew hole in the centre of each base: https://www.printables.com/model/413761-gridfinity-refined
enable_thumbscrew = false;

hole_options = bundle_hole_options(refined_holes, magnet_holes, screw_holes, crush_ribs, chamfer_holes, printable_hole_top);
grid_dimensions = GRID_DIMENSIONS_MM / (half_grid ? 2 : 1);

// ===== IMPLEMENTATION ===== //

//Basic Bin//
gridfinityInit(gridx, gridy, height(gridz, gridz_define, style_lip, enable_zsnap), height_internal, grid_dimensions=grid_dimensions, sl=style_lip) {

    if (divx > 0 && divy > 0) {

        cutEqual(n_divx = divx, n_divy = divy, style_tab = style_tab, scoop_weight = scoop, place_tab = place_tab);

    } else if (cdivx > 0 && cdivy > 0) {

        cutCylinders(n_divx=cdivx, n_divy=cdivy, cylinder_diameter=cd, cylinder_height=ch, coutout_depth=c_depth, orientation=c_orientation, chamfer=c_chamfer);
    }
}

gridfinityBase([gridx, gridy], grid_dimensions=grid_dimensions, hole_options=hole_options, only_corners=only_corners || half_grid, thumbscrew=enable_thumbscrew);

//Gauge Holder//
/*
gridfinityInit(gridx, gridy, height(gridz, gridz_define, style_lip, enable_zsnap), height_internal, grid_dimensions=grid_dimensions, sl=style_lip) {

    cut_move(x=0, y=0, w=2/3, h=1) 
        cube(size = [1.8, 22,1000], center = true);
    cut_move(x=1/3, y=0, w=2/3, h=2) 
        cube(size = [7.8, 79,1000], center = true);
    cut_move(x=0, y=1, w=2/3, h=1)
        translate([0,0,-35]) union(){
            cylinder(h = 5,r1 = 0.5, r2 = 7/2, center = false);
            translate([0,0,5]) cylinder(h = 100, r = 7/2,center=false);
        }
//    cut_move(x=0, y=0, w=2/3, h=1)
//        pattern_linear(x=1, y=2, sx= (42/2.5)) 
//            cylinder(r=5.5, h=1000, center=true);    
//    cut_move(x=2, y=1, w=1, h=2)
//        pattern_linear(x=1, y=3, sx=42/2)
//            cylinder(r=5, h=1000, center=true);
    //cutEqual(n_divx = 2, n_divy = 1, style_tab = style_tab, scoop_weight = scoop, place_tab = place_tab);

    //cutCylinders(n_divx=3, n_divy=3, cylinder_diameter=cd, cylinder_height=ch, coutout_depth=c_depth, orientation=c_orientation, chamfer=c_chamfer);
    
}
gridfinityBase([gridx, gridy], grid_dimensions=grid_dimensions, hole_options=hole_options, only_corners=only_corners || half_grid, thumbscrew=enable_thumbscrew);
*/

//color("tomato") {
/*
gridfinityInit(gridx, gridy, height(gridz, gridz_define, style_lip, enable_zsnap), height_internal, grid_dimensions=grid_dimensions, sl=style_lip) {

    if (divx > 0 && divy > 0) {

        cutEqual(n_divx = divx, n_divy = divy, style_tab = style_tab, scoop_weight = scoop, place_tab = place_tab);

    } else if (cdivx > 0 && cdivy > 0) {

        cutCylinders(n_divx=cdivx, n_divy=cdivy, cylinder_diameter=cd, cylinder_height=ch, coutout_depth=c_depth, orientation=c_orientation, chamfer=c_chamfer);
    }
}
gridfinityBase([gridx, gridy], grid_dimensions=grid_dimensions, hole_options=hole_options, only_corners=only_corners || half_grid, thumbscrew=enable_thumbscrew);
//}
*/

// ===== EXAMPLES ===== //

// 3x3 even spaced grid
/*
gridfinityInit(3, 3, height(6), 0, 42) {
	cutEqual(n_divx = 3, n_divy = 3, style_tab = 0, scoop_weight = 0);
}
gridfinityBase([3, 3]);
*/

// Compartments can be placed anywhere (this includes non-integer positions like 1/2 or 1/3). The grid is defined as (0,0) being the bottom left corner of the bin, with each unit being one base long. Each cut() module is a compartment, with the first four values defining the area that should be made into a compartment (X coord, Y coord, width, and height). These values should all be positive. t is the tab style of the compartment (0:full, 1:auto, 2:left, 3:center, 4:right, 5:none). It is a toggle for the bottom scoop.
/*
gridfinityInit(3, 3, height(6), 0, 42) {
    cut(x=0, y=0, w=1.5, h=0.5, t=5, s=0);
    cut(0, 0.5, 1.5, 0.5, 5, 0);
    cut(0, 1, 1.5, 0.5, 5, 0);

    cut(0,1.5,0.5,1.5,5,0);
    cut(0.5,1.5,0.5,1.5,5,0);
    cut(1,1.5,0.5,1.5,5,0);

    cut(1.5, 0, 1.5, 5/3, 2);
    cut(1.5, 5/3, 1.5, 4/3, 4);
}
gridfinityBase([3, 3]);
*/

// Compartments can overlap! This allows for weirdly shaped compartments, such as this "2" bin.
/*
gridfinityInit(3, 3, height(6), 0)  {
    cut(0,2,2,1,5,0);
    cut(1,0,1,3,5);
    cut(1,0,2,1,5);
    cut(0,0,1,2);
    cut(2,1,1,2);
}
gridfinityBase(3, 3, 42, 0, 0, 1);
*/

// Areas without a compartment are solid material, where you can put your own cutout shapes. Using the cut_move() function, you can select an area, and any child shapes will be moved from the origin to the centre of that area, and subtracted from the block. For example, a pattern of three circularion, you can select an area, and any child shapes will be moved from the origin to the center of that area, and subtracted from the block. For example, a pattern of three cylinderical holes.
/*
gridfinityInit(3, 3, height(6), 0, 42) {
    cut(x=0, y=0, w=2, h=3);
    cut(x=0, y=0, w=3, h=1, t=5);
    cut_move(x=2, y=1, w=1, h=2)
        pattern_linear(x=1, y=3, sx=42/2)
            cylinder(r=5, h=1000, center=true);
}
gridfinityBase([3, 3]);
*/

// You can use loops as well as the bin dimensions to make different parametric functions, such as this one, which divides the box into columns, with a small 1x1 top compartment and a long vertical compartment below
/*
gx = 3;
gy = 3;
gridfinityInit(gx, gy, height(6), 0, 42) {
    for(i=[0:gx-1]) {
        cut(i,0,1,gx-1);
        cut(i,gx-1,1,1);
    }
}
gridfinityBase([gx, gy]);
*/

// Pyramid scheme bin
/*
gx = 4;
gy = 4;
gridfinityInit(gx, gy, height(6), 0, 42) {
    for (i = [0:gx-1])
    for (j = [0:i])
    cut(j*gx/(i+1),gy-i-1,gx/(i+1),1,0);
}
gridfinityBase([gx, gy]);
*/
