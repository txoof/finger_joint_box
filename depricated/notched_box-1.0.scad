//Create a laser cut box with notches

bX=100;
bY=60;
bZ=100;

//Material thickness - Depth
cutD=3.5;

//Cut/tab - Width 
cutW=8;

//overage for cutting
cutter=0.1;

//seperation for layout
seperation=1; 

// Calculate the maximum number of whole cuts and tabs possible
// Calculate the *total* number of normal tabs (discounting end tabs)
//  if the MAX is even, subtract 3, if odd, subtract 2 for the ACTUAL number of tabs
maxTabX=floor(bX/cutW);
totalTabX= (maxTabX%2)==0 ? maxTabX-3 : maxTabX-2;
maxTabY=floor(bY/cutW);
totalTabY= (maxTabY%2)==0 ? maxTabY-3 : maxTabY-2;
maxTabZ=floor(bZ/cutW);
totalTabZ= (maxTabZ%2)==0 ? maxTabZ-3 : maxTabZ-2;
echo("max tabs X", maxTabX);
echo("total tabs X", totalTabX);
echo("max tabs Y", maxTabY);
echo("total tabs Y", totalTabY);
echo("max tabs Z", maxTabZ);
echo("total tabs Z", totalTabZ);



//#FIXME  I did not take into account the width of the cutter.  
// *** need to shift over by cutter width?  Think about this!


//Faces 2, 4
module faceA() {
  difference() {
    square([bX, bZ], center=true);
    //X+/- edge (X axis in OpenSCAD)
    //#translate([((maxTabX-2)*-cutW)/2, bZ/2-cutD, 0]) 
    translate([totalTabX*-cutW/2, bZ/2-cutD, 0])
      insideCuts(bX, maxTabX, cutter);
    translate([totalTabX*-cutW/2, -bZ/2, 0])
      insideCuts(bX, maxTabX, cutter);

    //Z+/- (Y axis in OpenSCAD) 
    translate([bX/2-cutD, totalTabZ*cutW/2, 0])rotate([0, 0, -90])
      insideCuts(bZ, maxTabZ, cutter);
    translate([-bX/2, totalTabZ*cutW/2, 0])rotate([0, 0, -90])
      insideCuts(bZ, maxTabZ, cutter);

  }
} // end faceA


module faceB() {
  endCutX=(bX-totalTabX*cutW)/2;
  echo("endCutX", endCutX);
  difference() {
    square([bX, bY], center=true);
    //X+/- edge (X axis in OpenSCAD)
    //#translate([(maxTabX*-cutW)/2-endCutX+cutW, bY/2-cutD, 0])
    //  outsideCuts(bX, maxTabX, cutter, endCutX);
    #translate([-bX/2, bY/2-cutD, 0])
      outsideCutsNew(bX, totalTabX, cutter, endCutX);
      
    #translate([-bX/2, -bY/2, 0])
      outsideCuts(bX, maxTabX, cutter, endCutX);

    //Y+/- edge (Y axis in OpenSCAD)
    *translate([bX/2-cutD, ((maxTabY-2)*cutW)/2, 0])rotate([0, 0, -90])
      insideCuts(bY, maxTabY, cutter);
    *translate([-bX/2, ((maxTabY-2)*cutW)/2, 0])rotate([0, 0, -90])
      insideCuts(bY, maxTabY, cutter);
  }
} // end faceB

module faceC() {
  endCutY=(bY-(maxTabY-2)*cutW)/2;
  endCutZ=(bZ-(maxTabZ-2)*cutW)/2;

  difference() {
    square([bZ, bY], center=true);
    //Z+/- edge (X axis in OpenSCAD)
    translate([(maxTabZ*-cutW)/2-endCutZ+cutW, bY/2-cutD, 0])
      outsideCuts(bZ, maxTabZ, cutter, endCutZ);
    translate([(maxTabZ*-cutW)/2-endCutZ+cutW, -bY/2, 0])
      outsideCuts(bZ, maxTabZ, cutter, endCutZ);

    //Y+/- edge (Y axis in OpenSCAD)
    translate([bZ/2-cutD, (maxTabY*cutW)/2, 0])rotate([0, 0, -90])
      color("blue")outsideCuts(bY, maxTabY, cutter, endCutY);
    translate([-bZ/2, (maxTabY*cutW)/2, 0])rotate([0, 0, -90])
      color("red")outsideCuts(bY, maxTabY, cutter, endCutY);
  }

} //end faceC

//cuts that do not include the outside edge
module insideCuts(len, maxTab, O) {
  //Temporary tab and cut calculations
  numCutsT=floor(maxTab/2); //maximum number of cuts
  echo("numCutsT", numCutsT);
  // there appears to be a problem here *FIXME*
  //numTabsT=floor(floor(len-numCutsT*cutW)/cutW);
  numTabsT=floor((len-numCutsT*cutW)/cutW);
  echo("numTabsT", numTabsT);

  // compare the cuts and tabs; if they are equal subtract one from cuts
  numCuts= numCutsT==numTabsT ? numCutsT-1: numCutsT;

  echo("numCuts", numCuts);

  // draw out squares for cuts
  for (i = [0:numCuts-1]) {
    translate([i*(cutW*2), 0, 0])
      square([cutW+O, cutD+O] );
  } //end for loop
} //end inside cuts

module outsideCutsNew(len, totalTab, O, endCut) {
  numTabs=ceil(totalTab/2);
  numCuts=floor(totalTab/2);
  for (i= [0:totalTab+1]) {
    if (i==0) {
      square([endCut, cutD+0]);
    }

    if (i==totalTab+1) {

    }
  }
}

//cuts that include the inside edge
module outsideCuts(len, maxTab, O, endCut) {
  //Temporary tab and cut calculations
  numTabsT=floor(maxTab/2); //maximum number of cuts
  numCutsT=floor(floor(len-numTabsT*cutW)/cutW);

  // compare the cuts and tabs; if they are equal subtract one from cuts
  numCuts= numCutsT==numTabsT ? numCutsT-1: numCutsT;

  //endCut=(len-(maxTab-2)*cutW)/2;
  // draw out squares for cuts
  for (i = [0:numCuts-1]) {
    // draw the first and last cuts larger
    if (i==0) {
      translate([0, 0, 0])
        square([endCut, cutD+O] );
    }
    if (i==numCuts-1) {
      translate([i*(cutW*2)+endCut-cutW, 0, 0])
        square([endCut, cutD+O]);
    }

    //shift everything over to compensate for the larger first piece
    if (i != 0 && i != numCuts-1) { 
      translate([i*(cutW*2)+endCut-cutW, 0, 0])
        square([cutW+O, cutD+O] );
    } 
  } //end for loop
  
  
}

module layout() {
  faceA();
  color("green")translate([0, -bZ/2-bY/2-seperation, 0]) rotate([0, 0, 0]) faceB();
  color("blue")translate([bX/2+bY/2+seperation, 0, 0]) rotate([0, 0, 90])faceC();
}

*layout();
*translate([bX+bY+seperation*2, -bZ-seperation, 0])rotate([0, 0, -180])
  layout();

faceB();
