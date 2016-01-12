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
customY = 100;
// box height
customZ = 100;
// finger widths (must be < 1/3 length of shortest box dimension)
customFinger = 15;
// box material thickness
customMaterial = 4;
// bolt length
customBolt = 11; //[6, 10, 12, 15, 20]

/* [Display] */
customDisplay = 1; // [1: 2D for DXF, 0: 3D for Display]
customTransparency = 0; //[0:90]


/* [Hidden] */
o = 0.001; // overage for making complete cuts at edges
cAlpha = (100-customTransparency)/100;


/*
  Aaron Ciuffo
  Released under GPL V3


  Metric nut and bolt sizes based on 
  http://www.roymech.co.uk/Useful_Tables/Screws/Hex_Screws.htm
  http://www.numberfactory.com/nf%20metric%20screws%20and%20bolts.htm
  http://www.csgnetwork.com/screwsochdcaptable.html

  NOTE: OpenSCAD 2015.03-2 crashes *HARD* if the called m bolt size does not exist due
  to a bug in the lookup() function. A bug report has been filed and should be fixed
  in the next release:
  https://github.com/openscad/openscad/issues/1528

  TODO:
  X Add circular releif cuts in corners of tSlot to prevent cracking in acrylic
  * fix tSlot - 3D version is a mess

  Usage:
  mBolt(
    size = mX, // defined m bolt size (default: m3) 
    len = N, // length of bolt shaft (default: 10)
    center = true/false, // center the shaft (not including the head) (default: true)
    style = "socket"/"hex" // default is socket drive (default: socket)
    tolerance = N // positve or negative number to add to the shaft diameter (def: 0)
    v = true/false // add verbose output to help with debuging and use
  );

  mBolt2D(
    size = m3, len = 10, center = true, tolerance = 0, v = false)
    size = mX, // defined m bolt size (default: m3) 
    center = true/false, // center the shaft (not including the head) (default: true)
    tolerance = N // positve or negative number to add to the shaft diameter (def: 0)
    v = true/false // add verbose output to help with debuging and use


  mNut(
    size = mX, // defined m bolt size (default: m3)
    center = true/false // center the nut (default: true)
    tolerance = N // positive or negative number to add to the hole and body diameter
    v = true/false // add verbose output to help with debuging and use
  );

  mNut2D(
    size = mX, // defined m bolt size (default: m3)
    center = true/false // center the nut (default: true)
    tolerance = N // positive or negative number to add to the hole and body diameter
    v = true/false // add verbose output to help with debuging and use
  );

  mWasher(
    size = mX, // defined m bolt size (default: m3)
    tolerance = N // positive or negative number to add to the inner and outer diameter
    v = true/false // add verbose output to help with debuging and use
  );
  
  mWasher(
    size = mX, // defined m bolt size (default: m3)
    tolerance = N // positive or negative number to add to the inner and outer diameter
    v = true/false // add verbose output to help with debuging and use
  );

  This module creates a t-shaped slot for making perpendicular joints in laser cut
  objects. By default the bolt slot is 0.5mm larger than the distance across the 
  nut FLATS. This shold make it easy to slot in a nut, but it should not be able
  to spin to make tightening easier.

  // create a tSlot using 3D elements 
  tSlot(
    size = mX, // defined m bolt size (default: m3)
    material = N, // thickness of material in mm (default: 3)
    len = N, // total length of bolt to be used (default: 15)
    tolerence = N // positive or negative number to add to the bolt size (def 0.5)
    v = true/false // add verbose output to help with debuging and use
    node = true/false // add nodes to relieve strain and prevent cracking (def: true)
);

  // create a tSlot using 2D elements for working with 2D shpaes
  tSlot2D(
    size = mX, // defined m bolt size (default: m3)
    material = N, // thickness of material in mm (default: 3)
    len = N, // total length of bolt to be used (default: 15)
    tolerence = N, // positive or negative number to add to the bolt size (def: 0.5)
    v = true/false, // add verbose output to help with debuging and use (def: true)
    node = R // positve real < 1; add nodes to relieve strain, cracking (def: 0.15)
  );
  

  This module creates a bolt and nut pair that fits into a tSlot for checking 
  alignment in a working model.  
  tSlotFit(
    size = mX, // defined m bolt size (default: m3)
    material = N, // thickness of material in mm (default: 3)
    len = N, // total length of bolt to be used (default: 15)
    tolerence = N, // positive or negative number to add to the bolt size (def: 0.5)
    v = true/false, // add verbose output to help with debuging and use (def: true)
    style = "socket"/"hex" // socke
  );

*/


/* 
  Add additional M sizes in the section below
  Fastner Dimensions:
  mX = [
    [boltDia, D], // D = bolt shaft diameter
    [headHexThick, T], // T = thickness of head
    [boltNut, N], // N = width across flats, wrench size for bolt head or nut
    [boltNutMax, M], // M = maximum width of bolt head or nut
    [nutThick, Q] // Q = nutThickness
    [washerDia, W], // W = external diameter of washer
    [washerThick, E] // E = washer thickness
    [socketHeadThick, H], // H = thickness of hex socket head
    [socketDia, S], // S = diameter hex socket head
    [socketSize, Z] // Z = socket wrench size
  ];

  BLANK 

  mX = [
    [boltDia, ],
    [headHexThick, ],
    [boltNut, ],
    [boltNutMax, ], 
    [nutThick, ],
    [washerDia, ],
    [washerThick, ],
    [socketHeadThick, ],
    [socketDia, ],
    [socketSize, ]
  ];
*/


