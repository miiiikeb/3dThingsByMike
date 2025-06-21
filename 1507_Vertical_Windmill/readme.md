# Summary

Here's my 'Mk2' Vertical Axis Wind Turbine (VAWT). I've always liked the lines of these, but they really caught my attention a few weeks ago when I realized that I couldn't explain how they work.

I'm now a lot less confused about how a wing works (really good explanation here if you're interested: [How Airfoils Work](http://www.av8n.com/how/htm/airfoils.html)), and I've learned a few new tricks with the printer.

This is my second version, and it can generate a much bigger turbine regardless of the printer that's used; it's a lot more efficient with filament too.

At the moment, I don't have this driving anything, but the plan is to attach a small water pump (printed, of course) to lift water into a gravity feed system.

### Gallery
## 📁 Files Included

The following images are part of the Mk2 Vertical Axis Wind Turbine (VAWT) project:

| Thumbnail | File Name | Description |
|----------|------------|-------------|
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/IMG_0518.JPG" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/IMG_0518.JPG) | `IMG_0518.JPG` | Additional build detail photo |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/IMG_0508.JPG" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/IMG_0508.JPG) | `IMG_0508.JPG` | Photo of the assembled turbine |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/IMG_0510.JPG" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/IMG_0510.JPG) | `IMG_0510.JPG` | Additional build detail photo |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/IMG_0516.JPG" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/IMG_0516.JPG) | `IMG_0516.JPG` | Additional build detail photo |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/JointTest.png" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/JointTest.png) | `JointTest.png` | Tolerance test part preview |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/BearingMount02.01.png" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/BearingMount02.01.png) | `BearingMount02.01.png` | Updated bearing mount rendering |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/mount02.00.png" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/mount02.00.png) | `mount02.00.png` | Mount diagram or render |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/SegNum1-02.png" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/SegNum1-02.png) | `SegNum1-02.png` | Blade segment 1 |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/SegNum2-02.png" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/SegNum2-02.png) | `SegNum2-02.png` | Blade segment 2 |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/SegNum3-02.png" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/SegNum3-02.png) | `SegNum3-02.png` | Blade segment 3 |
| [<img src="https://github.com/miiiikeb/3dThingsByMike/raw/main/1506_Vertical_Windmill/ThreadedMount02.png" width="300"/>](https://github.com/miiiikeb/3dThingsByMike/blob/main/1506_Vertical_Windmill/ThreadedMount02.png) | `ThreadedMount02.png` | Threaded shaft mount for M8 rod |

### Updates

- **Update 1**: I've added a couple of different blade sizes to suit different build volumes. If you're after something different, have a play with the SCAD file, or if that's not your thing, let me know and I can generate some.
- **Update 2**: Well, it's been up for a while now, and I've got a better idea of how it behaves in different winds. It takes a fair bit to get it going, and unless it's really blowing, it doesn't spin too fast. I think the idea of driving something with it was probably a bit hopeful, but as a sculpture, I still quite like it. The next version will probably have a few more blades and a bigger diameter. All this takes is a few different settings in the SCAD file, but I haven't gotten around to it yet.

---

# Changes from Mk1

You can find a copy of my first attempt [here](http://www.thingiverse.com/thing:940911).

1. The blade profile has changed to a **NACA0024**, which is apparently better suited to a VAWT than my "that looks about right" effort.
2. The blades are now **hollow**, reducing filament use and weight, which in turn reduces the centrifugal force. This also eliminates tiny delaminations along the tail seen in Mk1.
3. The blade is now made up of **'n' sections** (3 in this print) that slot together. This allows for longer blades regardless of build area.
4. The first version used pins to align the two halves (didn't work well). This version prints a socket on one side of the join that slots into the hollow section of the other piece.
5. The blade is now connected to the central shaft via **'n' struts** (3 in this case). This arrangement is much stronger than Mk1, where the joint was in the middle of the blade.
6. By removing the base, the windmill's diameter can be as large as the struts allow. Combined with segmented blades, you can create a much larger version.

---

# Ideas for Mk3

- Add a **transverse web** across the widest part of the blade to improve strength without adding much weight.
- Aim for a **solidity ratio** of 88% (i.e., 88% of the space is taken up by the blade). This would mean blades about double the size of this one.
- Develop a way to make the struts printable with a very strong connection to the blade.

[Watch the video here](https://youtu.be/jbJLZhv7Xt8).

---

# Instructions

### Push Fits

There are a few push fits in this design, so it may require tweaking depending on your printer. Print two of the `JointTest` pieces first and check the fit before printing more. If they're not a good fit, the `.SCAD` file is easy to modify. Let me know if you need help.

### Printing

I found that print quality improved when printing three segments at once. A single segment doesn't get enough time for the first layer to cool before adding the second, which affects the large overhang.

### Gluing

For gluing, I used **Loctite super glue (plastic adhesive)**, which created a strong bond with both the plastic and the carbon rods.

### Make It Smooth

A rough finish significantly affects efficiency. Sand the blade to a smooth finish; the more time you spend on this, the better.

### Axle

- For a **straight rod**, it should be a push fit through the mount. Use the cross-hole as a guide to drill a 3mm hole through the rod. Insert a 30mm M3 screw with a matching nut into the recess, or drill a smaller hole and tap the M3 thread directly into the rod.
- For a **threaded rod**, insert an M8 nut into the recess and wind it down the rod. Use another nut to lock it in place.

The best way to assemble it is to set the spacing of the mounts before attaching the blades. Spacings for the 3 versions are:
- 375mm tall = 117.5mm
- 440mm tall = 150mm
- 625mm tall = 222.5mm

### Struts

I used carbon rods cut from an old golf umbrella (150mm long, 3.6mm diameter). Ensure a snug fit with the sockets by printing the `JointTest` piece first. If needed, adjust the SCAD file or drill it out.

**Note**: Be careful with carbon splinters.

Ensure the struts are of equal length to maintain balance. Insert them with the axle already in place and push them in fully to ensure consistent blade offset.

### Bearing Mounts

I printed 2 bearing mounts with 2 roller-blade bearings in each. Use 2xM8 nuts locked against each other above the top mount and below the bottom one to secure them.

The holes are sized for a 10g screw with a 6mm washer.

---

# SCAD

Don't hesitate to tinker with the SCAD file to customize the blade shape or size. Start by adjusting these parameters:
- `plug_os`: Shrink the plug in from the blade's edge.
- `strut_id`: Inner diameter of the strut hole.
- `blade_height`: Overall height.
- `num_segs`: Number of segments (per blade) to print.
- `chord_len`: Blade length in mm.
- `end_os`: Distance from the blade tip for the top & bottom strut sockets.
- `num_sockets`: Total number of strut sockets.ummary
