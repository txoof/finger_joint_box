/*
Create a laser cut box with finger joints
Version 2.3 15 September 2014
  * partial rewrite of modules to make more parametric

*/

/* [Box OUTSIDE Dimensions] */
//Box Width (X)
bX=70;
//Box Depth (Y)
bY=120;
//Box Height (Z)
bZ=100;
//Material Thickness
cutD=3;
//include a lid?
lid=1; //[1:Lid, 0:No Lid]

/* [Finger Width] */
//Finger  width (cutW < 1/3 shortest side)
cutW=5;//[3:20]
//Laser kerf (1/2 inside, 1/2 outside of laser path)
kerf=0.1;

/* [Layout] */
//separation of finished pieces
separation=1;
//transparency of 3D model
alpha=50; //[1:100]
//2D or 3D Layout
2D=1; //[1:2D for DXF, 0:3D for STL]



/* [Hidden] */
//Calculate the maximum number of tabs and slots
maxDivX=floor(bX/cutW);
maxDivY=floor(bY/cutW);
maxDivZ=floor(bZ/cutW);

//NB! the maximum usable divisions MUST be odd
uDivX= (maxDivX%2)==0 ? maxDivX-3 : maxDivX-2;
uDivY= (maxDivY%2)==0 ? maxDivY-3 : maxDivY-2;
uDivZ= (maxDivZ%2)==0 ? maxDivZ-3 : maxDivZ-2;

alp=1-alpha/100;


//cuts that fall completely insde the edges
module insideCuts(len, cutWidth, cutDepth, uDiv, lKerf=0.1) {

  //Calculate the number of tabs and slots
  numTabs=floor(uDiv/2);
  numSlots=ceil(uDiv/2);

  //draw out rectangles for slots
  for (i=[0:numSlots-1]) {
    translate([i*(cutWidth*2)+lKerf/2, 0, 0])
      square([cutWidth-lKerf, cutDepth]);
  }
}


//cuts that fall at the end of an edge
module outsideCuts(len, cutWidth, cutDepth, uDiv, lKerf=0.1, endCut) {
  
  numSlots=floor(uDiv/2);

  //padding - sift all the slots by the amount equal to tend cut plus one division
  padding=endCut+cutWidth;

  //first endcut
  square([endCut+lKerf/2, cutD]);

  //draw all the normal slots plus the last endcut
  for (i=[0:numSlots]) {
    if (i < numSlots) {
      translate([i*(cutWidth*2)+padding-lKerf/2, 0, 0])
        square([cutWidth+lKerf, cutDepth]);
    } else {
      translate([i*(cutWidth*2)+padding-lKerf/2, 0, 0])
        square([endCut+lKerf/2, cutDepth]);
    }
  }
}



//Face A (X and Z dimension)
module faceA() {
  difference() {
    square([bX, bZ], center=true);
    //X+/- edge (X axis in OpenSCAD)
    // make cuts for a lid?
    if (lid) {
      translate([-uDivX*cutW/2, bZ/2-cutD, 0])
        insideCuts(len=bX, cutWidth=cutW, cutDepth=cutD, uDiv=uDivX, lKerf=kerf);
    }
    translate([-uDivX*cutW/2, -bZ/2, 0])
      insideCuts(len=bX, cutWidth=cutW, cutDepth=cutD, uDiv=uDivX, lKerf=kerf);

    //Z+/- edge (Y axis in OpenSCAD)
    translate([bX/2-cutD+kerf/2, uDivZ*cutW/2, 0]) rotate([0, 0, -90])
      insideCuts(len=bZ, cutWidth=cutW, cutDepth=cutD, uDiv=uDivZ, lKerf=kerf);
    translate([-bX/2, uDivZ*cutW/2, 0]) rotate([0, 0, -90])
      insideCuts(len=bZ, cutWidth=cutW, cutDepth=cutD, uDiv=uDivZ, lKerf=kerf);
  }
}


