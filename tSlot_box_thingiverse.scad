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
customBolt = 15; //[6, 10, 12, 15, 20, 25]

/* [Display] */
customDisplay = "3D"; // ["2D": 2D for DXF, "3D": 3D for Display, "flat": 3D printable version]
customTransparency = 40; //[0:90]


/* [Hidden] */
customS = [customX, customY, customZ]; // custom size array
o = 0.001; // overage for making complete cuts at edges
cAlpha = (100-customTransparency)/100; // convert integer to real for alpha

tSlotBox(size = customS, material =  customMaterial, finger = customFinger, 
  lidFinger = customFinger, layout = customDisplay, bolt = customBolt, alpha = cAlpha);

cF = customFinger;
if ( cF > customX/3 || cF > customY/3 || cF > customZ/3) {
  translate([0, -customY*2/3, 0])
    color("red")
    text("Error! customFinger must be less than 1/3 of shortest side", halign = "center");
}

// customizer settings

/* [Bolt] */
customSize = 3; //[2, 3, 4, 6, 8, 10]
customLength = 10; //[5:25]
customHead = "socket"; //[button, hex, flatSocket, flatHead, conical, socket, set, grub]
customThread = "metric"; //[none, metric]
customTolerance = 0.0; //[-0.9:0.05:0.9]

//bolt(size = metric_fastener[customSize], length = customLength, head = customHead, threadType = customThread, tolerance = customTolerance, list = true);

// try these:

//demo();
//tSlotDemo();

//list_types(metric_fastener);

//bolt(size=metric_fastener[3], head = "", length = 12, threadType = "metric", center = 0,  v = 0, list = true);
//boltHole(v = true, center = true, 2d = true, tolerance = .4);

//nut(size = metric_fastener[3], v = true, center = true);
//nutHole(size = metric_fastener[3], center = true, v = true);
//nutHole(size = metric_fastener[3], center = true, v = true, 2d = true, tolerance = 0.4);

//washer(size = metric_fastener[2], v=true);
//washerHole(size = metric_fastener[2]);
//washerHole(size = metric_fastener[2], 2d = true, tolerance = 0.4);