/* [Hidden] */
// This is a bit of an abuse of the lookup() function; the temporary values
// need to be the *actual* values used in at least one of the defined sets
// values for lookup function
boltDia =  3;
headHexThick = 2;
boltNut = 5.5;
boltNutMax = 6.4; 
nutThick = 2.4;
washerDia = 7;
washerThick = 0.5;
socketHeadThick = 3;
socketDia = 5.5;
socketSize = 2.5;



// Meric Fastner Sizes
m2 = [
  [boltDia, 2],
  [headHexThick, 2],
  [boltNut, 4],
  [boltNutMax, 4.6], 
  [nutThick, 1.2], 
  [washerDia, 5.5],
  [washerThick, 0.3],
  [socketHeadThick, 2],
  [socketDia, 3.5],
  [socketSize, 1.5]
];

m3 = [
  [boltDia, 3],
  [headHexThick, 2],
  [boltNut, 5.5],
  [boltNutMax, 6.4], 
  [nutThick, 2.4], 
  [washerDia, 7],
  [washerThick, 0.5],
  [socketHeadThick, 3],
  [socketDia, 5.5],
  [socketSize, 2.5]
];

m4 = [
  [boltDia, 4],
  [headHexThick, 4],
  [boltNut, 7],
  [boltNutMax, 8.1],
  [nutThick, 3.2], 
  [washerDia, 9],
  [washerThick, 0.8],
  [socketHeadThick, 4],
  [socketDia, 7],
  [socketSize, 3]
];

m6 = [
  [boltDia, 6],
  [headHexThick, 4],
  [boltNut, 10],
  [boltNutMax, 11.5],  
  [nutThick, 5], 
  [washerDia, 12],
  [washerThick, 1.6],
  [socketHeadThick, 6],
  [socketDia, 10],
  [socketSize, 5]
];

m8 = [
  [boltDia, 8],
  [headHexThick, 5.5],
  [boltNut, 13],
  [boltNutMax, 15], 
  [nutThick, 6.5], 
  [washerDia, 17],
  [washerThick, 2],
  [socketHeadThick, 8],
  [socketDia, 13],
  [socketSize, 6]
];

m10 = [
  [boltDia, 10],
  [headHexThick, 7],
  [boltNut, 17],
  [boltNutMax, 19.6],
  [nutThick, 8], 
  [washerDia, 21],
  [washerThick, 2],
  [socketHeadThick, ],
  [socketDia, 16],
  [socketSize, 8]
];

m12 = [
  [boltDia, 12],
  [headHexThick, 8],
  [boltNut, 19],
  [boltNutMax, 22.1],
  [nutThick, 9.5], 
  [washerDia, 24],
  [washerThick, 2.5],
  [socketHeadThick, 12],
  [socketDia, 18],
  [socketSize, 10]
];

types = [m2, m3, m4, m6, m8, m10, m12];

//Type of M series fastner
typeMeta = 1; //[0:m2,1:m3,2:m4,3:m6,4:m8,5:m10,6:m12]
// Length of Bolt
customizerLen = 10; //[1:40] 

/*[Hidden]*/
customizerType = types[typeMeta];

module typesHelp() {
    echo ("available mX sizeses below:");
    for (i = types) {
      echo(i[0][1]);
    }
}


module mNut(size = m3, center = true, tolerance = 0, v = false) {
  fastenerType = size;
  t = tolerance; 

  // lookup values
  boltDiaL = lookup(boltDia, fastenerType);
  //headHexThickL = lookup(headHexThick, fastenerType);
  boltNutL = lookup(boltNut, fastenerType);
  boltNutMaxL = lookup(boltNutMax, fastenerType);
  nutThickL = lookup(nutThick, fastenerType);
  //washerDiaL = lookup(washerDia, fastenerType);
  //washerThickL = lookup(washerThick, fastenerType);
  //socketHeadThickL = lookup(socketHeadThick, fastenerType);
  //socketDiaL = lookup(socketDia, fastenerType);
  //socketSizeL = lookup(socketSize, fastenerType);

  difference() {
    cylinder(center = center, r = boltNutMaxL/2 + t/2, h = nutThickL + t , $fn = 6);
    cylinder(center = true, r = boltDiaL/2 + t/2, h = nutThickL*3, $fn = 72);

  }
  if (v) { 
    echo ("M nut type:", boltDiaL);
    echo ("nut thickness:", nutThickL+t);
    echo ("options: size, center, tolerance, v(erbosity)");
    typesHelp();
  }
}


module mNut2D(size = m3, center = true, tolerance = 0, v = false) {
  fastenerType = size;
  t = tolerance; 

  // lookup values
  boltDiaL = lookup(boltDia, fastenerType);
  //headHexThickL = lookup(headHexThick, fastenerType);
  boltNutL = lookup(boltNut, fastenerType);
  boltNutMaxL = lookup(boltNutMax, fastenerType);
  //nutThickL = lookup(nutThick, fastenerType);
  //washerDiaL = lookup(washerDia, fastenerType);
  //washerThickL = lookup(washerThick, fastenerType);
  //socketHeadThickL = lookup(socketHeadThick, fastenerType);
  //socketDiaL = lookup(socketDia, fastenerType);
  //socketSizeL = lookup(socketSize, fastenerType);

