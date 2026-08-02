# 3dThingsByMike

A collection of original OpenSCAD designs for 3D printing. Each project lives in its
own folder and is independent of the others. Shared library code lives in
`0000_StdLibraries`.

## Setup

Set `OPENSCADPATH` to the root of this repository. Every `include` and `use` in this
repo is written relative to that root, so this is required — without it, includes fail.

```bash
# Linux / macOS — add to ~/.bashrc or ~/.zshrc. Colon-separated; keep any existing entries.
export OPENSCADPATH="$HOME/path/to/3dThingsByMike"
```

```powershell
# Windows — set once as a user environment variable. Semicolon-separated.
setx OPENSCADPATH "C:\path\to\3dThingsByMike"
```

### Use a development snapshot, with the Manifold backend

Release 2021.01 renders these models with CGAL and is slow. A development snapshot
with `--backend=Manifold` (Preferences → Advanced → 3D rendering on the GUI) is
dramatically faster on the same geometry — measured on 2026.08.01:

| Model | CGAL | Manifold | Speed-up |
|---|---|---|---|
| `2508_My_Gridfinity/myBin-kennetek-basic-bin.scad` | 11.5 s | 0.51 s | 23× |
| `2508_My_Gridfinity/ScrewDriverHolder.scad` | 17.4 s | 0.42 s | 41× |
| `2508_My_Gridfinity/gridfinity-rebuilt-bins.scad` | 48.1 s | 0.89 s | 54× |

Manifold also reports mesh validity (`Status`, `Genus`) after each render, which
catches non-manifold geometry before it reaches the slicer.

### Windows plus WSL

The Windows build **cannot open files on the WSL filesystem.** Given a
`\\wsl.localhost\...` path it rewrites it to a broken relative form, fails to resolve
`OPENSCADPATH`, then aborts with `filesystem error: cannot set current path`. If you
use the Windows GUI, keep the repository on a drive letter (`C:\...`) and reach it from
WSL via `/mnt/c/...` — not the other way round.

Note also that a development snapshot resolves a relative `-o` output path against the
**input file's** directory, not the current directory. Pass an absolute output path in
scripts.

Then clone and open any `.scad` file directly:

```bash
git clone https://github.com/miiiikeb/3dThingsByMike.git
cd 3dThingsByMike
git submodule update --init      # optional: downloads/ only, see below
```

Libraries are committed as plain files, so a plain clone is enough to render every
design. The only submodule is `downloads/`, which is a **private** repository — the
clone will prompt for credentials if you ask for it, and skipping it affects nothing
else.

## Project index

| Project | Description |
|---|---|
| [2510_GH_Surround](./2510_GH_Surround/) | Motor controller surround for GoodHope. |
| [2510_Callisson_Mold](./2510_Callisson_Mold/) | Mould for callisson sweets. |
| [2508_My_Gridfinity](./2508_My_Gridfinity/) | Gridfinity bins — gauge holder, screwdriver holder, and templates. |
| [2505_N30_Pro_Cover](./2505_N30_Pro_Cover/) | Protective cover for the 8BitDo N30 Pro controller. |
| [2504_Throttle_Cover](./2504_Throttle_Cover/) | B700 throttle cover for GoodHope's throttle controllers. |
| [2403_SailBattenStay](./2403_SailBattenStay/) | Sail batten stay. |
| [2402_ILF_Shims](./2402_ILF_Shims/) | ILF recurve bow shims. |
| [2308_12V_Surround](./2308_12V_Surround/) | 12V socket surround, surface mount. |
| [2302_GH_Trampoline_Mushroom](./2302_GH_Trampoline_Mushroom/) | Catamaran trampoline lacing posts for GoodHope. |
| [2207_GH_Blind_Hose_Clamp](./2207_GH_Blind_Hose_Clamp/) | Wastewater hose clamp for GoodHope. |
| [2204_Vane_Stripper](./2204_Vane_Stripper/) | Vane stripper for arrow fletching. |
| [2204_Bitzenburger_Adapter](./2204_Bitzenburger_Adapter/) | Adapter for a Bitzenburger fletching jig. |
| [2107_Super_Dipper](./2107_Super_Dipper/) | Super Dipper — coupler, drain, frame, hanger and spacer. |
| [2005_Whistling_Arrow](./2005_Whistling_Arrow/) | Whistling arrow head. |
| [2005_Arrow_TaperTool_Socket](./2005_Arrow_TaperTool_Socket/) | Socket for an arrow taper tool. |
| [2005_Arrow_Squarer_Remix](./2005_Arrow_Squarer_Remix/) | Arrow squaring jig (remix). |
| [2003_Windy](./2003_Windy/) | Wind indicator for a dinghy, using 4 mm rod and pivoted parts. |
| [1601_Coffee_Set](./1601_Coffee_Set/) | Espresso set with stand, funnel and tamper. |
| [1507_Vertical_Windmill](./1507_Vertical_Windmill/) | Vertical windmill — kinetic sculpture more than functional. |
| [1501_PoolVacuum](./1501_PoolVacuum/) | Pool vacuum head. |

## Libraries

`0000_StdLibraries` is split along a single line: code I own, and code I consume.

| Folder | Contents | Rule |
|---|---|---|
| [`mine/`](./0000_StdLibraries/mine/) | `mbLib.scad`, `Arc_Module_2.scad`, `patterns.scad` | Edit freely. |
| [`vendor/`](./0000_StdLibraries/vendor/) | BOSL2, gridfinity-rebuilt, gridfinity-jamie | **Never edited.** Provenance in [`vendor/MANIFEST.md`](./0000_StdLibraries/vendor/MANIFEST.md). |

If a vendored library lacks something, add it to `mine/` and include both — do not
edit anything under `vendor/`. Editing a vendored file turns the next update into a
merge instead of a drop-in. `mine/patterns.scad` exists for exactly this reason: it
carries `pattern_linear` and `pattern_circular`, which upstream gridfinity removed.

Updating a vendored library is documented in `vendor/MANIFEST.md`.

## Tools used

- [OpenSCAD](https://openscad.org/) — developed against 2021.01; newer development
  snapshots render considerably faster.
- [BOSL2](https://github.com/BelfrySCAD/BOSL2)
- [gridfinity-rebuilt](https://github.com/kennetek/gridfinity-rebuilt-openscad)
- [gridfinity_openscad](https://github.com/vector76/gridfinity_openscad)

## Licence

No licence file is currently present in this repository, so no licence is granted by
default. Individual projects state their own terms where applicable — for example
`2505_N30_Pro_Cover` is documented as CC BY-NC 4.0. Add a root `LICENSE` file to make
the position explicit.
