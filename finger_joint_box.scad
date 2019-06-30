/*
  Box with fingerjoints - Based on earlier version of Finger Joint Box
  http://www.thingiverse.com/thing:448592
  Aaron Ciuffo
  rewrite to be easier to use as a library
  24 June 2019
*/

/* [Box Dimensions] */
// Box X dimension
customX = 100;
// Box Y dimension
customY = 60;
// Box Z dimension
customZ = 40.; //[100.01]

// Finger & Cut width (sides, bottom) - must be < 1/3 shortest side
customFinger = 10;
// Finger & Cut wdith on lid only - must be < 1/3 shortest X or Y
customLidFinger = 20;

//Material thickness
customMaterial=3; //[0.1:0.05:10]

/* [Layout Option] */
// layout 2D or 3D style - THINGIVERSE CANNOT OUTPUT 2D STLS!
customLayout2D = 0; // [0:3D layout for visualization, 1:2D layout for DXF output]

/* [Hidden] */
// assign the variable for the demo module
tSize=[customX, customY, customZ];
tFinger=customFinger;
tLidFinger=customLidFinger;
tMaterial=customMaterial;
t2D=0;
tAlpha=0.5;


function usableDiv(divs) =
  [divs[0]%2==0 ? divs[0]-3 : divs[0]-2,
   divs[1]%2==0 ? divs[1]-3 : divs[1]-2,
   divs[2]%2==0 ? divs[2]-3 : divs[2]-2];


//calculate max number of fingers and cuts possible
function maxDiv(size, finger) =
  [floor(size[0]/finger),
   floor(size[1]/finger),
   floor(size[2]/finger)];

module insideCuts(length, finger, cutD, div) {
  //make cuts entirely inside the length of the edge
  numFinger = floor(div/2);
  numCuts = ceil(div/2);

  //add a little to the cut depth to avoid Z-Fighting
  myCutD = cutD+0.001;

  //draw rectangeles to make the negative slots
  for (i=[0:numCuts-1]) {
    translate([i*finger*2, 0, 0])
      square([finger, myCutD]);
  }
}

module outsideCuts(length, finger, cutD, div) {
  //make cuts that fall outiside of the edge
  numFinger = ceil(div/2);
  numCuts = floor(div/2);

  //add a little to the cut depth to avoid Z-Fighting
  myCutD = cutD+0.001;

  //calculate the length of the extra long cut at either end of the edge
  endCut = (length-div*finger)/2;

  //amount of padding to add to the itteratigve placement of cuts
  //this is the extra long cut at either end
  padding = endCut+finger;

  square([endCut, myCutD]);

  //draw rectangeles to make the negative slots
  for (i=[0:numCuts]) {
    if (i < numCuts) {
     translate([i*(finger*2)+padding, 0, 0])
        square([finger, myCutD]);
    } else {
      translate([i*finger*2+padding, 0, 0])
        square([endCut, myCutD]);
    }
  }
}


module faceA(size, finger, lidFinger, material) {
  maxDivs = maxDiv(size, finger);
  uDiv = usableDiv(maxDivs);
  uDivLid = usableDiv(maxDiv(size, lidFinger));

  difference() {
    square([size[0], size[2]], center=true);
    // X+/- edge (X axis in OpenScad)
    translate([-uDivLid[0]*lidFinger/2, size[2]/2-material, 0])
      insideCuts(length=size[0], finger=lidFinger, cutD=material, div=uDivLid[0]);
   // translate([-uDiv[0]*finger/2, -size[2], 0]
    translate([-uDiv[0]*finger/2, -size[2]/2, 0])
      insideCuts(length=size[0], finger=finger, cutD=material, div=uDiv[0]);

    // Z+/- edge (Y axis)
    translate([size[0]/2-material, uDiv[2]*finger/2, 0])
    rotate([0, 0, -90])
      insideCuts(length=size[2], finger=finger, cutD=material, div=uDiv[2]);

    translate([-size[0]/2, uDiv[2]*finger/2, 0])
    rotate([0, 0, -90])
      insideCuts(length=size[2], finger=finger, cutD=material, div=uDiv[2]);
  }
}

module faceB(size, finger, lidFinger, material, lid=false) {
  //lid and base
  maxDivs = lid==true ? maxDiv(size, lidFinger) : maxDiv(size, finger);
  uDiv = usableDiv(maxDivs);

  myFinger = lid==true ? lidFinger : finger;

