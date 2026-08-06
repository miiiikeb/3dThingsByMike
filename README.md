# 3dThingsByMike

A collection of original OpenSCAD designs for 3D printing. Each project lives in its
own folder and is independent of the others. Shared library code lives in
`0000_StdLibraries`.

## Setting up a new OpenSCAD instance

Four steps: install a development snapshot, clone this repo, point `OPENSCADPATH` at
it, verify. Step 3 is not optional — every `include` and `use` in this repo is written
relative to the repo root, so without it every design fails to find its libraries.

### 1. Install a development snapshot, not the release

Use a snapshot rather than release 2021.01. The snapshot defaults to the Manifold
geometry engine; 2021.01 only has CGAL. On the models in this repo, measured on
snapshot 2026.08.01:

| Model | CGAL | Manifold |
|---|---|---|
| `2508_My_Gridfinity/myBin-kennetek-basic-bin.scad` | 11.5 s | 0.51 s |
| `2508_My_Gridfinity/ScrewDriverHolder.scad` | 17.4 s | 0.42 s |
| `2508_My_Gridfinity/gridfinity-rebuilt-bins.scad` | 48.1 s | 0.89 s |

Snapshots install alongside the release rather than replacing it, so an existing
2021.01 can stay put.

**Windows.** Download the snapshot installer from the [downloads
page](https://openscad.org/downloads.html) and run it. It lands in
`C:\Program Files\OpenSCAD (Nightly)\` with two binaries: `openscad.exe` for the GUI
and `openscad.com` for the command line.

**Linux.** Any of:

```bash
sudo snap install openscad-nightly            # simplest

# or a portable AppImage — no install, no root
#   grab the newest from https://files.openscad.org/snapshots/
chmod +x OpenSCAD-*.AppImage && ./OpenSCAD-*.AppImage
```

There is also an OpenSCAD apt repository providing an `openscad-nightly` package that
coexists with the distro release. It needs both a signing key and a source line, and
the source line is distro-specific — take the current pair from the [downloads
page](https://openscad.org/downloads.html) rather than copying one from here.

Note that distro packages named plain `openscad` are usually 2021.01. Check with
`openscad --version` before assuming which one you have.

### 2. Clone the repository

```bash
git clone git@github.com:miiiikeb/3dThingsByMike.git
cd 3dThingsByMike
git submodule update --init      # optional, see below
```

Libraries are committed as plain files, so a plain clone renders every design with no
submodule step. The only submodule is `downloads/`, a **private** repository — it will
ask for credentials, and skipping it affects nothing else.

### 3. Point OPENSCADPATH at the repo root

**Windows.** Set it as a user environment variable. Prefer PowerShell over `setx`,
which is easy to get wrong — quoting mistakes silently embed the quote characters in
the value, and OpenSCAD then looks for a directory whose name contains them:

```powershell
[Environment]::SetEnvironmentVariable("OPENSCADPATH", "C:\path\to\3dThingsByMike", "User")

# check it: should print the path in brackets with no stray quotes, then True
$v = [Environment]::GetEnvironmentVariable("OPENSCADPATH","User"); "[$v]"; Test-Path $v
```

**Linux / macOS.** Add to `~/.bashrc` or `~/.zshrc`:

```bash
export OPENSCADPATH="$HOME/path/to/3dThingsByMike"
```

Multiple roots are separated by `;` on Windows and `:` on Linux and macOS. Keep any
existing entries.

**Restart both the terminal and OpenSCAD.** Neither picks up the change in an
already-running process.

### 4. Verify

From the repo root, render a design that pulls in both a vendored library and
`mine/patterns.scad`:

```bash
# Linux / macOS
openscad -o /tmp/check.stl 2508_My_Gridfinity/myBin-kennetek-basic-bin.scad
```

```bat
:: Windows — use openscad.com for console output, and an absolute -o path
"C:\Program Files\OpenSCAD (Nightly)\openscad.com" -o %TEMP%\check.stl 2508_My_Gridfinity\myBin-kennetek-basic-bin.scad
```

It must complete with **no `WARNING: Can't find include file`** lines — that warning is
the signature of step 3 not having taken effect, usually because the process was started
before the variable was set. On a snapshot this takes well under a second and ends with
`Status: NoError`; on 2021.01 expect roughly ten seconds and CGAL's `Simple: yes`
summary instead.

Three files in `1601_Coffee_Set` fail to parse — `CoffeeSet_0.2.scad`, `Funnel_1.0.scad`
and `Stem_0.1.scad`. Those are known pre-existing syntax errors, not a setup problem.

### Windows plus WSL

The Windows build **cannot open files on the WSL filesystem.** Given a
`\\wsl.localhost\...` path it rewrites it to a broken relative form, fails to resolve
`OPENSCADPATH`, then aborts with `filesystem error: cannot set current path`. If you
use the Windows GUI, keep the repository on a drive letter (`C:\...`) and reach it from
WSL via `/mnt/c/...` — not the other way round. A single clone on `C:` serves both.

Also, a snapshot resolves a relative `-o` output path against the **input file's**
directory, not the current directory. Pass an absolute output path in scripts.

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