/* [Hidden] */
/*
  =====start documentation=====
  Create nuts, bolts, washers, tslots 

  This library was created to make adding nuts and bolts to 3D and 2D designs easier. The library provides features for making cut-outs for captive nuts and washers, bolt holes and t-slot joints.  Check the documentation below for more information.

  Aaron Ciuffo - http://www.thingiverse.com/txoof/about, 
  Reach me also at gmail: aaron.ciuffo

  ***These fasteners are close aproximations to the ISO standards, but in many cases are fudged.  Most notably the thread algorithm is not at all ISO compliant.***

  Latest version available on [GitHub](https://github.com/txoof/OpenSCAD_fasteners)

  Revision of http://www.thingiverse.com/thing:1220331


  ##### Thanks to:
  * Biomushroom: http://www.thingiverse.com/thing:965737 by biomushroom
  * TrevorM: Thread algorythm based on http://www.thingiverse.com/thing:27183 by Trevor Moseley

  

  ##### ISSUES:
    * only metric threads have been implemented
    * grub/set screws do not have socket heads
    * nodes do not work properly for sizes above M4
    * button head size is a bit of a fudge. 

  ##### TODO:
    * add socket to grub screws


#### How To Use:

  * Download this script 
  * comment out the bolt() call
  * add the following line to your script:
  ```
  include </path/to/script/nuts_and_bolts.scad>
  ```
  * see below for specifics


#### Available Nut, Bolt, Washer array sets:
  * metric_fasteners (alias: m)
    - sizes: 2, 3, 4, 6, 8, 10

   
#### demo(text = true/false);
  **show most of the the features**
  * text = true/false - add descriptive text

### tSlotDemo();
  **demonstrate a t-slot joint with a bolt**
  * for a working example of t-slot consturction see this [box](http://www.thingiverse.com/thing:1251283) built with t-slots


#### bolt(size = fastener_type[index], head = "<type\>", length = N\*, threadType = "type", quality = N, tolerance = R, list = true/false, center = true/false, v = true/false);

  **draw a predefined bolt from fastener_type array**
  * size = metric_fastener[index] - see the fastener_type array below
    - default: M3
  * head = "button", "hex", "flatSocket"/"flatHead", "conical", "socket", "grub"/"set"
    - default: socket
  * length = thread length - \*in the case of a flat-head socket, the TOTAL length
    - default: 10
  * threadType = "metric", "none"
    - default: metric
  * quality = N - N = number of curve segments (integer)
    - default: 32
  * tolerance = R - R = amount to increase/decrease all dimensions other than length
  * list = true/false - list the available types
  * center = true/false - center the length of the THREADS excluding head
  * v = true/false - verbose echo for debugging

##### Examples:
  ```
  //M4 x 15mm
  bolt(size = metric_fastner[4], length = 15);
  ```
  ```
  //M3 x 6 No thread
  bolt(size = metric_fastener[3], length = 6, threadType = "none");
  ```


####  nut(size = fastener_type[index], threadType = thread type, quality = N, list = false, quality = N, center = false, v = false);
  **draw a predefined nut from fastener_type array**
  * size = metric_fastener[index] - see the fastener_type array below
  - default: M3
  * quality = N - N = number of curve segments (integer)
  - default: 32
  * center = true/false - center the object    
  * v = true/false - verbose echo for debugging

##### Examples:
  ```
  //M4 Nut
  nut(metric_fastener[4]);
  ```

  ```
  //M3 Nut - low resolution
  nut(metric_fastener[4], quality = 15);
  ```


#### washer(size =fastener_type[index] , quality = N, , tolerance = R, quality = N, center = false, v = false)
  **draw a predefined washer from fastener_type array**
  * size = metric_fastener[index] - see the fastener_type array below
    - default: M3
  * quality = N - N = number of curve segments (integer)
    - default: 32
  * tolerance = R - total amount to add or subtract from the washer dimensions
    - default: 0.2
  * center = true/false - center the length of the THREADS excluding head
  * v = true/false - verbose echo for debugging

##### Examples:
  ```
  //M10 washer
  washer(metric_fastener[10]);
  ```

  ```
  //M3 washer, +0.4 tolerance
  washer(metric_fastener[3], tolerance = 0.4);
  ```


#### boltHole(size = fastener_type[index], length = N, quality = N, tolerance = R, quality =N, 2d = true/false, center = true/false, v = true/false)
  **draw a predefined bolt hole from fastener_type array**
  * size = metric_fastener[index] + tolerance - see the fastener_type array below
    - default: M3
  * length = N - N = length of bolt hole 
    - default: 10
  * quality = N - N = number of curve segments (integer)
    - default: 32
  * tolerance = R - total amount to add or subtract from the washer dimensions
    - default: 0
  * quality = N - N = number of curve segments (integer)
    - default: 24
  * 2d = true/false - true for working with 2 dimensional objects
    - default: false
  * center = true/false - center the length of the THREADS excluding head
  * v = true/false - verbose echo for debugging

##### Examples:
  ```
  //M3 hole +0.3 tolerance through 3mm material
  mat = 10;
  thick = 3;
  difference() {
    cube([mat, mat, thick], center = true);
    #boltHole(size = metric_fastener[3], tolerance = 0.3, center = true);
  }
  ```


#### nutHole(size = fastener_type[index], tolerance = R, 2d = true/false, center = true/false, v = true/false);
  **draw a predefined nut for making negative spaces based on fastener_type array**
    - this is useful for creating spaces for captive nuts
  * size = metric_fastener[index] - see the fastener_type array below
    - default: M3
  * tolerance = R - total amount to add or subtract from the nut dimensions
    - default: 0.2
  * 2d = true/false - true for working with 2 dimensional objectsa
    - default: false
  * center = true/false - center the object
  * v = true/false - verbose echo for debugging

##### Examples:
  ```
  //M2 Nut hole in 3mm material with +0.7 tolerance 
  mat = 10;
  thick = 3; 
  nutThick = 2.09; //the nut thicknes can be found using the v = true option 

  difference() {
    cube([mat, mat, thick], center = true);
    translate([0, 0, thick/2-nutThick])   
    nutHole(size = metric_fastener[2], tolerance = 0.7, v = true);
  }

  color("silver")
  translate([0, 0, thick/2 - 1.6/2])
  nut(metric_fastener[2], v = true, center = true);  
  ```

#### washerHole(size = fastener_type[index], tolerance = R, 2d = true/false, center = true/false, v = true/false);
  **draw a predefined washer for making negative spaces based on fastener_type array**
    - this is useful for creating spaces for captive washers
  * size = metric_fastener[index] - see the fastener_type array below
    - default: M3
  * tolerance = R - total amount to add or subtract from the washer dimensions
    - default: 0.2
  * quality = N - N = number of curve segments (integer)
    - default: 24
  * 2d = true/false - true for working with 2 dimensional objects
    - default: false
  * center = true/false - center the object
  * v = true/false - verbose echo for debugging


#### tSlot(size = fastener_type[index], material = N, length = N, tolerance = R, node = P, 2d = true/false, v = true/false);
  **draw a T-Slot for making cutouts using  CNC or laser cutter**
  - T-Slot example: https://planiverse.wordpress.com/2014/04/07/construction-technique-tab-and-slot-with-t-nut/
    - Nodes: http://blog.ponoko.com/2010/06/17/how-to-make-snug-joints-in-acrylic/
  * size = metric_fastener[index] - see the fastener_type array belowa
    - default: M3
  * material = N - thickness of material the bolt goes through (see the demo)
    - default: 3
  * length = N - length of bolt
    - default: 10
  * tolerance = R - total amount to add or subtract from the nut dimensions
    - default: 0.2
  * node = P - node size as percentage of nut thickness
    - default: 0.15
  * 2d = true/false - true for working with 2 dimensional objects
    - default: false 

#### tSlotBolt(size = fastner_type[index], length = N, head = "head type", threadType = "type", quality = N, v = true/false);
  **draw a bolt with a nut attached in appropriate position for a tSlot**
    - This is useful for visualizing the tSlot placement
  * size = metric_fastener[index] - see the fastener_type array below
    - default: M3
  * length = N - length of bolt
    - default: 10
  * head = "head type" - socket, hex, conical, set, flatHead (try list = true to see all types)
    - default: socket
  * threadType = "thread type" - metric, none (try list = true to see all types)
    - default: none
  * quality = N - N = number of curve segments (integer); if quality is set < 24 simpler forms of bolts will be used
    - default: 24
  * v = true/false - verbose echo for debugging


#### list_types(fastener_type); 

  **List all available sizes within a fasnter type**
  * array_name = predefined array containing bolt information in metric

  list_types(metric_fastener);
  Output is as follows:
  ECHO: "name: M1 - UNDEFINED"
  ECHO: "array_index[1]"
  ECHO: "============================="
  ECHO: "name: M2 Bolt, Nut & Washer"
  ECHO: "array_index[2]"
  ECHO: "     [1] thread diameter: 2"
  ECHO: "     [2] hex head thickess: 2"
  ECHO: "     [3] hex head & nut size: 4"
  ECHO: "     [4] socket head diameter: 3.5"
  ECHO: "     [5] socket head thickness: 2"
  ECHO: "     [6] socket tool size: 1.5"
  ECHO: "     [7] nut thickness,: 1.6"
  ECHO: "     [8] pitch: 0.4"
  ECHO: "     [9] washer thickness: 0.3"
  ECHO: "     [10] washer diameter: 5.5"
  ECHO: "============================="

#### fastener_type array
  **predefined array of fastener sizes based on ISO threads**
    - array is zero-indexed; element[0] contains human readable descriptions
    - measurements based on the following sources:
  * http://www.roymech.co.uk/Useful_Tables/Screws/Hex_Screws.htm
  * http://www.numberfactory.com/nf%20metric%20screws%20and%20bolts.htm
    - elements are arranged in increasing size 
    - for metric sizes, M3 is indexed [3], M4 is indexed [4], etc.

##### array descriptors 
  * name - human readable name: M3 Bolt, 1/2 inch Bolt
  * thread diameter - diameter of threaded bolt
  * hex head thickness - overall thickness of hex head
  * hex head & bolt size - distance across flats, wrench size needed
  * socket head diameter - diameter of rounded socket head
  * socket head thickness - overall thickness of socket head
  * socket tool size - size of hex socket tool needed
  * nut thickness - standard thickness
  * pitch - ISO thread pitch value (not implemented yet)
  * washer thickness - thickness of washer
  * washer diameter - diameter of washer

  =====end documentation=====
*/

