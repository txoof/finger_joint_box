//Create a laser cut box with finger joints
/* Version 2.1.1 3 August 2014
  *cut depth may be slightly too large due to kerf error

*/

/* [Box OUTSIDE Dimensions] */
//Box Width (X) 
bX=70; 
//Box Depth (Y)
bY=120; 
//Box Height (Z)
bZ=70; 
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
2D=0; //[1:2D for DXF, 0:3D for STL]

/* [Hidden] */
//Calculate the maximum number of tabs and slots
maxDivX=floor(bX/cutW);
maxDivY=floor(bY/cutW);
maxDivZ=floor(bZ/cutW);

alp=1-alpha/100;

//calculate the maximum number of usable divisions 

//NB! the maximum usable divisions MUST be odd
uDivX= (maxDivX%2)==0 ? maxDivX-3 : maxDivX-2;
uDivY= (maxDivY%2)==0 ? maxDivY-3 : maxDivY-2;
uDivZ= (maxDivZ%2)==0 ? maxDivZ-3 : maxDivZ-2;

//cuts that fall completely inside the edge
module insideCuts(len, uDiv) {
  numTabs=floor(uDiv/2);
  numSlots=ceil(uDiv/2);
  
  //draw out rectangels for slots
  for (i=[0:numSlots-1]) {
    translate([i*(cutW*2)+kerf/2, 0, 0])
      square([cutW-kerf, cutD]);
      //Orignial: square([cutW-kerf, cutD-kerf/2]);
  }
}

//cuts that fall at the end of an edge
module outsideCuts(len, uDiv, endCut) {
  numTabs=ceil(uDiv/2);
  numSlots=floor(uDiv/2);
  //padding - shift all the slots by the amount equal to the end cut plus one division
  padding=endCut+cutW;
  
  //Consider removing the kerf here and below

  //first endcut
  square([endCut+kerf/2, cutD]);
  //Original: square([endCut+kerf/2, cutD-kerf/2]);
  
  //draw all the normal slots plus the last endcut
  for (i=[0:numSlots]) {
    if (i < numSlots) {
      translate([i*(cutW*2)+padding-kerf/2, 0, 0])
        square([cutW+kerf, cutD]);
        //Original: square([cutW+kerf, cutD-kerf/2]);
    } else {
      translate([i*(cutW*2)+padding-kerf/2, 0, 0])
        square([endCut+kerf/2, cutD]);
        //Original: square([endCut+kerf/2, cutD-kerf/2]);
    }

  }
}

//face A (X, Z)
module faceA() {
  difference() {
    square([bX, bZ], center=true);
    //X+/- edge (X axis in OpenSCAD)

    if (lid) {
    translate([-uDivX*cutW/2, bZ/2-cutD, 0])
    //original: translate([-uDivX*cutW/2, bZ/2-cutD+kerf/2, 0])
      insideCuts(bX, uDivX);
    }
    translate([-uDivX*cutW/2, -bZ/2, 0])
      insideCuts(bX, uDivX);

    //Z+/- edge (Y axis in OpenSCAD)
    translate([bX/2-cutD+kerf/2, uDivZ*cutW/2, 0]) rotate([0, 0, -90])
      insideCuts(bZ, uDivZ);
    translate([-bX/2, uDivZ*cutW/2, 0]) rotate([0, 0, -90])
      insideCuts(bZ, uDivZ);
  }
} //end faceA


module faceB() {
  endCutX=(bX-uDivX*cutW)/2;
  difference() {
    square([bX, bY], center=true);
    //X+/- edge (X axis in OpenSCAD)
    translate([(-uDivX*cutW/2)-endCutX, bY/2-cutD, 0])
    //Original: #translate([(-uDivX*cutW/2)-endCutX, bY/2-cutD+kerf/2, 0])
      outsideCuts(bX, uDivX, endCutX);
    translate([(-uDivX*cutW/2)-endCutX, -bY/2, 0])
      outsideCuts(bX, uDivX, endCutX);

    //Y+/- edge (Y axis in OpenSCAD)
    translate([bX/2-cutD+kerf/2, uDivY*cutW/2, 0]) rotate([0, 0, -90])
      insideCuts(bY, uDivY);
    translate([-bX/2, uDivY*cutW/2, 0]) rotate([0, 0, -90])
      insideCuts(bY, uDivY);
      
  }
}

module faceC() {
  endCutY=(bY-uDivY*cutW)/2;
  endCutZ=(bZ-uDivZ*cutW)/2;

  difference() {
    square([bY, bZ], center=true);
    //Y+/- edge (X axis in OpenSCAD)
    if (lid) {
    translate([(-uDivY*cutW/2)-endCutY, bZ/2-cutD, 0])
    //Original: #translate([(-uDivY*cutW/2)-endCutY, bZ/2-cutD+kerf/2, 0])
      outsideCuts(bY, uDivY, endCutY);
    }
    translate([(-uDivY*cutW/2)-endCutY, -bZ/2, 0])
      outsideCuts(bY, uDivY, endCutY);

    //Z+/- edge (Y axis in OpenSCAD)
    translate([-bY/2, (uDivZ*cutW/2)+endCutZ, 0]) rotate([0, 0, -90])
      outsideCuts(bZ, uDivZ, endCutZ);
    translate([bY/2-cutD+kerf/2, (uDivZ*cutW/2)+endCutZ, 0]) rotate([0, 0, -90])
      outsideCuts(bZ, uDivZ, endCutZ);
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