  difference() {
    circle(center = center, r = boltNutMaxL/2 + t/2, $fn = 6);
    circle(center = true, r = boltDiaL/2 + t/2, $fn = 72);

  }
  if (v) { 
    echo ("type M", boltDiaL);
    echo ("options: size, center, tolerance, v(erbosity)");
    typesHelp();
  }
}

module mBolt(size = m3, len = 10, center = true, style = "socket", 
            tolerance = 0, v = false) {
  fastenerType = size;
  t = tolerance; 

  // lookup values
  boltDiaL = lookup(boltDia, fastenerType);
  headHexThickL = lookup(headHexThick, fastenerType);
  boltNutL = lookup(boltNut, fastenerType);
  boltNutMaxL = lookup(boltNutMax, fastenerType);
  //nutThickL = lookup(nutThick, fastenerType);
  //washerDiaL = lookup(washerDia, fastenerType);
  //washerThickL = lookup(washerThick, fastenerType);
  socketHeadThickL = lookup(socketHeadThick, fastenerType);
  socketDiaL = lookup(socketDia, fastenerType);
  socketSizeL = lookup(socketSize, fastenerType);

  $fn = 72;
  socketRad = (socketSizeL/2)/sin(60); // socket hole diameter
  headRad = boltNutMaxL/2;

  centerTranslate = center == true ? len/2 : len;

  union() {
    cylinder(r = boltDiaL/2 + t, h = len, center = center );

    if (style == "socket") {
      translate([0, 0, centerTranslate+socketHeadThickL/2])
        difference() {
          cylinder(r = socketDiaL/2, h = socketHeadThickL, center = true);
          translate([0, 0, socketHeadThickL/2 - socketHeadThickL*.74/2])
            cylinder(r = socketRad, h = socketHeadThickL*.75, center = true, $fn = 6);
        }

      if (v) { // add verbose output for debugging
        echo ("type M", style, boltDiaL);
        echo ("total length:", len + socketHeadThickL);
        echo ("head thickness:", socketHeadThickL);
        echo ("bolt length:", len);
      }
    }
    
    if (style == "hex") {
      //translate([0, 0, len/2+headHexThickL/2])
      translate([0, 0, centerTranslate+headHexThickL/2])
        cylinder(h = headHexThickL, r = headRad, center = true, $fn = 6);

      if (v) { // add verbose output for debugging
        echo ("type M", style, boltDiaL);
        echo ("total length:", len + headHexThickL + t);
        echo ("head thickness:", headHexThickL);
        echo ("bolt length:", len);
      }


    }
  }

  if (v) {
    echo ("options: size, len, center, style, tolerance, v(erbosity)");
    typesHelp();
  }
  
}



module mBolt2D(size = m3, center = true, tolerance = 0, v = false) {
  fastenerType = size;
  t = tolerance; 

  // lookup values
  boltDiaL = lookup(boltDia, fastenerType);
  //headHexThickL = lookup(headHexThick, fastenerType);
  //boltNutL = lookup(boltNut, fastenerType);
  //boltNutMaxL = lookup(boltNutMax, fastenerType);
  //nutThickL = lookup(nutThick, fastenerType);
  //washerDiaL = lookup(washerDia, fastenerType);
  //washerThickL = lookup(washerThick, fastenerType);
  //socketHeadThickL = lookup(socketHeadThick, fastenerType);
  //socketDiaL = lookup(socketDia, fastenerType);
  //socketSizeL = lookup(socketSize, fastenerType);

  $fn = 72;
  circle(r = boltDiaL/2 + t, center = center );
  if (v) { // add verbose output for debugging
    echo ("type M", boltDiaL);
    echo ("options: size, center, tolerance, v(erbosity)");
    typesHelp();
  }

}

module mWasher(size = m3, tolerance = 0, v = false) {
  fastenerType = size; 
  t = tolerance; 

  // lookup values
  boltDiaL = lookup(boltDia, fastenerType);
  //headHexThickL = lookup(headHexThick, fastenerType);
  //boltNutL = lookup(boltNut, fastenerType);
  //boltNutMaxL = lookup(boltNutMax, fastenerType);
  //nutThickL = lookup(nutThick, fastenerType);
  washerDiaL = lookup(washerDia, fastenerType);
  washerThickL = lookup(washerThick, fastenerType);
  //socketHeadThickL = lookup(socketHeadThick, fastenerType);
  //socketDiaL = lookup(socketDia, fastenerType);
  //socketSizeL = lookup(socketSize, fastenerType);

  difference() {
    cylinder(r = washerDiaL/2+t/2, h = washerThickL+t, center = true, $fn = 36);
    cylinder(r = boltDiaL/2+t/2, h = washerThickL*3, center = true, $fn = 36);
  }

  if (v) {
    echo("washer M", boltDia);
    echo("thicknes, innerDia, outterDia:", washerThickL+t, boltDiaL+t, washerDiaL+t);
    echo("options: size, tolerance, v(erbosity)");
    typesHelp();
  }
}

module mWasher2D(size = m3, tolerance = 0, v = false) {
  fastenerType = size; 
  t = tolerance; 