/* [HIDDEN] */ 

metric_fastener = [
  ["name", "thread diameter", "hex head thickess", "hex head & nut size", 
  "socket head diameter", "socket head thickness", "socket tool size", 
  "nut thickness,", "pitch", "washer thickness", "washer diameter",
  "button thickness"] , 
  // M0 - field descriptors place holder in array

  ["M1 - UNDEFINED"], // M1

  ["M2 Bolt, Nut & Washer", 2, 2, 4, 3.5, 2, 1.5, 1.6, 0.4, 0.3, 5.5, .90], // M2
  ["M3 Bolt, Nut & Washer", 3, 2, 5.5, 5.5, 3, 2.5, 2.4, 0.5, 0.5, 7, 1.04], // M3
  ["M4 Bolt, Nut & Washer", 4, 2.8, 7, 7, 4, 3, 3.2, 0.7, 0.8, 9, 1.3], // M4
  //["M5 BOGUS", 5, 3, 8, 9, 5, 4, 4, .8, .9, 10],
  ["M5 - UNDEFINED"],
  ["M6 Bolt, Nut & Washer", 6, 4, 10, 10, 6, 5, 5, 1, 1.6, 12, 2.08],
  ["M7 - UNDEFINED"],
  ["M8 Bolt, Nut & Washer", 8, 5.5, 13, 13, 8, 6, 6.5, 1.25, 2, 17, 2.6],
  ["M9 - UNDEFINED"],
  ["M10 Bolt, Nut & Washer", 10, 7, 17, 16, 10, 8, 8, 1.5, 2, 21, 3.12]

];

