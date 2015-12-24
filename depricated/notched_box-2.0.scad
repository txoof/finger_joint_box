//Create a laser cut box with notches
//version 2.0

/* [Box OUTSIDE Dimensions] */
//Box Width
//Box Width (X), Depth (Y), Height (Z)
bX=100;
bY=70;
bZ=60;
//Material Thickness
cutD=3.5;
lid=false;
lid=true;

/* [Tabs and Cuts] */
//Slot and Tab width
cutW=15;
//cutW=cutD*2;
//Laser kerf 
//#FIXME!  the kerf on several faces is not handeled well
//try a value of 7
kerf=.1;

/* [Layout] */
//separation of finished pieces
separation=1;

/* [Hidden] */
//Calculate the maximum number of tabs and slots
maxDivX=floor(bX/cutW);
maxDivY=floor(bY/cutW);
maxDivZ=floor(bZ/cutW);

//calculate the maximum number of usable divisions 

//NB! the maximum usable divisions MUST be odd
uDivX= (maxDivX%2)==0 ? maxDivX-3 : maxDivX-2;
uDivY= (maxDivY%2)==0 ? maxDivY-3 : maxDivY-2;
uDivZ= (maxDivZ%2)==0 ? maxDivZ-3 : maxDivZ-2;


module insideCuts(len, uDiv) {
  numTabs=floor(uDiv/2);
  numSlots=ceil(uDiv/2);
  
  //draw out rectangels for slots
  for (i=[0:numSlots-1]) {
    translate([i*(cutW*2), 0, 0])
      square([cutW+kerf, cutD+kerf]);
  }
}

module outsideCuts(len, uDiv, endCut) {
  numTabs=ceil(uDiv/2);
  numSlots=floor(uDiv/2);
  //padding - shift all the slots by the amount equal to the end cut plus one division
  padding=endCut+cutW;
   
  //first endcut
  square([endCut+kerf, cutD+kerf]);
  
  //draw all the normal slots plus the last endcut
  for (i=[0:numSlots]) {
    if (i < numSlots) {
      translate([i*(cutW*2)+padding, 0, 0])
        square([cutW+kerf, cutD+kerf]);
    } else {
      translate([i*(cutW*2)+padding, 0, 0])
        square([endCut+kerf, cutD+kerf]);
    }

  }

  
  //draw out rectangles for slots
}

//face A (X, Z)

//FIXME - check the tab alignment on the X axis! @108 the center tab might be fucked
module faceA() {
  difference() {
    square([bX, bZ], center=true);
    //X+/- edge (X axis in OpenSCAD)
    if (lid) {
    translate([-uDivX*cutW/2-kerf/2, bZ/2-cutD, 0])
      insideCuts(bX, uDivX);
    }
    translate([-uDivX*cutW/2-kerf/2, -bZ/2, 0])
      insideCuts(bX, uDivX);

    //Z+/- edge (Y axis in OpenSCAD)
    translate([bX/2-cutD, uDivZ*cutW/2-kerf/2, 0]) rotate([0, 0, -90])
      insideCuts(bZ, uDivZ);
    translate([-bX/2, uDivZ*cutW/2-kerf/2, 0]) rotate([0, 0, -90])
      insideCuts(bZ, uDivZ);
  }
} //end faceA


//#FIXME kerf on X and Y edges are wrong; 
module faceB() {
  endCutX=(bX-uDivX*cutW)/2;
  difference() {
    square([bX, bY], center=true);
    //X+/- edge (X axis in OpenSCAD)
    translate([(-uDivX*cutW/2)-endCutX-kerf/2, bY/2-cutD, 0])
      outsideCuts(bX, uDivX, endCutX);
    translate([(-uDivX*cutW/2)-endCutX-kerf/2, -bY/2, 0])
      outsideCuts(bX, uDivX, endCutX);

    //Y+/- edge (Y axis in OpenSCAD)
    #translate([bX/2-cutD, uDivY*cutW/2, 0]) rotate([0, 0, -90])
      insideCuts(bY, uDivY);
    #translate([-bX/2, uDivY*cutW/2, 0]) rotate([0, 0, -90])
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
    translate([(-uDivY*cutW/2)-endCutY-kerf/2, bZ/2-cutD, 0])
      outsideCuts(bY, uDivY, endCutY);
    }
    translate([(-uDivY*cutW/2)-endCutY-kerf/2, -bZ/2, 0])
      outsideCuts(bY, uDivY, endCutY);

    //Z+/- edge (Y axis in OpenSCAD)
    translate([-bY/2, (uDivZ*cutW/2)+endCutZ+kerf/2, 0]) rotate([0, 0, -90])
      outsideCuts(bZ, uDivZ, endCutZ);
    translate([bY/2-cutD, (uDivZ*cutW/2)+endCutZ+kerf/2, 0]) rotate([0, 0, -90])
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

  //transparency
  alp=0.5;

  
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
  color("silver", alpha=alp)
    translate([-bX/2+D, 0, bZ/2-D]) rotate([90, 0, 90])
    linear_extrude(height=cutD, center=true) faceC();
}

*layout2D();
*translate([bX+bY+separation*2, 0, 0])  
  layout2D();

assemble3D();


