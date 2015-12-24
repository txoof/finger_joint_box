//Create a laser cut box with notches

bX=68;
bY=60;
bZ=60;

//Material thickness - Width Z
cZ=3.5;

//Cut/tab - Width X
cX=8;

//overage for cutting
O=0.1;

//Faces 2, 4

// Calculate the maximum number of whole cuts and tabs possible
totTabX=floor(bX/cX);
totTabZ=floor(bZ/cX);
echo("total tabs X", totTabX);
echo("total tabs Z", totTabZ);

// Number of cuts X - 2 end tabs
endTabX=((bX-(totTabX-2)*cX)/2);
echo("endTabX", endTabX);

endTabZ=((bZ-(totTabZ-2)*cX)/2);
echo("endTabZ", endTabZ);

//Number of cuts along X edge (X axis in OpenSCAD)

cutsX=floor(bX/(cX*2));

//Number of cuts along Z edge (Y axis in OpenSCAD)
cutsZ=floor(bZ/(cX*2));

echo("cutsX", cutsX);
//cutsZ=floor(bZ/(cX*2));
echo("cutsZ", cutsZ);


//Faces 2, 4
difference() {
  square([bX, bZ], center=true);


  // X+/- edge (X axis in OpenSCAD)
  if ( cutsX%2==0 ) {
    echo ("even cutsX");
    for (i = [0:cutsX-2]) {
      #translate([(bX/2-cX/2-endTabX)-cX*2*i, bZ/2-cZ/2, 0]) 
        square([cX+O, cZ+O], center=true);
      #translate([(bX/2-cX/2-endTabX)-cX*2*i, -bZ/2+cZ/2, 0]) 
        square([cX+O, cZ+O], center=true);
    } // end EVEN cutsX
  } else {
    for (i = [0:cutsX-1]) {
      #translate([(bX/2-cX/2-endTabX)-cX*2*i, bZ/2-cZ/2, 0])
        square([cX+O, cZ+O], center=true);
      #translate([(bX/2-cX/2-endTabX)-cX*2*i, -bZ/2+cZ/2, 0])
        square([cX+O, cZ+O], center=true); 
    } // end ODD cutsX
  } // end cutsX

  // Z+/- edge (Y axis in OpenSCAD) 
  for (j = [0:cutsZ-1]) {
    #translate([bX/2-cZ/2, (bZ/2-cX/2-endTabZ)-cX*2*j, 0])
      square([cZ+O, cX+O], center=true);
    #translate([-bX/2+cZ/2, (bZ/2-cX/2-endTabZ)-cX*2*j, 0])
      square([cZ+O, cX+O], center=true);
  } // end X+/- edge

}
*color("blue")translate([bX/2-endTabX/2, bZ/2-endTabZ/2, .1])square([endTabX, endTabZ], center=true);
*color("green")translate([-bX/2+endTabX/2, bZ/2-endTabX/2, .1])square([endTabX, endTabZ], center=true);
*color("orange")translate([bX/2-endTabX/2, -bZ/2+endTabZ/2, .1])square([endTabX, endTabZ], center=true);
*color("red")translate([-bX/2+endTabX/2, -bZ/2+endTabZ/2, .1]) square([endTabX, endTabZ], center=true);