m = metric_fastener;

// alias for metric_fastener:


// use this as the default in the event that no size is specified
defaultSize = metric_fastener[3]; 

// external radius from flat distance
function hexRadius(hexSize) = hexSize/2/sin(60); 

// radius of circle inside hexagon
function hexInradius(hexSize) = hexSize * (2 / sqrt(3)); 

// check an array for a specific term
function checkType(term, array) = search([term], array);

module list_types(array) {
  // list available fastener types stored and index values for programming refference
  descriptor = array[0];
  echo("**displays contents of descriptor array**");
  echo("array_index[X] - X = value to be called for that fastener type.");
  echo("     [Y] description: Z - Y = sub array index, Z = value stored");
  for (i = [1:len(array)-1]) {
    for (j = [ 0:len(array[i])-1 ] ) {
      if (j == 0) {
        echo(str(descriptor[j], ": ", array[i][j]));
        echo(str("array_index[", i,"]"));
      } else { // end if
        echo(str("     [", j, "] ", descriptor[j], ": ", array[i][j]));
      } // end else
    } // end for j
    echo("===============================");

  } // end for i
} // end list types

module cut_bit(height, boltSize, quality = 64) { //hexagonal nuts insertion cutout
  $fn = quality;
  translate([0, 0, height-height/2])
    cylinder(r1 = boltSize/1.5, r2 = boltSize/2, h = height/2);
  
  translate([])
    cylinder(r1 = boltSize/2, r2 = boltSize/1.5, h = height/2);
}

module thread(size = defaultSize, length = 10, threadType = "metric", 
              quality = 36, tolerance = 0) {

  pitch = size[8];
  twist = length/pitch*360;
  depth = pitch *.6;
  diameter = size[1]+tolerance;

  if (threadType == "none") {
    cylinder(r = diameter/2, h = length, $fn = quality);
  } else {
    linear_extrude(height = length, center = false, twist = -twist, $fn = quality)
      translate([depth/2, 0, 0]) 
        circle(r = diameter/2-depth/2);
  }
}