  // lookup values
  boltDiaL = lookup(boltDia, fastenerType);
  //headHexThickL = lookup(headHexThick, fastenerType);
  //boltNutL = lookup(boltNut, fastenerType);
  //boltNutMaxL = lookup(boltNutMax, fastenerType);
  //nutThickL = lookup(nutThick, fastenerType);
  washerDiaL = lookup(washerDia, fastenerType);
  //washerThickL = lookup(washerThick, fastenerType);
  //socketHeadThickL = lookup(socketHeadThick, fastenerType);
  //socketDiaL = lookup(socketDia, fastenerType);
  //socketSizeL = lookup(socketSize, fastenerType);

  difference() {
    circle(r = washerDiaL/2+t/2, center = true, $fn = 36);
    circle(r = boltDiaL/2+t/2, center = true, $fn = 36);
  }

  if (v) {
    echo("washer M", boltDia);
    echo("innerDia, outterDia:", boltDiaL+t, washerDiaL+t);
    echo("options: size, tolerance v(erbosity)");
    typesHelp();
  }
}


// This is a mess
module tSlot(size = m3, material = 3, bolt = 15, tolerance = 0.5, v = false, 
            node = true) {
  fastenerType = size;
  t = tolerance; 
  // lookup values
  boltDiaL = lookup(boltDia, fastenerType);
  //headHexThickL = lookup(headHexThick, fastenerType);
  boltNutL = lookup(boltNut, fastenerType);
  boltNutMaxL = lookup(boltNutMax, fastenerType);
  nutThickL = lookup(nutThick, fastenerType);
  //washerDiaL = lookup(washerDia, fastenerType);
  //washerThickL = lookup(washerThick, fastenerType);
  //socketHeadThickL = lookup(socketHeadThick, fastenerType);
  //socketDiaL = lookup(socketDia, fastenerType);
  //socketSizeL = lookup(socketSize, fastenerType);
  
  boltSlot = bolt + t - material; // length of nut slot - material + tolerence
  nutTh = nutThickL + t; // thickness of nut + tolerence

  union() {
    cube([boltNutL+t, nutTh, material*2], center = true);
    translate([0, (boltSlot)/2-nutTh, 0])
      cube([boltDiaL+t, boltSlot, material*2], center=true);
    if (node) {
      for (i = [-1, 1]) {
        translate([i*(boltNutL+t)/2, nutTh/2, 0])
          cylinder(r = nutTh*.15, h = material*2, $fn = 72, center =true);
      }
    }
  }
  
  if (v) { // add output information for debugging
    echo("tslot total length:", boltSlot);
    echo("length above bolt:" , boltSlot-nutTh);
    echo("nut thickness: ", nutThickL+t);
  }
}


//useful for working with 2D shapes
module tSlot2D(size = m3, material = 0, bolt = 10, tolerance = .5, 
                v = false, node = 0.15) {
  if (node >= 1) {
    echo("node value should be < 1; ideally around 0.1-0.2");
  }
  fastenerType = size;
  t = tolerance; 

  // lookup values
  boltDiaL = lookup(boltDia, fastenerType);
  boltNutL = lookup(boltNut, fastenerType);
  boltNutMaxL = lookup(boltNutMax, fastenerType);
  nutThickL = lookup(nutThick, fastenerType);

  boltSlot = bolt + 2*t - material; // length of bolt slot

  nutTh = nutThickL + t; // bolt thickness plus tolerance

  union() {
    translate([0, -t-material/2, 0])
      square([boltDiaL, boltSlot], center=true);  // bolt slot
    translate([0, -bolt/2+nutTh*1.25, 0])
      square([boltNutL+t, nutTh], center = true); // nut

    for (i = [-1, 1]) {
      translate([i*(boltNutL+t)/2, -bolt/2+nutThickL*2+t/2, 0])
        circle(r = nutTh*node, $fn = 72);
    }

   }
  if (v) {
    echo("tSlot2D");
    echo("bolt dia, bolt length, material thickness, tolerance:",
        boltDiaL, bolt, material, tolerance);
    echo("options: size, material, bolt, tolerance, v(erbosity, node)");
    typesHelp();
  }
}

module tSlotDemo() {
  cut = [10, 3];
  tab = [cut[0], cut[1]+cut[1]/2, cut[1]];

  cutSheet = [40, 30];
  tabSheet = [cutSheet[0], cutSheet[1] - cut[1], cut[1]];



  linear_extrude(height = cut[1], center = true)
  color("yellow")
  difference() {
    square(cutSheet);
    translate([cutSheet[0]/2-cut[0]/2, cutSheet[1]-cut[1], 0])
      square(cut);
    translate([cutSheet[0]/2, cutSheet[1]-10/2, ])
      tSlot2D(material = 0, bolt = 10);
  }

  //linear_extrude(height = cut[1], center =true)
  color("blue")
  translate([0, cutSheet[1], -tabSheet[1]-cut[1]/2])
  rotate([90, 0, 0])
  union() {
    cube(tabSheet);
    difference() {
      translate([tabSheet[0]/2, tabSheet[1]+tab[1]/2, cut[1]/2])
        cube(tab, center = true);
      translate([cutSheet[0]/2, cutSheet[1]-1.5, 0])
        mBolt(tolerance = 0.1);
    }
  }

  translate([cutSheet[0]/2, cutSheet[1]-10/2, 0])
    rotate([-90, 0, 0])
    tSlotFit();

}


