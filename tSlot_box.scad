/*
  Box with fingerjoints - Based on earlier version of Finger Joint Box
  http://www.thingiverse.com/thing:448592
  Aaron Ciuffo
  24 December 2015 
 

  To Do:
    * write each face as separate module (front, back, left, etc.) to make modifications
      simpler 

  Issues:
    X The thrown together model does not render the tslots correctly.
    X bolt hole is ON the edge of each tab; this will not cut properly
      - move hole in a bit
      - add a bit to each tab


  Thanks to: 
  * Floppykiller for finding a bugs - http://www.thingiverse.com/Floppykiller/about
    - problem in tab extension 
    - problem in tSlot movement with material thickness
    - problem in bolt-hole placement
*/


//include <../libraries/nuts_and_bolts.scad>
include <../nuts_and_bolts_biomushroom/nuts_and_bolts.scad>

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

boltLen = 10;

d = true;

d = false;
finger = 16;

fingerBox(size = [100, 85, 70], material =  3, finger = finger, 
  lidFinger = finger, 2D = d, bolt = boltLen, alpha = 0.60);