// draw a head of the specified type
module bolt_head(size = defaultSize, head = "socket", quality = 24, tolerance = 0, 
                list = false, v = false) {

  defaultHead = "socket";
  
  $fn = quality; // elements for each curve
  o = 0.001; // overage to make cuts complete

  // list available heads here
  headTypes = ["button", "conical", "flatSocket", "flatHead", "grub", "hex", "set", "socket" ]; 
  

  if (list) {
    echo ("Available head types:");
    for (i = headTypes) {
      echo(str("     ", i));
    }
  }
 
  // check for valid head type
  head = checkType(head, headTypes) == [[]] ? defaultHead : head;

  if (head == "socket") { // hex socket head
    // minkwoski() adds 2*sphere radius to the head adjust variables to deal with this
    headThick = size[5]-(1/8 * size[4])+tolerance;
    headRad = (size[4] + tolerance)/2;
    minSphere = headRad * 1/8; // radius for minkowski sphere
   
    transZ = quality >= 24 ? 1 : 0; // set to 0 if quality is less than 24

    // move the head to the origin, move just under origin to ensure union 
    translate([0, 0, ((1/8 * size[4])/2*transZ)-o*5]) 
    difference() {
      if (quality >= 24) { // if low quality, disable minkowski
        minkowski() { // create a nicely rounded head
          sphere(r = minSphere);
          cylinder ( h = headThick, r = headRad - minSphere);
        } // end minkowski
      } else { // for low rez head - add back in difference from minkowski
        cylinder(h = headThick + minSphere*2, r = headRad);
      }
      // hex tool socket
      translate([0, 0, headThick/2])
        cylinder( r = hexRadius(size[6]), $fn = 6, h = headThick*.8);
    } // end difference
  } // end if socket


  if (head == "conical") {
    // minkwoski() adds 2*sphere radius to the head adjust variables to deal with this
    headThick = size[5]*1.5 -(1/32*size[4])/2+tolerance;
    headR2 = (size[4]*.8 -1/32*size[4])/2+tolerance/2;
    headR1 = (size[4]+tolerance)/2;
    minSphere = 1/32 * headR1/2;
   
    transZ = quality >= 24 ? 1 : 0; // set to 0 if quality is less than 24
    
    // move the head to the origin - this is *slightly* below the axis
    translate([0, 0, minSphere*transZ-o*5])
    difference() {
      if (quality >= 24) {
        minkowski() { // add rounded edges to head
          //sphere((1/32)*size[4]/2);
          sphere(r = minSphere);
          cylinder(h = headThick, r2 = headR2, 
                  r1 = headR1);
        } // end minkowski
      } else {
       cylinder(h = headThick, r2 = headR2, r1 = headR1); 
      }
      translate([0, 0, headThick*.25])
        cylinder(r = hexRadius(size[6]), h = headThick*.8, $fn = 6);
    }
  } // end if conical


  if (head == "hex") {
    headThick = size[2]+tolerance;
    headRadius = hexRadius(size[3])+tolerance;
    intersection(size) {
      cylinder (r = headRadius, h = headThick, $fn = 6); // six sided head
      // cut rounded edges on bolt heads
      cut_bit(height = headThick, boltSize = size[3]+tolerance*2, quality = quality);
    } 
  } // end if hex

  if (head == "flatSocket" || head == "flatHead") { 
    headThick = size[5]+tolerance;
    headR1 = (size[1]+tolerance)/2;
    headR2 = (size[4]+tolerance)/2;
    //headRad = 
    translate([0, 0, -size[5]*.75])
    difference() {
      cylinder(r1 = headR1, r2 = headR2, h = headThick*.75);
      translate([0, 0, headThick*.75/2+o])
        // hex tool socket
        cylinder(r = hexRadius(size[6]), h = headThick/2, $fn=6);
    }
  } // end if flatSocket


  // don't do anything for type grub

  if (head == "button") {
    c = size[4]; // chord length 
    f = size[11]*1.25; // height of button  * 1.25 rough aproximation of proper size 

    //headRadius = ((pow(c,2)/4)-pow(f,2))/2*f;
    // r = radius of sphere that will be difference'd to make the button
    r = ( pow(c,2)/4 + pow(f,2) )/(2*f); 

    d = r - f; // displacement to move sphere

    difference() {
      translate([0, 0, -d])
      sphere(r = r, $fn = quality);  
      translate([0, 0, -r])
        cube(r*2, center = true);
      translate([0, 0, f/3])
      cylinder(r = hexRadius(size[6]), h = f, $fn = 6);
      
    } // end difference
  } // end if button

}

module bolt(size = defaultSize, head = "socket", length = 10, threadType = "metric", 
            quality = 24, tolerance = 0, list = false, center = false, v = false) {

  defaultThread = "none";
  threadTypes = ["none", "metric"];

  centerTransZ = center == true ? -length/2 : 0;

  if (list) { // list available thread types 
    echo("Available thread types");
    for (k = threadTypes) {
      echo(str("     ", k));
    }
  }

  threadType = checkType(threadType, threadTypes) == [[]] ? defaultThread : threadType;


  myLength = head == "flatSocket" || head == "flatHead" ? length - size[5]*.75 : length;

  translate([0, 0, centerTransZ])
  difference() {
    union() {
      translate([0, 0, length])
        bolt_head(size = size, head = head, quality = quality, , tolerance = tolerance,
                  list = list, v = v);
        thread(size = size, length = myLength, 
              threadType = threadType, quality = quality, tolerance = tolerance);
    } // end union
  } // end difference

  if (v) { // verbose output for debugging
    echo(str("Bolt"));
    echo("Options: size, head, length, threadType, quality, list, center, v");
    echo(str("     size: ", size[0]));
    echo(str("     diameter: ", size[1]+tolerance));
    echo(str("     thread length: ", length));
    echo(str("     thread type: ", threadType));


  }
}



