# Vendored libraries

Third-party code, vendored verbatim. **Nothing in `vendor/` is ever edited.**

If a library lacks something, add it to `0000_StdLibraries/mine/` and include both.
If the change must live inside the library, send it upstream as a pull request.
Editing a file here means the next update becomes a merge instead of a drop-in,
which is the situation this layout exists to prevent.

To update a library: delete its folder, drop in the new upstream tree, re-apply
any exclusion noted below, update the row here, re-render every consuming design,
and commit as a single `vendor <name> at <revision>` commit.

## BOSL2

| | |
|---|---|
| Upstream | https://github.com/BelfrySCAD/BOSL2 |
| Revision | v2.0.716 (`BOSL_VERSION = [2,0,716]` in `version.scad`) |
| Vendored | Revision recorded 02 August 2026; original vendoring date unknown |
| Exclusions | None — full tree |

Consumed by `2308_12V_Surround`, `2403_SailBattenStay`, `2505_N30_Pro_Cover`,
`2508_My_Gridfinity`.

Previously declared as a git submodule in `.gitmodules` at the path
`0000_StdLibraries/StdLibraries/BOSL2`, which never existed. The library has
always been plain committed files. That orphaned declaration has been removed.

## gridfinity-rebuilt

| | |
|---|---|
| Upstream | https://github.com/kennetek/gridfinity-rebuilt-openscad |
| Revision | `5906ee0d0af4b80bc1d4f7e2b43310a41d2ee328` — "Tab style inconsistency fixed", 28 April 2025 |
| Vendored | 02 August 2026 |
| Exclusions | `docs/` and `images/` removed — 14.4 MB of documentation GIFs, versus 220 KB for the code. Read them upstream. |

Consumed by `2508_My_Gridfinity`.

**Deliberately pinned behind upstream.** On 31 August 2025 upstream merged PR #305,
"Gridfinity rebuilt 2", which restructured `src/core/` and removed `pattern_linear`
and `pattern_circular` entirely. The designs in this repo call `pattern_linear`, and
the rewrite also changes bin geometry. Moving to current upstream is a deliberate
follow-up that needs each design re-rendered and eyeballed, not a routine bump.

This revision replaces three divergent copies that previously coexisted: a
hand-edited older vintage at `Gridfinity/kennetek/`, and a submodule pointing at
`miiiikeb/gridfinity-rebuilt-openscad` — a fork whose only purpose was to
re-declare `pattern_linear` so it survived an OpenSCAD `use <>` scope boundary.
That fork is no longer referenced; `mine/patterns.scad` does the same job without
touching vendored code.

## gridfinity-jamie

| | |
|---|---|
| Upstream | https://github.com/vector76/gridfinity_openscad (Jamie's Gridfinity OpenSCAD Model) |
| Revision | **Unknown** — vendored without provenance before this manifest existed |
| Vendored | Date unknown; folder was `Gridfinity/jamie/` |
| Exclusions | Unknown; the folder holds 7 `.scad` files and may be a partial copy |

Consumed by `2508_My_Gridfinity/myBin-jamie.scad` only.

Identified by module naming (`grid_block`, `gridfinity_pitch`) rather than by any
marker in the files themselves. Before relying on this further, re-vendor a known
revision from upstream and record it here. If `myBin-jamie.scad` is no longer
wanted, drop both the design and this library.