// nut and bolt pair set to tSlot dimensions for checking fit
module tSlotFit(size = m3, material = 3, bolt = 10, tolerance = 0.5, v = false,
            node = true, style = "socket") {

  if (v) {
    echo("tSlotFit");
    echo("options: size, material, bolt, tolerance, v(erbosity), node, style")
    typesHelp();
  }

  fastenerType = size;
  nutThickL = lookup(nutThick, fastenerType);

  boltSlot = bolt + tolerance - material;
  nutTh = nutThickL + tolerance;

  color("darkgray")
    //rotate([-90, 0, 0])
    mBolt(size = size, len = bolt, tolerance = -.01, v = v, style = style);

  color("slategray")
    translate([0, 0, -bolt/2+nutTh*1.25])
    //rotate([-90, 0, 0])
    mNut(size = size, v = v);


  
}

module demo() {
  for (i = types) {
    fastenerType = i;
    boltDiaL = lookup(boltDia, fastenerType);
    headHexThickL = lookup(headHexThick, fastenerType);
    boltNutL = lookup(boltNut, fastenerType);
    boltNutMaxL = lookup(boltNutMax, fastenerType);
    nutThickL = lookup(nutThick, fastenerType);
    washerDiaL = lookup(washerDia, fastenerType);
    washerThickL = lookup(washerThick, fastenerType);
    socketHeadThickL = lookup(socketHeadThick, fastenerType);
    socketDiaL = lookup(socketDia, fastenerType);
    socketSizeL = lookup(socketSize, fastenerType);

    translate([0, socketDiaL*10-40, 0])
      color("red")
      mBolt(i, len = washerDiaL);
    translate([30, socketDiaL*10-40, 0])
      color("orange")
      mBolt(i, style = "hex", len = washerDiaL);
    translate([60, socketDiaL*10-40, 0])
      color("yellow")
      mNut(i);
    translate([90, socketDiaL*10-40, 0])
      color("green")
      mWasher(i);
    translate([120, 25, 0])
      tSlotDemo();
  }
}

module simpleDemo() {
  fastenerType = customizerType;
  boltDiaL = lookup(boltDia, fastenerType);
  headHexThickL = lookup(headHexThick, fastenerType);
  boltNutL = lookup(boltNut, fastenerType);
  boltNutMaxL = lookup(boltNutMax, fastenerType);
  nutThickL = lookup(nutThick, fastenerType);
  washerDiaL = lookup(washerDia, fastenerType);
  washerThickL = lookup(washerThick, fastenerType);
  socketHeadThickL = lookup(socketHeadThick, fastenerType);
  socketDiaL = lookup(socketDia, fastenerType);
  socketSizeL = lookup(socketSize, fastenerType);
  
  trans = washerDiaL*1.5;
  
  color("blue")
    mBolt(size = fastenerType, len = customizerLen);

  translate([trans, 0, 0])
    color("red")
    mBolt(size = fastenerType, style = "hex", len = customizerLen);
  
  translate([trans*2, 0, 0])
    color("green")
    mNut(size = fastenerType);

  translate([trans*3, 0, 0])
    color("orange")
    mWasher(size = fastenerType);
  
  translate([trans*4+15, 0, 0])
    tSlotDemo();
}


/*
module tSlotDemo() {
  thick = 3; // material thickness
  cutSheet = [30, 20, thick];
  tol = 0.5; // tolerance

  difference() {
    color("blue")
      cube(cutSheet, center = true);
    translate([0, 10-4.6, 0])
      tSlot(size = m3, material = thick, bolt = 10, tolerance = tol);
  }
  
  difference() {
    color("yellow")
      translate([0, 10+3/2, 0])
      cube([30, thick, 25], center=true);
    translate([0, 10-4.6+thick])
      rotate([-90, 0, 0])
      mBolt(m3, len = 10, tolerance = 0.1);
  }

  translate([0, 10-4.6+thick-tol, 0])
    rotate([-90, 0, 0])
    color("silver")
    mBolt(m3, len = 10, tolerance = 0.01);

  translate([0, 10-4.6, 0])
    rotate([-90, 30, 0])
    color("gray")
    mNut(m3);

}
*/

//simpleDemo();
//demo();
//mWasher(m10);
//mNut(m3);
//mBolt(m3);
//mBolt(size = m3, style = "hex");
//mBolt(m3, tolerance = 0.02, center = false, style = "hex", len = 15);
//mBolt(m3, tolerance = 0.05, center = true, len = 6);
//tSlot(size = m3, bolt = 10);
//tSlotDemo();
//tSlot2D();
//mWasher2D();
//mNut2D();
//tSlot2D();
//tSlot();

//include <../libraries/nuts_and_bolts.scad>

customSize = [customX, customY, customZ];
fing = customFinger;


module addBolts(length, finger, cutD, uDiv, bolt = 10) {
  numCuts = ceil(uDiv/2);

  for (i = [0:numCuts-1]) {
    translate([i*finger*2, 0, 0])
      tSlotFit(bolt = bolt);
  }
}


// cuts that fall completely inside the edge
module insideCuts(length, finger, cutD, uDiv, bolt) {
  //o = 0.001; // overage to make the cuts complete

  //bolt = 10;
  //bolt = myBolt;
  numFinger = floor(uDiv/2);
  numCuts = ceil(uDiv/2);