/* 
  3D nut model
*/
module nut(size = defaultSize, threadType = "metric", quality = 24, tolerance = 0,
          list = false, center = false, v = false) {

  $fn = quality;
  height = size[7]+tolerance;
  radius = hexRadius(size[3]+tolerance/2);
  boltSize = size[3]+tolerance;
  defaultThread = "none";
  threadTypes = ["none", "metric"];

  threadType = checkType(threadType, threadTypes) == [[]] ? defaultThread: threadType;

  centerTransZ = center == true ? -height/2 : 0;

  if (v) {
    echo("Nut");
    echo("Options: size, threadType, quality, list, center, v");
    echo(str("     size: ", size[0]));
    echo(str("     nut thickness: ", height));
    echo(str("     nut radius: ", radius));
  }

  if (list) {
    echo("Available thread types:");
    for (k = threadTypes) {
      echo(str("     ", k));
    }
  }

  translate([0, 0, centerTransZ])
  difference() {
    intersection() {
      cylinder(r = radius, h = height, $fn = 6);
      cut_bit(height = height, boltSize = boltSize);
    } // end intersection
    translate([0, 0, -(height*1.1 - height)/2])
      thread(size = size, threadType = threadType, 
            length = height*1.1, tolerance = tolerance, quality = quality, list = list);
  } // end difference
//cylinder(center = true, r = 1.5, h = 5);
}


module washer(size = defaultSize, quality = 24, , tolerance = 0.1, 
              center = false, v = false) {

  $fn = quality;
  washDia = size[10]+tolerance; 
  washThick = size[9]+tolerance;
  washHole = size[1]+tolerance;

  if (v) {
    echo("Washer");
    echo(str("size: ", size[0]));
    echo(str("     thickness: ", washThick));    
    echo(str("     diameter: ", washDia));
  }
  
  difference() {
    cylinder(r = washDia/2, h = washThick);
    cylinder(r = washHole/2, h = washThick*4, center = true);
  }

}


/*
  boltHole();
  create a hole for a bolt to pass through
*/
module boltHole(size = defaultSize, length = 10, quality = 24, tolerance = 0, 
                2d = false, center = false, v = false) {


  $fn = quality;
  boltDiameter = size[1] + tolerance;
  if (2d) {
    circle(r = boltDiameter/2);
  } else {
    cylinder(r = boltDiameter/2, h = length, center = center);
  } 

  if (v) {
    echo("Bolt hole");
    echo(str("size: ", size[0]));
    echo(str("     diameter: ", boltDiameter));
    echo(str("     length: ", length));
  }
} 


/*
  nutHole();
  create recessed sockets for captive nuts or similar
*/
module nutHole(size = defaultSize, tolerance = 0.2, 2d = false, 
              center = false, v = false) {

  nutSize = size[3];
  nutRadius = hexRadius(nutSize)+tolerance/2;
  height = size[7]+tolerance;
  
  centerTransZ = center == true ? -height/2 : 0; // amount to center by

  if (2d) {
    circle( r = nutRadius, $fn = 6);
  } else {
    translate([0, 0, centerTransZ])
      cylinder(h = height, r = nutRadius, $fn = 6);
  }

  if (v) {
    echo("nutHole");
    echo("Options: size, tolerance, center, v");
    echo(str("    size: ", size[0]));
    echo(str("    nutHole thickness: ", height));
    echo(str("    nutHole radius: ", nutRadius));
    echo(str("    tolerance: ", tolerance));
  }

}

/*
  washerHole();
  create recessed sockets for captive washers or similar
*/
module washerHole(size = defaultSize, quality = 24, , tolerance = 0.2, 2d = false, 
              center = false, v = false) {

  $fn = quality;
  washDia = size[10]+tolerance; 
  washThick = size[9]+tolerance;

  if (2d) {
    circle(r = washDia/2);
  } else {
    cylinder(r = washDia/2, h = washThick);
  }

  if (v) {
    echo("Washer");
    echo(str("size: ", size[0]));
    echo(str("     thickness: ", washThick));    
    echo(str("     diameter: ", washDia));
  }

}



/*
  create a tSlot joint
  https://planiverse.wordpress.com/2014/04/07/construction-technique-tab-and-slot-with-t-nut/
*/
module tSlot(size = defaultSize, material = 3, length = 10, 
            tolerance = 0.5, node = 0.15, 2d = false, v = false) {

  boltDia = size[1] + tolerance;
  nutTh = size[7] + tolerance;
  nutFlat = size[3] + tolerance;
  nutRad = hexRadius(size[3]);
  t = tolerance;
  
  boltSlot = length + 2*t - material; // length of bolt slot - material + tolerance

  if (2d) {
    union() {
      translate([0, -t - material/2])
        square([boltDia, boltSlot], center = true); // slot for bolt
      translate([0, -length/2+nutTh*1.25]) 
        square([nutFlat, nutTh], center = true); // slot for nut
      // add circular nodes to the nut cutout to prevent cracking when tightened
      if (node > 0) { // add nodes
        for (i =[-1, 1]) {
          translate([i*(nutFlat)/2, -length/2+size[7]*2+t/2, 0])
            circle(r = nutTh*node, $fn = 72);
        } // end for
      } // end if node
    } // end union

  } else {
    union() {
      translate([0, -t - material/2])
        cube([boltDia, boltSlot, material*2], center = true); // slot for bolt
      translate([0, -length/2+nutTh*1.25])
        cube([nutFlat, nutTh, material*2], center = true); // slot for nut
      // add circular nodes to the nut cutout to prevent cracking when tightened
      if (node > 0) { // and nodes
        for (i =[-1, 1]) {
          translate([i*(nutFlat)/2, -length/2+size[7]*2+t/2, 0])
            cylinder(r = nutTh*node, h = material*2, $fn = 72, center = true);
        } // end for
      } // end if node
    } // end union
  } // end 2d false
  

} // end tSlot

