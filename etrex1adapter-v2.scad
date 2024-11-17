//////////////////////////////////////////////////////////////////////////////////////
///
///  eTrex1Adapter - Screw-on adapter for Garmin eTrex Vista/Legend/... C/Cx/HCx
///                  GPS device to allow use with bike and car mounts
///
///                  The original adapter is included when buying the GPS device,
///                  but in case you lost it or you broke it, it's nice to be
///                  able to print a new one...
///
///                  Needs a 10mm long screw with UNC #4-40 thread to fit thread
///                  on eTrex battry cover.
///        
//////////////////////////////////////////////////////////////////////////////////////
///
///  2013-10-17 Heinz Spiess, Switzerland
///
///  released under Creative Commons - Attribution - Share Alike licence
//////////////////////////////////////////////////////////////////////////////////////

$fn = 60;

module etrex1adapter(supports=false,eps=0.5){

   bh = 32.5;  // main body height
   bw = 16;  // main body width
   bd = 6.75;   // main body depth
   rw = 1.75; // width of rail groove
   rd = 2.4;  // depth of rail groove
   ro = 1.8;    // offset of rail groove
   rh1 = 8.5; // height of first rail bridge
   rh2 = 20.5;  // height of rail hangover
   rh3 = 30;  // height of second rail bridge
   kr = 2;    // radius of left and right cutouts 
   sh = 12; // height of screw center
   //eps = 0.5; // separation of tongue
   tw = 7;    // tongue width
   th = 14;   // tongue height
    
    

    difference(){
        union(){
           //main body
           translate([-bw/2,0,0])cube([bw,bd,bh]);
           
           // Nub
           translate([0 - 0.45,-1.5 - 0.65, sh + 6.5 - 2.5]){
               cube([0.9, 0.65, 1.30]);
           }
           
           // Nub
           translate([0 - 0.45,-1.5 - 0.65, sh - 6.5 + 2.5 - 1.25]){
               cube([0.9, 0.65, 1.30]);
           }
            
           // screw reinforcing
           translate([0,-1.5,sh])rotate(-90,[1,0,0])cylinder(r2=6.5,r1=6.5,h=1.6);
           // clip part of tongue
           hull(){
              translate([-tw/2,bd-1,bh-4.5])cube([tw,1,4.5]);
              translate([-tw/2+1.5,bd-1.5,bh-1.5])cube([tw-3,3,1.5]);
           }
           // lower part of tongue finger rest
           hull(){
              translate([-tw/2,0.75*bd-0.25,bh-0.1])cube([tw,bd/4+0.25,0.1]);
              translate([-bw/2,2*bd/4,bh+th/4-0.1])cube([bw,bd/2,0.1]);
           }
           // middle part of tongue finger rest
           hull(){
              translate([-bw/2,2*bd/4,bh+th/4-0.1])cube([bw,bd/2,0.1]);
              translate([-bw/2,bd/3,bh+0.7*th-0.1])cube([bw,bd/2,0.1]);
           }
           // upper part of tongue finger rest
           hull(){
              translate([-bw/2,bd/3,bh+0.7*th-0.1])cube([bw,bd/2,0.1]);
              translate([-bw/3,2*bd/3,bh+th-0.1])cube([2*bw/3,bd/3,0.1]);
           }
        }
        // show radius of battery opening lever
        //%translate([0,-2,-4])rotate(-90,[1,0,0])cylinder(r=5,h=bd+2);
        // cavity to allow opening of battery case while adapter is mounted
        //hull(){
          // translate([-tw/2,-1,-1])cube([tw,bd+2,1]);
           //translate([-tw/2+1.5,-1,-1])cube([tw-3,bd+2,3]);
        
        rotate([0, 90, 90]) {
            translate([10-1.4, 0, -0.1]) {
                cylinder(r1=10,r2=10,h=bd * 1.2);
            }
        };

        //}
        for(s = [-1,1])scale([s,1,1]){
            // left and right slide rails
            translate([-bw/2-1,bd-rd-ro,-1])cube([1+rw+0.25,rd,1+rh1]);
        translate([-bw/2-1,bd-rd-ro,rh1+1])cube([1+rw+0.25,rd,rh3-rh1-1]);
        hull(){
           translate([-bw/2-0.1,bd-rd-ro,rh1+1])cube([0.1,bd,rh2-rh1]);
           translate([-bw/2+rw-0.1,bd-rd-ro,rh1+1])cube([0.1,bd,rh2-rh1-1]);
        }
        // left and right grooves to fit bumps on GPS battery cover
        translate([-bw/2,-1,-1])cylinder(r=kr,rh3-1,$fn=20);
        translate([-bw/2,-1,rh3-0.3-kr])sphere(r=kr,$fn=20);
        // tongue cutouts
        translate([-tw/2-eps,bd/2-0.25,18])cube([eps,bd/2+0.5,bh-18+0.1]);
        translate([-tw/2-eps,bd/2-0.25,18])cube([tw/2+eps+0.1,bd/4,bh-18+0.1]);
        }
        // screw hole
        translate([0,-5,sh])rotate(-90,[1,0,0])rotate(supports?30:0)cylinder(r=1.25,h=bd+6,$fn=10);
        // cavity for screw head
        translate([0,4.75,sh])rotate(-90,[1,0,0])cylinder(r1=5,r2=5,h=.3*bd+0.1);
        // cavity for screw nut cylinder on battery cover
        
        translate([0,-1.6,sh])rotate(-90,[1,0,0])cylinder(r1=4,r2=4,h=3.8);
    }
    color("red")if(supports){
       for(z = [bh-1,22,27]){
          for(s = [-1,1])scale([s,1,1]) translate([-tw/2-eps,3*bd/4,z])cube([eps,bd/4,1]);
          translate([-tw/2-eps,bd/2-0.5,z])cube([eps/3,bd/2,1]);
       }
       hull(){
         translate([bw/2-0.1,bd-ro,(rh1+rh2)/2-2])cube([0.1,ro,4]);
         translate([bw/2-rw,bd-ro,(rh1+rh2)/2-0.5])cube([rw,ro,1]);
       }
       
        rotate(-90,[0,1,0]) {
            translate([sh - 4.5, -1.8, -8]){
                cylinder(h=sh * 0.628, r1=0.2, r2=0.2);
            }
         
        }
           
        rotate(-90,[0,1,0]) {
            translate([sh + 4.5, -1.8, -8]){
                cylinder(h=sh * 0.628, r1=0.2, r2=0.2);
            }
         
        }
        
        translate([bw * 0.5 - 0.05, -3, 6]){
            cube([0.1, 3, 12]);
        }
        
    }
}

// ...on the following lines you have to activate the desired object by uncommenting...

// uncomment the following for vertical printing
// (prints well but needs good printing quality for the tongue to be strong enough)
//etrex1adapter();

// for horizontal printing, uses explicit supports (red!) that need to be cut after printing
// (print is stronger, as the layers are parallel to the flexible tonguei
// and has less friction sind layers are parallel to sliding direction)
//translate([15,0,8])rotate(90,[0,1,0])etrex1adapter(supports=true,eps=0.75);
translate([0,0,8])rotate(90,[0,1,0])etrex1adapter(supports=true,eps=0.75);