  // draw rectangles to make slots
  for (i=[0:numCuts-1]) {
    translate([i*finger*2, 0, 0])
    union() {
      square([finger, cutD+o]);
      translate([finger/2, -(bolt/2-cutD), 0])
        tSlot2D(size = m3, bolt = bolt, material = 0);
    }
  }
}

module outsideCuts(length, finger, cutD, uDiv) {
  //o = 0.001; // overage to make cuts complete

  numFinger = ceil(uDiv/2);
  numCuts = floor(uDiv/2);

  // calculate the length of the extra long cut at either end
  endCut = (length-uDiv*finger)/2;
  // amount of padding to add to the itterative placement of cuts
  // this is the extra long cut at either end
  padding = endCut+finger;
  
  // first cut - large
  square([endCut, cutD]);

  for (i = [0:numCuts]) {
    if (i < numCuts) {
      // finger width cut
      translate([i*(finger*2)+padding, -o, 0])
        square([finger, cutD+o]);
      

    } else {
      // last cut - large
      translate([i*finger*2+padding, 0, 0])
        square([endCut, cutD]);
    }

    // bolt holes
    for (j = [0:numFinger]) {
      translate([i*finger*2+finger/2+padding-finger, 3/2, 0])
        mBolt2D(m3, tollerance = 0.15);
    }

  }
}

// extend tabs that have a bolt hole to make them more robust
module extendTab(length, finger, cutD, uDiv, extend = 3) {
  numFinger = ceil(uDiv/2);
 
  endCut = (length-uDiv*finger)/2;
  padding = endCut+finger;

  for (i = [0:numFinger-1]) {
    translate([i*finger*2+finger/2+padding-finger, 0, 0])
      square([finger, extend]);
  }
}

// Face A (X and Z dimensions)
// front and back face
module faceA(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  uDivX = usableDiv[0];
  uDivZ = usableDiv[2];
  uDivLX = usableDivLid[0];
  uDivLZ = usableDivLid[2];

  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  difference() {
    square([boxX, boxZ], center = true);

    // X+/- edge (X axis in openSCAD)
    translate([-uDivLX*lidFinger/2, boxZ/2-material, 0])
      insideCuts(length = boxX, finger = lidFinger, cutD = material, 
                uDiv = uDivLX, bolt = bolt);

    translate([uDivX*finger/2, -boxZ/2+material, 0])
      rotate(180)
      insideCuts(length = boxX, finger = finger, cutD = material, 
                uDiv = uDivX, bolt = bolt);

    // Z+/- edge (Y axis in OpenSCAD)
    translate([boxX/2-material, uDivZ*finger/2, 0]) rotate([0, 0, -90])
      insideCuts(length = boxZ, finger = finger, cutD = material, 
                uDiv = uDivZ, bolt = bolt);
    translate([-boxX/2+material, uDivZ*finger/2, 0]) mirror() rotate([0, 0, -90])
      insideCuts(length = boxZ, finger = finger, cutD = material, 
                uDiv = uDivZ, bolt = bolt);
  } // end difference

}

// Face B (X and Y dimensions)
// lid and base
module faceB(size, finger, lidFinger, material, usableDiv, usableDivLid, 
            lid = false, bolt) {
  
  // if this is the lid, use different settings than if it is the base
  uDivX = lid == true ? usableDivLid[0] : usableDiv[0];
  uDivY = lid == true ? usableDivLid[1] : usableDiv[1];
  myFinger = lid == true ? lidFinger : finger;
  
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];
 
  extend = 1.5; // amount to extend tabs that have bolt holes

  difference() {
    union() {
      square([boxX, boxY], center = true);

      // extend the tabs that have holes
      // +X side
      translate([-boxX/2-finger/2, boxY/2, 0])
        extendTab(length = boxX, finger = myFinger, cutD = material, 
                  uDiv = uDivX, extend = extend);
      translate([-boxX/2-finger/2, -boxY/2-extend, 0])
        extendTab(length = boxX, finger = myFinger, cutD = material, 
                  uDiv = uDivX, extend = extend);

    }

    // X+/- edge
    translate([-boxX/2, boxY/2-material+o, 0])
      outsideCuts(length = boxX, finger = myFinger, cutD = material, uDiv = uDivX);

    //add extend tabs here

    translate([-boxX/2, -boxY/2-o, 0])
      outsideCuts(length = boxX, finger = myFinger, cutD = material, uDiv = uDivX);

    // Y+/- edge 
    translate([boxX/2-material, uDivY*myFinger/2, 0]) rotate([0, 0, -90])
      insideCuts(length = boxY, finger = myFinger, cutD = material, 
                uDiv = uDivY, bolt = bolt);      
    // changed this to use mirror() due to bug in openscad that was causing
    // rendering issues in the throwntogether model: 
    // https://github.com/openscad/openscad/issues/1541
    translate([-boxX/2+material, uDivY*myFinger/2, 0]) mirror() rotate(-90)
      insideCuts(length = boxY, finger = myFinger, cutD = material, 
                uDiv = uDivY, bolt = bolt);      
  }
  
}

// Face C (Z and Y dimensions)
// left and right sides
module faceC(size, finger, lidFinger, material, usableDiv, usableDivLid) {
  uDivX = usableDiv[0];
  uDivY = usableDiv[1];
  uDivZ = usableDiv[2];
  uDivLX = usableDivLid[0];
  uDivLY = usableDivLid[1];
  uDivLZ = usableDivLid[2];

  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  extend = 1.5; // amount to extend tabs that have bolt holes
  