// demonstration bolt with nut attached in appropriate position for tSlot
module tSlotBolt(size = defaultSize, length = 10, head = "socket", threadType = "none", 
                quality = 24, v = false) {

  // move nut and bolt pair into appropriate position to be used with a tSlot
  translate([0, 0, -length/2]) {
    color("darkgray")
    bolt(size = size, head = head, length = length, threadType = threadType, 
        quality = quality, v = v);  
    color("silver")
    translate([0, 0, size[7]*1.25+.25])
      rotate([0, 0, 30])
      nut(size = size, , threadType = threadType, quality = quality, 
          center = true, v = v);
  }
}


module tSlotDemo() {
  material = 3;
  cut = 20;
  outCut = 15.01;
  
  bolt = 15;

  faceX = 50;
  faceY = 30;

  // create a face with a slot for a tab to fit into 
  color("gold")
  difference() {
    cube([faceX, faceY, material], center = true); // face to be used
    translate([0, (faceY/2-material/2)]) 
      cube([cut, material+.001, material*2], center = true); // cut out for tab
    translate([0, faceY/2- bolt/2, 0])
      tSlot(tolerance = 0.25, length = bolt, material = material); // cut a tslot
  }

  // create a face with a tab to fit into the gold slot above
  color("darkblue") 
  // move into position to mate with gold face
  translate([0, faceY/2-material/2-.1, -faceY/2+material/2-.1])
  rotate([90, 0, 0])
  
  difference() {
    union() {
      cube([faceX, faceY, material], center = true); // face
      translate([0, faceY/2, 0])
        cube([cut, material, material], center = true); // add a tab
    }
    // remove material on either side of tab
    for (i = [-1, 1]) { // cut outs on either side of tab
      translate([i*(faceX/2-outCut/2), faceY/2-material/2-.001, 0])
        cube([outCut+.02, material+.25, material*2], center = true);
    }
    // cut a hole in the blue face for the bolt to fit through
    translate([0, faceY/2-1.5, bolt/2])
      rotate([180, 0, 0])
      boltHole(length = bolt, tolerance = 0.4); // bolt hole
  }


  // add a bolt with nut attached to show off tSlot
  translate([0, faceY/2- bolt/2, 0])
    rotate([-90, 0, 0])
    tSlotBolt(size = defaultSize, length = bolt, material = material);  
}

module demo(text = true) {
  space = metric_fastener[3][4]*2; // spacing in the display grid
  
  // types of threads and fasteners
  // "nut", "washer" and "text place holder" need to be last three elements
  
  // type of object to render in each column
  types =  ["conical", "socket", "hex", "flatHead", "button", "grub", "nut", 
            "washer", "text place holder"];

  // options for each row to be rendered [thread type, quality]
  renderOpts = [["metric", 36], ["metric", 24], ["none", 23], ["none", 9]];

  // color options - this helps create a rainbowed grid
  // see ../test/color_test.scad locally
  h = -33; // corse multiplier (rate of color change)
  ip = 7; // starting column in color space grid
  jp = 15; // starting row
  m = 1; // fine multiplier (rate of color change)

  for (i = [0:len(types)-1]) { // recurse the types of heads, and fasteners

    if (text && i < len(types)-1) { // add labels below X axis 
      translate([space*i, -len(types[i])-5, 0])
        rotate(90)
        text(str(types[i]), size = 3, halign = "center", valign = "center");
    }

    for (j = [0:len(renderOpts)-1]) { // recurse the render options 


      r = 0.5+sin(h*(i+ip)*m)/2; // calculate color s
      g = 0.5+sin(h*(j+jp)*m)/2;
      b = 0.5+sin(h*(i+j+jp+ip)*m)/2;

      translate([space*i, j*space ,0]) 
          color([r, g, b])
          if (i < len(types)-3) {
            bolt(head = types[i], threadType = renderOpts[j][0], 
                quality = renderOpts[j][1]);
          } 
          else if (i == len(types) - 3) { // nuts should be third to last
            nut(threadType = renderOpts[j][0], quality = renderOpts[j][1]);
          } 
          else if (i == len(types) - 2) { // washers should be second to last
            washer(quality = renderOpts[j][1]);
          }
          else if ( text && i == len(types) - 1) { // add labels - last item in list
            color("blue")
            text(str("thread: ",renderOpts[j][0], "; quality: ", renderOpts[j][1] ), size = 3, valign = "center");
          }
    } // end for j
  } // end for i
} // end demo