  difference() {
    square([size[0], size[1]], center=true);

    //X+/= edge (X axis in view window)
    translate([-size[0]/2, size[1]/2-material, 0])
      outsideCuts(length=size[0], finger=myFinger, cutD=material, div=uDiv[0]);
    translate([-size[0]/2, -size[1]/2, 0])
      outsideCuts(length=size[0], finger=myFinger, cutD=material, div=uDiv[0]);

    //Y+/- edge (Y axis in view window)
    translate([size[0]/2-material, uDiv[1]*myFinger/2, 0])
    rotate([0, 0, -90])
      insideCuts(length=size[1], finger=myFinger, cutD=material, div=uDiv[1]);
    translate([-size[0]/2, uDiv[1]*myFinger/2, 0])
    rotate([0, 0, -90])
      insideCuts(length=size[1], finger=myFinger, cutD=material, div=uDiv[1]);
  }
}


module faceC(size, finger, lidFinger, material) {
  maxDivs = maxDiv(size, finger);
  uDiv = usableDiv(maxDivs);
  uDivLid = usableDiv(maxDiv(size, lidFinger));

  difference() {
    square([size[1], size[2]], center=true);

    //Y+/- edge (X asis in view window)
    translate([-size[1]/2, size[2]/2-material, 0])
      outsideCuts(length=size[1], finger=lidFinger, cutD=material, div=uDivLid[1]);
    translate([-size[1]/2, -size[2]/2, 0])
      outsideCuts(length=size[1], finger=finger, cutD=material, div=uDiv[1]);

    //Z+/- edge (Y axis in view window)
    translate([size[1]/2-material, size[2]/2, 0])
    rotate([0, 0, -90])
      outsideCuts(length=size[2], finger=finger, cutD=material, div=uDiv[2]);
    translate([-size[1]/2, size[2]/2, 0])
    rotate([0, 0, -90])
      outsideCuts(length=size[2], finger=finger, cutD=material, div=uDiv[2]);
  }
}

module layout(size, material, 2D=true, alpha=0.5, v=true) {

  if (v) {
    echo("parameters:");
    echo("material (thickness of material)");
    echo("size ([X, Y, Z] - dimensions of box)");
    echo("2D (boolean - childrender in 2D or 3D)");
    echo("alpha (real between 0, 1 - transparency of 3D model)");
    echo(" ");
    echo("requires six children faces provided in the order below");
    echo("face relative XYZs are shown along with childrendering colors");
    echo("layout2D() { faceA(-XZ red); faceA(+XZ darkred); faceB(-XY lime); faceB(+XY green); faceC(-YZ blue); faceC(+YZ darkblue);}");
  }


  if(2D) {
    //separation of pieces for 2D layout
    separation = 1.5;
    //calculate the most efficient layout for 2D layout
    yDisplace = size[1] > size[2] ? size[1] : size[2] + separation;


    translate([0, 0, 0])
      color("Red")
      //faceA(size=size, finger=finger, material=material, lidFinger=lidFinger);
      children(0);
 
    translate([size[0]+separation+size[1]+separation, 0, 0])
      color("darkred")
      //faceA(size=size, finger=finger, material=material, lidFinger=lidFinger);
      children(1);

    translate([size[0]/2+size[1]/2+separation, 0, 0])
      color("blue")
      //faceC(size=size, finger=finger, material=material, lidFinger=lidFinger);
      children(4);

    translate([size[0]/2+size[1]/2+separation, -yDisplace, 0])
      color("darkblue")
      //faceC(size=size, finger=finger, material=material, lidFinger=lidFinger);
      children(5);


    translate([0, -size[2]/2-yDisplace/2-separation, 0])
      color("lime")
      //faceB(size=size, finger=finger, material=material, lidFinger=lidFinger, lid=true);
      children(2);

    translate([size[0]+separation+size[1]+separation, -size[2]/2-yDisplace/2-separation, 0])
      color("green")
      //faceB(size=size, finger=finger, material=material, lidFinger=lidFinger);
      children(3);
  } else {
    //draw 3d model
    //amount to shift to account for thickness of material
    D = material/2;

    //base
    color("green", alpha=alpha)
      translate([0, 0, 0])
      linear_extrude(height=material, center=true)
        //faceB(size=size, finger=finger, material=material, lidFinger=lidFinger);
        children(2);

    //lid
    color("lime", alpha=alpha)
      translate([0, 0, size[2]-material])
      linear_extrude(height=material, center=true)
        //faceB(size=size, finger=finger, material=material, lidFinger=lidFinger, lid=true);
        children(3);

    color("red", alpha=alpha)
      translate([0, size[1]/2-D, size[2]/2-D])
      rotate([90, 0, 0])
      linear_extrude(height=material, center=true)
        //faceA(size=size, finger=finger, material=material, lidFinger=lidFinger);
        children(0);

    color("darkred", alpha=alpha)
      translate([0, -size[1]/2+D, size[2]/2-D])
      rotate([90, 0, 0])
      linear_extrude(height=material, center=true)
        //faceA(size=size, finger=finger, material=material, lidFinger=lidFinger);
        children(1);

    color("blue", alpha=alpha)
      translate([size[0]/2-D, 0, size[2]/2-D])
      rotate([90, 0, 90])
      linear_extrude(height=material, center=true)
        //faceC(size=size, finger=finger, material=material, lidFinger=lidFinger);
        children(4);


    color("darkblue", alpha=alpha)
      translate([-size[0]/2+D, 0, size[2]/2-D])
      rotate([90, 0, 90])
      linear_extrude(height=material, center=true)
        //faceC(size=size, finger=finger, material=material, lidFinger=lidFinger);
        children(5);
  }
}