  difference() {
    union() {
      square([boxY, boxZ], center = true);


      // extend the tabs to provide space for the bolt holes
      // +X edge - (lid) - 
      translate([-boxY/2-lidFinger/2, boxZ/2, 0])
        extendTab(length = boxY, finger = lidFinger, cutD = material, 
                  uDiv = uDivLY, extend = extend);
      // -X edge (bottom)
      translate([-boxY/2-finger/2, -boxZ/2-material/2])
        extendTab(length = boxY, finger = finger, cutD = material,
                  uDiv = uDivY, extend = extend);
      
      // -Y edge
      translate([-boxY/2-extend, boxZ/2+finger/2, 0])
        rotate([0, 0, -90])
        extendTab(length = boxZ, finger = finger, cutD = material,
                  uDiv = uDivZ, extend = extend);
  
      // +Y edge       
      translate([boxY/2, boxZ/2+finger/2, 0])
        rotate([0, 0, -90])
        extendTab(length = boxZ, finger = finger, cutD = material,
                  uDiv = uDivZ, extend = extend);
      
    }

    //Y+/- edge (X axis in OpenSCAD)
    // lid edge
    translate([-boxY/2, boxZ/2-material+o, 0])
      outsideCuts(length = boxY, finger = lidFinger, cutD = material, uDiv = uDivLY);
    // bottom edge
    translate([-boxY/2, -boxZ/2-o, 0])
      outsideCuts(length = boxY, finger = finger, cutD = material, uDiv = uDivY);

    //Z+/- edge (Y axis in OpenSCAD)
    translate([boxY/2-material+o, boxZ/2, 0]) rotate([0, 0, -90])
      outsideCuts(length = boxZ, finger = finger, cutD = material, uDiv = uDivZ);
    translate([-boxY/2-o, boxZ/2, 0]) rotate([0, 0, -90])
      outsideCuts(length = boxZ, finger = finger, cutD = material, uDiv = uDivZ);
  }
}


module bottom(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];
 
  color("green")
  faceB(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid, lid = false, bolt = bolt);

}

module top(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("lime")
  faceB(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid, lid = false, bolt = bolt);

}

module front(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("darkred")
  faceA(size = size, finger = finger, material = material, lidFinger = lidFinger,
       usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);


}

module back(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];
  
  color("red")
  faceA(size = size, finger = finger, material = material, lidFinger = lidFinger,
       usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

}


module right(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("blue")
  faceC(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid);

}

module left(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("darkblue")
  faceC(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid);

}