/*
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
*/


//include <../libraries/nuts_and_bolts.scad>
include <./nuts_and_bolts.scad>

o = 0.001; // overage

module addBolts(length, finger, cutD, uDiv, bolt = 10) {
  numCuts = ceil(uDiv/2);

  for (i = [0:numCuts-1]) {
    translate([i*finger*2, 0, 0])
      //tSlotFit(bolt = bolt); // from old library version
      tSlotBolt(size = m[3], length = bolt);
  }
} // end addBolts


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
        //tSlot2D(size = m3, bolt = bolt, material = 0); // from old library version
        tSlot(size = m[3], length = bolt, material = cutD, 2d = true);
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
      translate([i*finger*2+finger/2+padding-finger, cutD/2, 0])
        //mBolt2D(m3, tollerance = 0.15);
        boltHole(size = m[3], tolerance = 0.2, 2d = true);
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
 
  extend = material/2; // amount to extend tabs that have bolt holes

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

  extend = material/2; // amount to extend tabs that have bolt holes
  

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
  separation = material*2+1;
  // calculate the most efficient layout
  yDisplace = boxY > boxZ ? boxY + separation : boxZ + separation;

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

module layout3DFlat(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];
  
  //separation of pieces
  separation = material*2+1;
  // calculate the most efficient layout
  yDisplace = boxY > boxZ ? boxY + separation: boxZ + separation;

  translate([])
    color("red")
    linear_extrude(height = material)
    back(size = size, finger = finger, material = material, lidFinger = lidFinger, 
         usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([boxX+separation+boxY+separation, 0, 0])
    color("darkred")
    linear_extrude(height = material)
    front(size = size, finger = finger, material = material, lidFinger = lidFinger, 
          usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([boxX/2+boxY/2+separation, 0, 0])
    color("blue")
    linear_extrude(height = material)
    right(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([boxX/2+boxY/2+separation, -yDisplace, 0])
    color("darkblue")
    linear_extrude(height = material)
    left(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);


  translate([0, -boxZ/2-yDisplace/2-separation, 0])
    color("lime")
    linear_extrude(height = material)
    top(size = size, finger = finger, material = material, lidFinger = lidFinger, 
        usableDiv = usableDiv, usableDivLid = usableDivLid, 
        lid = false, bolt = bolt);

  translate([boxX+separation+boxY+separation, -boxZ/2-yDisplace/2-separation, 0])
    color("green")
    linear_extrude(height = material)
    bottom(size = size, finger = finger, material = material, lidFinger = lidFinger, 
        usableDiv = usableDiv, usableDivLid = usableDivLid, 
        lid = false, bolt = bolt);
}


/*
module tSlotBox(size = [80, 50, 60], finger = 5, 
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
*/


module tSlotBox(size = [80, 50, 60], finger = 5, 
                lidFinger = 10, material = 3, layout = "2D", alpha = .5, bolt = 10) {
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

  if (layout == "2D") {
    layout2D(size = size, finger = finger, lidFinger = lidFinger, material = material,
            usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);
  } else if  (layout == "3D") {
    layout3D(size = size, finger = finger, lidFinger = lidFinger, material = material,
            usableDiv = usableDiv, usableDivLid = usableDivLid, 
            alpha = alpha, bolt = bolt);
  } else if (layout == "flat") {
    layout3DFlat(size = size, finger = finger, lidFinger = lidFinger, material = material,
            usableDiv = usableDiv, usableDivLid = usableDivLid, 
            alpha = alpha, bolt = bolt);

  }



  
}








boltLen = 15;

d = true;

//d = false;
finger = 16;

//tSlotBox(size = [50, 50, 50], material =  3, finger = finger, lidFinger = finger, 2D = d, bolt = boltLen, alpha = 0.60);


//tSlotBox(size = [50, 50, 50], material =  3, finger = finger, lidFinger = finger, layout = "3D", bolt = boltLen, alpha = 0.60);
