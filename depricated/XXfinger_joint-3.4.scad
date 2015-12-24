/*
Create an outline for a laser cut box with finger joints
Released under the Creative Commons Attribution License
Some Rights Reserved: aaron . ciuffo 2 gmail.com

Version 3.0 12 November 2014
  * rewrite from scratch
  * removed kerf all together

Version 3.1 13 November 2014
  * reworked layout2D to handled a greater variety of part sizes

Version 3.2 13 November 2014
  * verified that removing kerf handling was a good idea
  * fixed small issue with layout2D
  * cookies?

Version 3.3 15 November 2014
  * fixed a few typos - Thanks Mixomycetes for pointing those out

Version 3.5 16 November 2014
  * trying out different closure methods for lid
  * TODO
    - verify that corner supports work and fit as expected!
    - I DO NOT LIKE THIS.


*/

/*[Box Outside Dimensions]*/
//Box Width - X
bX=75;
//Box Depth - Y
bY=120;
//Box Height - Z
bZ=55;
//Material Thickness
thick=3;

/*[Box Features]*/
//Include a lid?
addLid=1; //[1:Lid, 0:No Lid]
//Finger Hole Diameter - 0==no hole
holeDia=20; //[0:50]
holeFacets=36;//[3:36]
lidCatch=1; //[0:None, 1:Add Catch]
catchRad=12;

/*[Finger Width]*/
//Finger width (NB! width must be < 1/3 shortest side)
fingerW=5;//[3:20]
//Lid finger width 
fingerLidW=15;//[3:20]

/*[Layout]*/
//separation of finished pieces
separation=1;
//transparency of 3D model
alpha=50; //[1:100]
2D=1; //[1:2D for DXF, 0:3D for STL]

/*[Hidden]*/
//transparency alpha
alp=1-alpha/100;






//cuts that fall complete inside the edge
module insideCuts(length, fWidth, cutD, uDiv) {
  //Calculate the number of fingers and cuts
  numFinger=floor(uDiv/2);
  numCuts=ceil(uDiv/2);

  //draw out rectangles for slots
  for (i=[0:numCuts-1]) {
    translate([i*(fWidth*2), 0, 0])
      square([fWidth, cutD]);
  }
}

//cuts that fall at the end of an edge requirng an extra long cut
module outsideCuts(length, fWidth, cutD, uDiv) {
  numFinger=ceil(uDiv/2);
  numCuts=floor(uDiv/2);
  //calculate the length of the extra long cut
  endCut=(length-uDiv*fWidth)/2;
  //amount of padding to add to the itterative placement of cuts 
  // this is the extra long cut at the beginning and end of the edge
  padding=endCut+fWidth;
  
  square([endCut, cutD]);

  for (i=[0:numCuts]) {
    if (i < numCuts) {
      translate([i*(fWidth*2)+padding, 0, 0])
        square([fWidth, cutD]);
    } else {
      translate([i*(fWidth*2)+padding, 0, 0])
        square([endCut, cutD]);
    }
  }


  
}

module cornerSupport(sThick=3, sFingerW=5, supRad=15, boltD=3, hole=true, enlarge=1.05, project=false, tab=false) {
  f=1.8*boltD;
  nutR=(f*(1/cos(30)))/2*enlarge;
  if (project==false) {
    union() {
      difference() {
        circle(r=supRad, center=true);
        translate([-supRad, 0, 0])
          square([supRad, supRad]);
        translate([-supRad, -supRad, 0])
          square([supRad, supRad]);
        translate([0, -supRad, 0])
          square([supRad, supRad]);
        if (hole==true) {
          translate([supRad/2-nutR/2, supRad/2-nutR/2, 0])
            circle(r=nutR, $fn=6);
        } else {
          translate([supRad/2-nutR/2, supRad/2-nutR/2, 0])
            circle(r=boltD/2*enlarge, $fn=36);
        }
      }
      if (hole==true) {
        translate([supRad/2-sFingerW/2, -sThick, 0])
          square([sFingerW, sThick]);
        translate([-sThick, supRad/2-sFingerW/2, 0])
          square([sThick, sFingerW]);
      }

    }
  } else {
    //project=true draw just the hole or tab appropriately placed
    if (tab==true) {
    /*
      translate([supRad/2-sFingerW/2, -sThick, 0])
        square([sFingerW, sThick]);
      translate([-sThick, supRad/2-sFingerW/2, 0])
        square([sThick, sFingerW]);  
    */
      square([sFingerW, sThick], center=true);
    } else {
      translate([supRad/2-nutR/2, supRad/2-nutR/2, 0])
        circle(r=boltD/2*enlarge, $fn=36);
      
    }
  }
}

module assembleCornerSupport() {
  color("yellow")
    linear_extrude(height=thick, center=true)
    cornerSupport(supRad=catchRad, sFingerW=fingerW, sThick=thick, hole=true);
  color("orange")
    translate([0, 0, thick])
    linear_extrude(height=thick, center=true)
    cornerSupport(supRad=catchRad, hole=false);
  color("orange")
    translate([0, 0, -thick])
    linear_extrude(height=thick, center=true)
    cornerSupport(supRad=catchRad, hole=false);
}