module layout2D(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];
  
  //separation of pieces
  separation = material*2;
  // calculate the most efficient layout
  yDisplace = boxY > boxZ ? boxY : boxZ + separation;

  translate([])
    back(size = size, finger = finger, material = material, lidFinger = lidFinger, 
         usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([boxX+separation+boxY+separation, 0, 0])
    front(size = size, finger = finger, material = material, lidFinger = lidFinger, 
          usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([boxX/2+boxY/2+separation, 0, 0])
    right(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([boxX/2+boxY/2+separation, -yDisplace, 0])
    left(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);


  translate([0, -boxZ/2-yDisplace/2-separation, 0])
    top(size = size, finger = finger, material = material, lidFinger = lidFinger, 
        usableDiv = usableDiv, usableDivLid = usableDivLid, 
        lid = false, bolt = bolt);

  translate([boxX+separation+boxY+separation, -boxZ/2-yDisplace/2-separation, 0])
    bottom(size = size, finger = finger, material = material, lidFinger = lidFinger, 
        usableDiv = usableDiv, usableDivLid = usableDivLid, 
        lid = false, bolt = bolt);
}


module layout3D(size, finger, lidFinger, material, usableDiv, usableDivLid, 
                alpha, bolt = 10) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  // amount to shift to account for thickness of material
  D = material/2;

  color("green", alpha = alpha)
    translate([])
    linear_extrude(height = material, center = true)
    bottom(size = size, finger = finger, material = material, lidFinger = lidFinger, 
          usableDiv = usableDiv, usableDivLid = usableDivLid, lid = false, bolt = bolt);


  color("lime", alpha = alpha)
    translate([0, 0, boxZ-material])
    linear_extrude(height = material, center = true)
    top(size = size, finger = finger, material = material, lidFinger = lidFinger, 
          usableDiv = usableDiv, usableDivLid = usableDivLid, lid = false, bolt = bolt);


  color("red", alpha = alpha)
    translate([0, boxY/2-D, boxZ/2-D])
    rotate([90, 0, 0])
    linear_extrude(height = material, center = true)
    back(size = size, finger = finger, material = material, lidFinger = lidFinger, 
         usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([-finger*floor(usableDiv[0]/2), boxY/2-D, bolt/2-D])
    rotate([180, 0, 0])
    addBolts(length = boxY, finger = finger, cutD = material, 
            uDiv = usableDiv[0], bolt = bolt);

  translate([-lidFinger*floor(usableDivLid[0]/2), boxY/2-D, boxZ-bolt/2-D])
    addBolts(length = boxY, finger = lidFinger, cutD = material, 
            uDiv = usableDivLid[0], bolt = bolt);

  color("darkred", alpha = alpha)
    translate([0, -boxY/2+D, boxZ/2-D])
    rotate([90, 0, 0])
    linear_extrude(height = material, center = true)
    front(size = size, finger = finger, material = material, lidFinger = lidFinger, 
         usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([-finger*floor(usableDiv[0]/2), -boxY/2+D, bolt/2-D])
    rotate([180, 0, 0])
    addBolts(length = boxY, finger = finger, cutD = material, 
            uDiv = usableDiv[0], bolt = bolt);

  translate([-lidFinger*floor(usableDivLid[0]/2), -boxY/2+D, boxZ-bolt/2-D])
    addBolts(length = boxY, finger = lidFinger, cutD = material, 
            uDiv = usableDivLid[0], bolt = bolt);
  


  color("blue", alpha = alpha)
    translate([boxX/2-D, 0, boxZ/2-D])
    rotate([90, 0, 90])
    linear_extrude(height = material, center = true)
    right(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid);

  // lid bolts
  translate([boxX/2-bolt/2, -lidFinger*floor(usableDivLid[1]/2), boxZ-D*2])
    rotate([90, 0, 90])
    addBolts(length = boxX, finger = lidFinger, cutD = material, 
            uDiv = usableDivLid[1], bolt = bolt);

  // base bolts
  translate([boxX/2-bolt/2, -finger*floor(usableDiv[1]/2), -D/2])
    rotate([90, 0, 90])
    addBolts(length = boxX, finger = finger, cutD = material, 
            uDiv = usableDiv[1], bolt = bolt);
 
  // +Y on Z axis bolts
  translate([boxX/2-bolt/2, boxY/2-D, boxZ/2+finger*floor(usableDiv[2]/2)-D])
    rotate([0, 90, 0])
    addBolts(length = boxZ, finger = finger, cutD = material, 
            uDiv = usableDiv[2], bolt = bolt);

  // -Y on Z axis bolts
  translate([boxX/2-bolt/2, -1*(boxY/2-D), boxZ/2+finger*floor(usableDiv[2]/2)-D])
    rotate([0, 90, 0])
    addBolts(length = boxZ, finger = finger, cutD = material, 
            uDiv = usableDiv[2], bolt = bolt);



  color("darkblue", alpha = alpha)
    translate([-boxX/2+D, 0, boxZ/2-D])
    rotate([90, 0, 90])
    linear_extrude(height = material, center = true)
    left(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid);
  
  // lid bolts
  translate([-1*(boxX/2-bolt/2), -lidFinger*floor(usableDivLid[1]/2), boxZ-D*2])
    rotate([-90, 0, 90])
    addBolts(length = boxX, finger = lidFinger, cutD = material, 
            uDiv = usableDivLid[1], bolt = bolt);

  // base bolts
  translate([-1*(boxX/2-bolt/2), -finger*floor(usableDiv[1]/2), -D/2])
    rotate([-90, 0, 90])
    addBolts(length = boxX, finger = finger, cutD = material, 
            uDiv = usableDiv[1], bolt = bolt);
 
  // +Y on Z axis bolts
  translate([-1*(boxX/2-bolt/2), boxY/2-D, boxZ/2+finger*floor(usableDiv[2]/2)-D])
    rotate([0, 90, 180])
    addBolts(length = boxZ, finger = finger, cutD = material, 
            uDiv = usableDiv[2], bolt = bolt);

  // -Y on Z axis bolts
  translate([-1*(boxX/2-bolt/2), -1*(boxY/2-D), boxZ/2+finger*floor(usableDiv[2]/2)-D])
    rotate([0, 90, 180])
    addBolts(length = boxZ, finger = finger, cutD = material, 
            uDiv = usableDiv[2], bolt = bolt);

}


module fingerBox(size = [80, 50, 60], finger = 5, 
                lidFinger = 10, material = 3, 2D = true, alpha = .5, bolt = 10) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  // calculate the maximum number of fingers and cuts possible
  maxDivX = floor(boxX/finger);
  maxDivY = floor(boxY/finger);
  maxDivZ = floor(boxZ/finger);

  // calculate the maximum number of fingers and cuts for the lid
  maxDivLX = floor(boxX/lidFinger);
  maxDivLY = floor(boxY/lidFinger);

  // the usable divisions value must be odd for this layout
  uDivX = (maxDivX%2)==0 ? maxDivX-3 : maxDivX-2;
  uDivY = (maxDivY%2)==0 ? maxDivY-3 : maxDivY-2;
  uDivZ = (maxDivZ%2)==0 ? maxDivZ-3 : maxDivZ-2;
  usableDiv = [uDivX, uDivY, uDivZ];

  uDivLX= (maxDivLX%2)==0 ? maxDivLX-3 : maxDivLX-2;
  uDivLY= (maxDivLY%2)==0 ? maxDivLY-3 : maxDivLY-2;
  usableDivLid = [uDivLX, uDivLY];

  if (2D) {
    layout2D(size = size, finger = finger, lidFinger = lidFinger, material = material,
            usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);
  } else {
    layout3D(size = size, finger = finger, lidFinger = lidFinger, material = material,
            usableDiv = usableDiv, usableDivLid = usableDivLid, 
            alpha = alpha, bolt = bolt);
  }

  
}

fingerBox(size = customSize, material =  customMaterial, finger = customFinger, 
  lidFinger = customFinger, 2D = customDisplay, bolt = customBolt, alpha = cAlpha);
