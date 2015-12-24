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
  * we do not speak of version 3.4.  That was a terrible idea.
  * trying out lid closures

*/

/*[Box Outside Dimensions]*/
//Box Width - X
bX=45;
//Box Depth - Y
bY=45;
//Box Height - Z
bZ=30;
//Material Thickness
thick=1.2;

/*[Box Features]*/
//Include a lid?
addLid=1; //[1:Lid, 0:No Lid]
//Finger Hole Diameter - 0==no hole
holeDia=10; //[0:50]
holeFacets=36;//[3:36]
addCatch=1;

/*[Finger Width]*/
//Finger width (NB! width must be < 1/3 shortest side)
fingerW=5;//[3:20]
//Lid finger width 
fingerLidW=10;//[3:20]

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

module lidCatch(mNut=3, hole=true, project=false, tab=false) {
  f=1.8*mNut;
  r=(f*1/cos(30))/2;
  cornerR=1;
  catch=r*3-2*cornerR;

  if (project==false) {
    //center on the base of the tab to make positioning easier
    translate([0, -catch/2-cornerR])
    difference() {
    union() {
      hull(center=true) {
          square(catch, center=true);
          translate([catch/2, catch/2])
            circle(r=cornerR, $fn=36);
          translate([-catch/2, catch/2])
            circle(r=cornerR, $fn=36);
          translate([catch/2, -catch/2])
            circle(r=cornerR, $fn=36);
          translate([-catch/2, -catch/2])
            circle(r=cornerR, $fn=36);
        }
        if (hole==true) {
          translate([0, (catch/2+cornerR)+thick/2])
            square([fingerW, thick], center=true);
        }
    }
      if (hole==true) {
        circle(r=r, $fn=6);
      } else {
        circle(r=mNut/2*1.05, $fn=36);
      }

    }
  } else {
    if (tab==true) {
      square([fingerW, thick], center=true);
    } else {
      translate([0, -catch/2-cornerR])
        circle(r=mNut/2*1.05, $fn=36);
    }
  }
  
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
  pctOff=1.02; //offset by this amount

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
    circle(r=lidHoleLoc, $fn=holeFacets);

    if (addCatch==1 && makeLid==1) {
      translate([bX/2-thick/2-thick*pctOff, bY/2-fingerW/2-thick-fingerLidW/2])
        rotate([0, 0, 90])
        lidCatch(project=true, tab=true);
      translate([-1*(bX/2-thick/2-thick*pctOff), bY/2-fingerW/2-thick-fingerLidW/2])
        rotate([0, 0, 90])
        lidCatch(project=true, tab=true);
      translate([-1*(bX/2-thick/2-thick*pctOff), -1*(bY/2-fingerW/2-thick-fingerLidW/2)])
        rotate([0, 0, 90])
        lidCatch(project=true, tab=true);
      translate([(bX/2-thick/2-thick*pctOff), -1*(bY/2-fingerW/2-thick-fingerLidW/2)])
        rotate([0, 0, 90])
        lidCatch(project=true, tab=true);

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

    // add holes that line up with nuts inside 
    if (addCatch==1) {
      #translate([bY/2-fingerW/2-thick-fingerLidW/2, bZ/2-thick, 0])
        lidCatch(project=false, hole=false);
      translate([-1*(bY/2-fingerW/2-thick-fingerLidW/2), bZ/2-thick, 0])
        lidCatch(project=true, hole=false);
    }
      

  }
  
}


//FIXME - the displacement is hard coded.  WRONG WRONG WRONG
module placeCatch2D() {
  for (i=[0:3]) {
    translate([i*(22), 0, 0])
      lidCatch();
    translate([i*(22)+11, 0, 0])
      lidCatch(hole=false);
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

  //FIXME hard coded in!
  translate([0, bZ/2+11, 0])
    placeCatch2D();
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

