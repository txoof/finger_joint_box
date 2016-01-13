/*
  Box with fingerjoints - Based on earlier version of Finger Joint Box
  http://www.thingiverse.com/thing:448592
  Aaron Ciuffo
  24 December 2015 

  Added nuts_and_bolts.scad library to make this work on the thingiverse
*/

/* [Box Dimensions] */
// box width
customX = 100;
// box depth
customY = 80;
// box height
customZ = 75;
// finger widths (must be < 1/3 length of shortest box dimension)
customFinger = 15;
// box material thickness
customMaterial = 2.5;
// bolt length
customBolt = 10; //[6, 10, 12, 15, 20]

/* [Display] */
customDisplay = 0; // [1: 2D for DXF, 0: 3D for Display]
customTransparency = 40; //[0:90]


/* [Hidden] */
customS = [customX, customY, customZ]; // custom size array
o = 0.001; // overage for making complete cuts at edges
cAlpha = (100-customTransparency)/100; // convert integer to real for alpha

fingerBox(size = customS, material =  customMaterial, finger = customFinger, 
  lidFinger = customFinger, 2D = customDisplay, bolt = customBolt, alpha = cAlpha);

cF = customFinger;
if ( cF > customX/3 || cF > customY/3 || cF > customZ/3) {
  translate([0, -customY*2/3, 0])
    color("red")
    text("Error! customFinger must be less than 1/3 of shortest side", halign = "center");
}

