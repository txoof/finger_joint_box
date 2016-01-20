======start documentation
  Box with fingerjoints - Based on earlier version of Finger Joint Box
  http://www.thingiverse.com/thing:448592
  Aaron Ciuffo
  24 December 2015 

This .SCAD file creates a customizable box that is secured with m3 [T-Slot](http://xy-kao.com/sandbox/laser-cut-project-boxes/) joints.  The scad file can be used to generate a 2D DXF file that is usable on a laser cutter or 3D printable plates.  To export a DXF use File > Export as DXF

**Please note!** The 2D customizer version is just for display. The customizer app chokes on 2 dimensional objects; if you want to produce a DXF for laser cutting you **MUST** do this from OpenSCAD following the instructions above.

To make this thing customizable on Thingiverse, my nuts_and_bolts library is baked in.  Grab the non-thingiverse version of the .SCAD file for a cleaner version.
Get the latest version from github:
https://github.com/txoof/finger_joint_box

#### Usage:
 ##### tSlotBox(size = [X, Y, Z], material =  N, finger = N, lidFinger = N, layout = "layout tpe", bolt = N, alpha = R);
  * size = [X, Y, Z] - X, Y, Z dimensions in mm
  * material = N - material thickness
  * finger = N - number of fingers
  * lidFinger = N - this should be set to the same value as finger (
  * layout = "layout type" - 2D (for DXF output), 3D (3D model for visualisation, flat - 3D printable flat version
  * bolt = N - length of bolt
  * alpha = R - real between 0 and 1 to adjust the transparency

Create a customized box with dimensions 100, 70, 65 and fingers every 20 mm from 3mm thick material and secured with 15mm bolts:
```
tSlotBox(size = [100, 70, 65], material = 3, finger = 20, lidFinger = 20, bolt = 15, layout = "3D");
```

Create a customized box with dimensions 100, 100, 100 and fingers every 33 mm from 8 mm material and secured with 20 mm bolts ready to be laser cut:
```
tSlotbox(size = [100, 100, 100], material = 8, finger = 33, lidFinger = 33, bolt = 20, layout = "2D");
```



#### To Do:
  * write each face as separate module (front, back, left, etc.) to make modifications simpler 
  * remove lidFinger 



#### Thanks to: 
  * Floppykiller for finding a bugs - http://www.thingiverse.com/Floppykiller/about
    - problem in tab extension 
    - problem in tSlot movement with material thickness
    - problem in bolt-hole placement

=====end documentation