module layout2D(size=[50, 80, 60], finger=5, lidFinger=10, material=3) {
  //separation of pieces
  separation = 1.5;
  //calculate the most efficient layout
  yDisplace = size[1] > size[2] ? size[1] : size[2] + separation;

  echo("faceA");
  translate([0, 0, 0])
    color("Red")
    faceA(size=size, finger=finger, material=material, lidFinger=lidFinger);

  translate([size[0]+separation+size[1]+separation, 0, 0])
    color("darkred")
    faceA(size=size, finger=finger, material=material, lidFinger=lidFinger);


  translate([size[0]/2+size[1]/2+separation, 0, 0])
    color("blue")
    faceC(size=size, finger=finger, material=material, lidFinger=lidFinger);

  translate([size[0]/2+size[1]/2+separation, -yDisplace, 0])
    color("darkblue")
    faceC(size=size, finger=finger, material=material, lidFinger=lidFinger);



  translate([0, -size[2]/2-yDisplace/2-separation, 0])
    color("lime")
    faceB(size=size, finger=finger, material=material, lidFinger=lidFinger, lid=true);

  translate([size[0]+separation+size[1]+separation, -size[2]/2-yDisplace/2-separation, 0])
    color("green")
    faceB(size=size, finger=finger, material=material, lidFinger=lidFinger);

}

module layout3D(size, finger, lidFinger, material, alpha=0.5) {
  //create a 3D model of the box

  //amount to shift to account for thickness of material
  D = material/2;

  //base
  color("green", alpha=alpha)
    translate([0, 0, 0])
    linear_extrude(height=material, center=true)
      faceB(size=size, finger=finger, material=material, lidFinger=lidFinger);

  //lid
  color("lime", alpha=alpha)
    translate([0, 0, size[2]-material])
    linear_extrude(height=material, center=true)
      faceB(size=size, finger=finger, material=material, lidFinger=lidFinger, lid=true);

  color("red", alpha=alpha)
    translate([0, size[1]/2-D, size[2]/2-D])
    rotate([90, 0, 0])
    linear_extrude(height=material, center=true)
      faceA(size=size, finger=finger, material=material, lidFinger=lidFinger);

  color("darkred", alpha=alpha)
    translate([0, -size[1]/2+D, size[2]/2-D])
    rotate([90, 0, 0])
    linear_extrude(height=material, center=true)
      faceA(size=size, finger=finger, material=material, lidFinger=lidFinger);

  color("blue", alpha=alpha)
    translate([size[0]/2-D, 0, size[2]/2-D])
    rotate([90, 0, 90])
    linear_extrude(height=material, center=true)
      faceC(size=size, finger=finger, material=material, lidFinger=lidFinger);


  color("darkblue", alpha=alpha)
    translate([-size[0]/2+D, 0, size[2]/2-D])
    rotate([90, 0, 90])
    linear_extrude(height=material, center=true)
      faceC(size=size, finger=finger, material=material, lidFinger=lidFinger);



}


module fingerBox(size=[50, 40, 70], finger=5, lidFinger=10, material=3, l2D=false,
alpha=0.5) {

  if(l2D) {
    layout2D(size=size, finger=finger, material=material, lidFinger=lidFinger);
  } else {
    layout3D(size=size, finger=finger, material=material, lidFinger=lidFinger,
             alpha=alpha);
  }

}


//layout2D(size=[50, 80, 60], finger=5, lidFinger=10, material=3);
//layout3D(size=[50, 80, 60], finger=5, lidFinger=10, material=3);

//fingerBox(size=tSize, finger=tFinger, lidFinger=tLidFinger, material=tMaterial, l2D=t2D, alpha=tAlpha);

myS = [customX, customY, customZ];
myF = customFinger;
myLF = customLidFinger;
m = customMaterial;
layout = customLayout2D;

layout(myS, m, 2D=layout) {
  faceA(myS, myF, myLF, m);
  faceA(myS, myF, myLF, m);
  faceB(myS, myF, myLF, m);
  faceB(myS, myF, myLF, m, lid=true);
  faceC(myS, myF, myLF, m);
  faceC(myS, myF, myLF, m);
}