//Face A (X and Z dimensions)
//Front and back face
module faceA(uDivX, uDivY, uDivZ, uDivLX, uDivLY) {
  difference() {
    square([bX, bZ], center=true);

    //X+/- edge (X axis in OpenSCAD)
    //if true, make cuts for the lid, otherwise leave a blank edge
    if (addLid) {
      translate([-uDivLX*fingerLidW/2, bZ/2-thick, 0])
        insideCuts(len=bX, fWidth=fingerLidW, cutD=thick, uDiv=uDivLX);
    }
    translate([-uDivX*fingerW/2, -bZ/2, 0]) 
      insideCuts(length=bX, fWidth=fingerW, cutD=thick, uDiv=uDivX);

    //Z+/- edge (Y axis in OpenSCAD)
    translate([bX/2-thick, uDivZ*fingerW/2, 0]) rotate([0, 0, -90])
      insideCuts(length=bZ, fWidth=fingerW, cutD=thick, uDiv=uDivZ);
    translate([-bX/2, uDivZ*fingerW/2, 0]) rotate([0, 0, -90])
      insideCuts(length=bZ, fWidth=fingerW, cutD=thick, uDiv=uDivZ);

  }
}

//Face B (X and Y dimensions)
//Lid and base
module faceB(uDivX, uDivY, uDivZ, uDivLX, uDivLY, makeLid=0) {

  //if this is the "lid" use fingerLidW dimensions instead of fingerW
  //create the local version of these variables

  uDivXloc= makeLid==1 ? uDivLX : uDivX;
  uDivYloc= makeLid==1 ? uDivLY : uDivY;
  fingerWloc= makeLid==1 ? fingerLidW : fingerW;
  lidHoleLoc= makeLid==1 ? holeDia/2 : 0;

  difference() {
    square([bX, bY], center=true);

    //X+/- edge
    translate([-bX/2, bY/2-thick, 0])
      outsideCuts(length=bX, fWidth=fingerWloc, cutD=thick, uDiv=uDivXloc);
    translate([-bX/2, -bY/2, 0])
      outsideCuts(length=bX, fWidth=fingerWloc, cutD=thick, uDiv=uDivXloc);

    //Y+/- edge
    translate([bX/2-thick, uDivYloc*fingerWloc/2, 0]) rotate([0, 0, -90])
      insideCuts(length=bY, fWidth=fingerWloc, cutD=thick, uDiv=uDivYloc);
    translate([-bX/2, uDivYloc*fingerWloc/2, 0]) rotate([0, 0, -90])
      insideCuts(length=bY, fWidth=fingerWloc, cutD=thick, uDiv=uDivYloc);
  
    //lid hole with holeFacets sides
    if (makeLid==1) {
      circle(r=lidHoleLoc, $fn=holeFacets);
      if (lidCatch==1) {
        translate([-bX/2+thick, -bY/2+thick, 0])
          cornerSupport(sFingerW=fingerW, sThick=thick, hole=false, 
            supRad=catchRad, project=true);
        translate([-bX/2+thick, bY/2-thick, 0]) rotate([0, 0, -90])
          cornerSupport(sFingerW=fingerW, sThick=thick, hole=false, 
            supRad=catchRad, project=true);
        translate([bX/2-thick, bY/2-thick, 0]) rotate([0, 0, -180])
          cornerSupport(sFingerW=fingerW, sThick=thick, hole=false, 
            supRad=catchRad, project=true);
        translate([bX/2-thick, -bY/2+thick, 0]) rotate([0, 0, -270])
          cornerSupport(sFingerW=fingerW, sThick=thick, hole=false, 
            supRad=catchRad, project=true);
      }
    }
  }
  
}

//Face C (Z and Y dimensions)
//left and right sides
module faceC(uDivX, uDivY, uDivZ, uDivLX, uDivLY) {

  difference() {
    square([bY, bZ], center=true);
    
    //Y+/- edge (X axis in OpenSCAD)
    //make cuts for the lid or leave a straight edge
    if(addLid) {
      translate([-bY/2, bZ/2-thick, 0])
        outsideCuts(length=bY, fWidth=fingerLidW, cutD=thick, uDiv=uDivLY);  
    }
    translate([-bY/2, -bZ/2, 0])
      outsideCuts(length=bY, fWidth=fingerW, cutD=thick, uDiv=uDivY);

    //Z+/- edge (Y axis in OpenSCAD)
    translate([bY/2-thick, bZ/2, 0]) rotate([0, 0, -90])
      outsideCuts(length=bZ, fWidth=fingerW, cutD=thick, uDiv=uDivZ);
    translate([-bY/2, bZ/2, 0]) rotate([0, 0, -90])
      outsideCuts(length=bZ, fWidth=fingerW, cutD=thick, uDiv=uDivZ);
      

  }
}

