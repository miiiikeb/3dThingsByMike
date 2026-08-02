/**
 * Linear and circular pattern helpers.
 *
 * Origin: kennetek/gridfinity-rebuilt-openscad, src/helpers/generic-helpers.scad,
 * as at commit 5906ee0d (28 April 2025). Both modules were removed upstream by
 * the "Gridfinity rebuilt 2" rewrite merged 31 August 2025, so they are kept
 * here rather than relied on from the vendored tree.
 *
 * Kept in mine/ for two reasons: the designs in this repo call pattern_linear
 * directly, and OpenSCAD's `use <>` does not re-export modules that the used
 * file itself only `use`s. Including this file in a design gives it the modules
 * without any edit to anything under vendor/.
 */

// Repeat children on an x by y grid, spaced sx and sy apart and centred on the
// origin. sy defaults to sx, giving square spacing.
module pattern_linear(x = 1, y = 1, sx = 0, sy = 0) {
    yy = sy <= 0 ? sx : sy;
    translate([-(x-1)*sx/2, -(y-1)*yy/2, 0])
    for (i = [1:ceil(x)])
    for (j = [1:ceil(y)])
    translate([(i-1)*sx, (j-1)*yy, 0])
    children();
}

// Repeat children n times, evenly spaced around the z axis.
module pattern_circular(n = 2) {
    for (i = [1:n])
    rotate(i*360/n)
    children();
}