module faceB() {
  endCutX=(bX-uDivX*cutW)/2;
  difference() {
    square([bX, bY], center=true);
    //X+/- edge (X axis in OpenSCAD)
    translate([(-uDivX*cutW/2)-endCutX, bY/2-cutD, 0])
    //Original: #translate([(-uDivX*cutW/2)-endCutX, bY/2-cutD+kerf/2, 0])
      outsideCuts(len=bX, cutWidth=cutW, cutDepth=cutD, uDiv=uDivX, 
        lKerf=kerf, endCut=endCutX);
    translate([(-uDivX*cutW/2)-endCutX, -bY/2, 0])
      outsideCuts(len=bX, cutWidth=cutW, cutDepth=cutD, uDiv=uDivX, 
        lKerf=kerf, endCut=endCutX);

    //Y+/- edge (Y axis in OpenSCAD)
    translate([bX/2-cutD+kerf/2, uDivY*cutW/2, 0]) rotate([0, 0, -90])
      insideCuts(len=bY, cutWidth=cutW, cutDepth=cutD, uDiv=uDivY, lKerf=kerf);
    translate([-bX/2, uDivY*cutW/2, 0]) rotate([0, 0, -90])
      insideCuts(len=bY, cutWidth=cutW, cutDepth=cutD, uDiv=uDivY, lKerf=kerf);

  }
}


module faceC() {
  //amount to cut off at the end of an outside cut edge
  endCutY=(bY-uDivY*cutW)/2; 
  endCutZ=(bZ-uDivZ*cutW)/2;

  difference() {
      square([bY, bZ], center=true);
      //Y+/- edge (X axis in OpenSCAD)
      if(lid) {
        translate([(-uDivY*cutW/2)-endCutY, bZ/2-cutD, 0])
          outsideCuts(len=bY, cutWidth=cutW, cutDepth=cutD, uDiv=uDivY, lKerf=kerf, 
            endCut=endCutY);
      }
      translate([(-uDivY*cutW/2)-endCutY, -bZ/2, 0])
        outsideCuts(len=bY, cutWidth=cutW, cutDepth=cutD, uDiv=uDivY, lKerf=kerf,
          endCut=endCutY); 

      //Z+/- edge (Y axis in OpenSCAD)
      translate([-bY/2, (uDivZ*cutW/2)+endCutZ, 0]) rotate([0, 0, -90])
        outsideCuts(len=bZ, cutWidth=cutW, cutDepth=cutD, uDiv=uDivZ, lKerf=kerf,
          endCut=endCutZ);
      translate([bY/2-cutD+kerf/2, (uDivZ*cutW/2)+endCutZ, 0]) rotate([0, 0, -90])
        outsideCuts(len=bZ, cutWidth=cutW, cutDepth=cutD, uDiv=uDivZ, lKerf=kerf,
          endCut=endCutZ);
    }
}

module layout2D() {
  faceA();
  translate([0, -bZ/2-bY/2-separation, 0])
    color("green") faceB();
  translate([bX/2+bY/2+separation, 0, 0])
    color("blue") faceC();
}

module assemble3D() {
  //amount to shift for cut depth
  D=cutD/2;

  color("aqua", alpha=alp)
    linear_extrude(height=cutD, center=true) faceB();
  if (lid) {
  color("green", alpha=alp)
    translate([0, 0, bZ-cutD])
    linear_extrude(height=cutD, center=true) faceB();
  }

  //faceA +/-
  color("red", alpha=alp)
    translate([0, bY/2-D, bZ/2-D]) rotate([90, 0, 0])
    linear_extrude(height=cutD, center=true) faceA();
  color("gold", alpha=alp)
    translate([0, -bY/2+D, bZ/2-D]) rotate([90, 0, 0])
    linear_extrude(height=cutD, center=true) faceA();

  //FaceC +/-
  color("blue", alpha=alp)
    translate([bX/2-D, 0, bZ/2-D]) rotate([90, 0, 90])
    linear_extrude(height=cutD, center=true) faceC();
  color("purple", alpha=alp)
    translate([-bX/2+D, 0, bZ/2-D]) rotate([90, 0, 90])
    linear_extrude(height=cutD, center=true) faceC();
}

//Layout the model
if (2D) {
  layout2D();
  translate([bX+bY+separation*2, 0, 0])
    layout2D();
} else {
  assemble3D();
}