module placeSupport2D() {
//cornerSupport(project=true, tab=true, sFingerW=fingerW, sThick=thick);
  for (i=[0:3]) {
    translate([i*(catchRad*3+separation+fingerW), separation, 0])
      cornerSupport(supRad=catchRad, sFingerW=fingerW, sThick=thick);
    translate([separation+catchRad+i*(catchRad*3+separation+fingerW), separation, 0])
      cornerSupport(supRad=catchRad, hole=false);
    translate([separation*2+catchRad*2+i*(catchRad*3+separation+fingerW), separation, 0])
      cornerSupport(supRad=catchRad, hole=false);
  }
}

module layout2D(uDivX, uDivY, uDivZ, uDivLX, uDivLY) {
  yDisplace= bY>bZ ? bY : bZ+separation;

  translate([])
    color("red") faceA(uDivX, uDivY, uDivZ, uDivLX, uDivLY);
  translate([bX+separation+bY+separation, 0, 0])
    color("darkred") faceA(uDivX, uDivY, uDivZ, uDivLX, uDivLY);



  translate([bX/2+bY/2+separation, 0, 0])
    color("blue") faceC(uDivX, uDivY, uDivZ, uDivLX, uDivLY);
  //bottom row
  translate([bX/2+bY/2+separation, -yDisplace, 0])
    color("darkblue") faceC(uDivX, uDivY, uDivZ, uDivLX, uDivLY);



  if (addLid) {
    //bottomo row
    translate([0, -bZ/2-yDisplace/2-separation, 0])
      color("lime") faceB(uDivX, uDivY, uDivZ, uDivLX, uDivLY, makeLid=1);
  }
  translate([bX+separation+bY+separation, -bZ/2-yDisplace/2-separation, 0])
    color("green") faceB(uDivX, uDivY, uDivZ, uDivLX, uDivLY, makeLid=0);

//  translate([0, catchRad*2+separation, 0])
    translate([0, bZ/2+thick, 0])
      placeSupport2D();
}

module layout3D(uDivX, uDivY, uDivZ, uDivLX, uDivLY, alp=0.5) {
  //amount to shift for cut depth 
  D=thick/2;


  //bottom of box (B-)
  color("green", alpha=alp)
    translate([0, 0, 0])
    linear_extrude(height=thick, center=true) faceB(uDivX, uDivY, uDivZ, uDivLX, 
      uDivLY, makeLid=0);

  if (addLid) {
    color("lime", alpha=alp)
      translate([0, 0, bZ-thick])
      linear_extrude(height=thick, center=true) faceB(uDivX, uDivY, uDivZ, uDivLX, 
        uDivLY, makeLid=1);
  }

  color("red", alpha=alp)
    translate([0, bY/2-D, bZ/2-D]) rotate([90, 0, 0])
    linear_extrude(height=thick, center=true) faceA(uDivX, uDivY, uDivZ, uDivLX, 
      uDivLY);

  color("darkred", alpha=alp)
    translate([0, -bY/2+D, bZ/2-D]) rotate([90, 0, 0])
    linear_extrude(height=thick, center=true) faceA(uDivX, uDivY, uDivZ, uDivLX, 
      uDivLY);
   
  color("blue", alpha=alp)
    translate([bX/2-D, 0, bZ/2-D]) rotate([90, 0, 90])
    linear_extrude(height=thick, center=true) faceC(uDivX, uDivY, uDivZ, uDivLX, 
      uDivLY);
  color("darkblue", alpha=alp)
    translate([-bX/2+D, 0, bZ/2-D]) rotate([90, 0, 90])
    linear_extrude(height=thick, center=true) faceC(uDivX, uDivY, uDivZ, uDivLX, 
      uDivLY);
  

}


module main() {
  //Calculate the maximum number of fingers and cuts possible
  maxDivX=floor(bX/fingerW);
  maxDivY=floor(bY/fingerW);
  maxDivZ=floor(bZ/fingerW);

  //Calculate the max number of fingers and cuts for the lid
  maxDivLX=floor(bX/fingerLidW);
  maxDivLY=floor(bY/fingerLidW);

  //the usable divisions value must be odd for this layout
  uDivX= (maxDivX%2)==0 ? maxDivX-3 : maxDivX-2;
  uDivY= (maxDivY%2)==0 ? maxDivY-3 : maxDivY-2;
  uDivZ= (maxDivZ%2)==0 ? maxDivZ-3 : maxDivZ-2;
  uDivLX= (maxDivLX%2)==0 ? maxDivLX-3 : maxDivLX-2;
  uDivLY= (maxDivLY%2)==0 ? maxDivLY-3 : maxDivLY-2;

  if(2D) {
    layout2D(uDivX, uDivY, uDivZ, uDivLX, uDivLY);
  } else {
    layout3D(uDivX, uDivY, uDivZ, uDivLX, uDivLY);
  }
}

main();

