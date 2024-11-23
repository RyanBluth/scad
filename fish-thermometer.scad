$fn = 20;

module roundedBox(width, depth, height, wallThickness = 0.75) {
  /*

  z -- y
  |
  x

  ----------
  |1      2|
  |        |
  |3      4|
  ----------
  */

  // Difference between two cubes to create a hollow cube
  difference() {
    // Create the outer wall by doing a hull of a cube and 4 cylinders for
    // rounded corners
    hull() {
      translate([ wallThickness, wallThickness, wallThickness ]) {
        cube([
          width - wallThickness * 2, depth - wallThickness * 2, height -
          wallThickness
        ]);
      }
      for (x = [ wallThickness, width - wallThickness ]) {
        for (y = [ wallThickness, depth - wallThickness ]) {
          translate([ x, y, wallThickness ]) {
            cylinder(height - wallThickness, r = wallThickness);
            sphere(r = wallThickness);
          }
        }
      }
    }
    // Translate up by the wall thickness to create the floor
    translate([ wallThickness, wallThickness, wallThickness ]) {
      cube([
        width - wallThickness * 2, depth - wallThickness * 2, 1.1 * height
      ]);
    }
  }
}

module screwPost(height, radius, holeHeight, holeRadius) {
  translate([ radius, radius, 0 ]) {
    difference() {
      cylinder(height, r = radius);
      translate([ 0, 0, height - holeHeight ]) {
        cylinder(holeHeight, r = holeRadius);
      }
    }
  }
}

module projectBox(width, depth, height, wallThickness = 0.75,
                  threadedInsertRadius = 0.6, threadedInsertHeight = 2,
                  lidInsetThickness = 0.5, lidInsetDepth = 3,
                  screwHoleRadius = 0.3, screwPostRadius = 1.2) {
  threeQuarterWallThickness = wallThickness * 0.75;

  union() {
    roundedBox(width = width, depth = depth, height = height,
               wallThickness = wallThickness);

    // Add screw posts
    screwPostHeight = height - lidInsetDepth;
    for (x = [
           threeQuarterWallThickness, width - screwPostRadius * 2 -
           threeQuarterWallThickness
         ]) {
      for (y = [
             threeQuarterWallThickness, depth - screwPostRadius * 2 -
             threeQuarterWallThickness
           ]) {
        translate([ x, y, wallThickness ]) {
          screwPost(height = screwPostHeight, radius = screwPostRadius,
                    holeHeight = threadedInsertHeight,
                    holeRadius = threadedInsertRadius);
        }
      }
    }
  }
}

module projectBoxLid(width, depth, height, wallThickness = 0.75,
                     threadedInsertRadius = 0.6, threadedInsertHeight = 2,
                     lidInsetThickness = 0.5, lidInsetDepth = 1,
                     screwHoleRadius = 0.3, screwPostRadius = 1.2,
                     screwHeadInsetRadius = 0.6, screwHeadInsetDepth = 0.3) {
  threeQuarterWallThickness = wallThickness * 0.75;

  union() {
    difference() {
      roundedBox(width = width, depth = depth, height = height,
                 wallThickness = wallThickness);

      for (x = [
             threeQuarterWallThickness + screwPostRadius,
             width - threeQuarterWallThickness -
             screwPostRadius
           ]) {
        for (y = [
               threeQuarterWallThickness + screwPostRadius,
               depth - threeQuarterWallThickness -
               screwPostRadius
             ]) {
          translate([ x, y, 0 ]) {
            cylinder(h = wallThickness + height + lidInsetDepth,
                     r = screwHoleRadius);
            cylinder(h = screwHeadInsetDepth, r = screwHeadInsetRadius);
          }
        }
      }
    }

    // Add screw posts
    difference() {
      union() {
        threeQuarterWallThickness = wallThickness * 0.75;
        screwPostHeight = height + lidInsetDepth;

        // Lid screw posts
        for (x = [
               threeQuarterWallThickness, width - screwPostRadius * 2 -
               threeQuarterWallThickness
             ]) {
          for (y = [
                 threeQuarterWallThickness, depth - screwPostRadius * 2 -
                 threeQuarterWallThickness
               ]) {
            translate([ x, y, wallThickness ]) {
              screwPost(height = screwPostHeight - wallThickness,
                        radius = screwPostRadius, holeHeight = screwPostHeight,
                        holeRadius = screwHoleRadius);
            }
          }
        }
      }

      translate([ 0, 0, 0 ]) {
        // Trim the screw posts so they don't overflow into the walls
        roundedBox(width = width, depth = depth,
                   height = height + lidInsetDepth,
                   wallThickness = wallThickness);
      }
    }
  }

  // Lid inset
  translate([ wallThickness, wallThickness, wallThickness ]) {
    difference() {
      cube([
        width - wallThickness * 2, depth - wallThickness * 2,
        lidInsetDepth + height -
        wallThickness
      ]);
      translate([ lidInsetThickness, lidInsetThickness, 0 ]) {
        cube([
          width - wallThickness * 2 - lidInsetThickness * 2,
          depth - wallThickness * 2 - lidInsetThickness * 2,
          lidInsetDepth + height + 1
        ]);
      }
    }
  }
}

module display() {
  difference() {
    holeRadius = 3.5 / 2;
    color([ 0.9, 0, 0 ]) { cube([ displayWidth, displayDepth, 1.5 ]); }
    for (x = [ 1.2 + holeRadius, displayWidth - holeRadius - 1.2 ]) {
      for (y = [ 1.2 + holeRadius, displayDepth - holeRadius - 1.2 ]) {
        translate([ x, y, -0.1 ]) { cylinder(h = 2, r = holeRadius); }
      }
    }
  }

  translate([ 9, 4, 1.5 ]) {
    color([ 1, 0, 0 ]) { cube([ 50, 19, 8 ]); }
  }
}

module raisedFloor() {
  union() {
    difference() {
      translate([ wallThickness * 2.5, wallThickness * 2.5, 0 ]) {
        cube([
          boxWidth - wallThickness * 5, boxDepth - wallThickness * 5, 1.1 *
          wallThickness
        ]);
      }

      translate([ 0, 0, -10 ]) { displaySupport(); }

      translate([ 0, 0, -20 ]) {
        projectBox(boxWidth, boxDepth, boxHeight, threadedInsertHeight = 4,
                   threadedInsertRadius = boxThreadedInsertRadius,
                   screwPostRadius = 5, lidInsetDepth = lidInset,
                   wallThickness = wallThickness);
      }

      for (x = [
             10 + screwHoleRadius * 4 + wallThickness,
             boxWidth - 10 - screwHoleRadius * 4 -
             wallThickness
           ]) {
        for (y = [ 24 - screwHoleRadius * 4, boxDepth - 50 ]) {
          translate([ x, y, 0 ]) { cylinder(h = 10, r = 0.5); }
        }
      }
    }

    translate([ 100, 15, 0 ]) {
      rotate([ 0, 0, 90 ]) { circuitBoardPosts(); }
    }

    translate([ 63, 27, 0 ]) {
      rotate([ 0, 0, 90 ]) {
        batteryHolderPosts();
      }
    }
  }
}

module displaySupport() {
  width = displayWidth + 10;
  depth = displayDepth + 5;
  translate([
    boxWidth / 2 - width / 2, boxDepth - depth - wallThickness,
    wallThickness
  ]) {
    difference() {
      cube([
        width, depth,
        boxHeight - wallThickness - displayTotalHeight + displayZInset +
        lidHeight
      ]);

      translate([ 0, 8, boxHeight - wallThickness - displayTotalHeight ]) {
        cube([ width, 16, 7 ]);
      }

      for (x = [ 8, width - 8 ]) {
        for (y = [ 5, depth - 6 ]) {
          translate([ x, y, boxHeight - wallThickness - displayTotalHeight ]) {
            cylinder(h = 12, r = screwHoleRadius);
          }
        }
      }
    }
  }
}

module xlrJack(screwHoles = true) {
  difference() {
    union() {
      cube([ xlrJackWidth, 1.88, xlrJackHeight ]);

      translate([ xlrJackWidth / 2, 0, 35.63 / 2 ]) {
        rotate([ 90, 0, 0 ]) { cylinder(h = 28.43, r = xlrJackMainRadius); }
      }
      translate([
        xlrJackWidth / 2 - 9.8 / 2, -20.46,
        35.63 / 2 + xlrJackMainRadius - 1.78 / 2
      ]) {
        cube([ 9.8, 20.46, 1.78 ]);
      }

      translate([
        xlrJackWidth / 2 - 9.8 / 2, -21.46,
        35.63 / 2 + xlrJackMainRadius + 1.78 / 2
      ]) {
        cube([ 9.8, 10, 1.19 ]);
      }
    }

    translate([ 3, 2, 3 ]) {
      rotate([ 90, 0, 0 ]) { cylinder(h = 4, d = 4); }
    }

    translate([ xlrJackWidth - 3, 2, 35.63 - 3 ]) {
      rotate([ 90, 0, 0 ]) { cylinder(h = 4, d = 4); }
    }
  }

  if (screwHoles) {
    translate([ 3, 2, 3 ]) {
      rotate([ 90, 0, 0 ]) { cylinder(h = 4, r = screwHoleRadius); }
    }

    translate([ xlrJackWidth - 3, 2, 35.63 - 3 ]) {
      rotate([ 90, 0, 0 ]) { cylinder(h = 4, r = screwHoleRadius); }
    }
  }
}

module circuitBoard() {
  difference() {
    cube([ 70, 30, 1.5 ]);

    for (x = [ 1.5, 70 - 1.5 ]) {
      for (y = [ 1.5, 30 - 1.5 ]) {
        translate([ x, y, 0 ]) { cylinder(h = 2, r = 1); }
      }
    }
  }
}

module circuitBoardPosts() {
  color([ 0.3, 0.4, 0.5 ]) {
    postRadius = 3;
    for (x = [ 1.5 - postRadius, 70 - 1.5 - postRadius ]) {
      for (y = [ 1.5 - postRadius, 30 - 1.5 - postRadius ]) {
        translate([ x, y, 0 ]) {
          screwPost(height = 10, radius = postRadius, holeHeight = 4,
                    holeRadius = 0.5);
        }
      }
    }
  }
}

module batteryHolder() {
  cube([ 48, 52, 12 ]);

  translate([ 18, 26, 0 ]) { cylinder(h = 20, r = 1); }

  translate([ 48 - 18, 26, 0 ]) { cylinder(h = 20, r = 1); }
}

module batteryHolderPosts() {
  color([ 0.7, 0.6, 0.4 ]) {
    postRadius = 3;

    translate([ 18 - postRadius, 26 - postRadius, 0 ]) {
      screwPost(height = 10, radius = postRadius, holeHeight = 4,
                holeRadius = 0.5);
    }

    translate([ 48 - 18 - postRadius, 26 - postRadius, 0 ]) {
      screwPost(height = 10, radius = postRadius, holeHeight = 4,
                holeRadius = 0.5);
    }
  }
}

xlrJackWidth = 26.4;
xlrJackHeight = 35.63;
xlrJackMainRadius = 21.62 / 2;

displayWidth = 66;
displayDepth = 27;
displayTotalHeight = 9.5;
displayZInset = 0.3;
displayYInset = 3;

boxWidth = 120;
boxDepth = 130;
boxHeight = 60;
boxThreadedInsertRadius = 5.3 / 2;
wallThickness = 3;

lidHeight = 6;
lidInset = 6;
lidScrewHoleRadius = 1.6;

screwHoleRadius = 0.5;

raisedFloorScrewPostHeight = 20;

box = true;
lid = true;
raisedFloor = true;
raisedFloorInReferencePosition = true;
lidInReferencePosition = false;
referenceDisplay = true;
difference() {
  union() {
    if (lid) {
      if (lidInReferencePosition) {
        translate([ boxWidth, 0, boxHeight + lidHeight ]) {
          rotate(a = [ 0, 180, 0 ]) {
            color(alpha = 0.5) {
              projectBoxLid(
                  boxWidth, boxDepth, lidHeight, lidInsetDepth = lidInset,
                  screwPostRadius = 4, screwHoleRadius = lidScrewHoleRadius,
                  wallThickness = wallThickness, lidInsetThickness = 2,
                  screwHeadInsetDepth = 1.5, screwHeadInsetRadius = 2.5);
            }
          }
        }
      } else {
        projectBoxLid(boxWidth, boxDepth, lidHeight, lidInsetDepth = lidInset,
                      screwPostRadius = 4, screwHoleRadius = lidScrewHoleRadius,
                      wallThickness = wallThickness, lidInsetThickness = 2,
                      screwHeadInsetDepth = 1.5, screwHeadInsetRadius = 2.5);
      }
    }

    if (raisedFloor) {
      translate([
        raisedFloorInReferencePosition ? 0 : -100,
        raisedFloorInReferencePosition ? 0 : 0,
        raisedFloorInReferencePosition
            ? raisedFloorScrewPostHeight + wallThickness
            : 0
      ]) {
        raisedFloor();
      }
    }

    if (box) {
      projectBox(boxWidth, boxDepth, boxHeight, threadedInsertHeight = 4,
                 threadedInsertRadius = boxThreadedInsertRadius,
                 screwPostRadius = 4, lidInsetDepth = lidInset,
                 wallThickness = wallThickness);

      if (referenceDisplay) {
        // Position the display for reference
        translate([
          boxWidth / 2 - displayWidth / 2,
          boxDepth - displayDepth - displayYInset - wallThickness,
          boxHeight - displayTotalHeight +
          lidHeight
        ]) {
          display();
        }
      }

      displaySupport();

      // Gasket lip
      color([ 0, 0.7, 0 ]) {
        difference() {
          translate(
              [ wallThickness, wallThickness, boxHeight - lidInset - 1 ]) {
            difference() {
              cube([
                boxWidth - wallThickness * 2, boxDepth - wallThickness * 2,
                wallThickness
              ]);
              difference() {
                translate([ wallThickness, wallThickness, -0.1 ]) {
                  cube([
                    boxWidth - wallThickness * 4, boxDepth - wallThickness * 4,
                    wallThickness * 2
                  ]);
                }
              }
            }
          }
          for (x = [ wallThickness * 2, boxWidth - wallThickness * 2 ]) {
            for (y = [ wallThickness * 2, boxDepth - wallThickness * 2 ]) {
              translate([ x, y, -0.1 ]) {
                cylinder(h = 100, r = boxThreadedInsertRadius);
              }
            }
          }
        }
      }

      // Raised floor screw posts
      for (x = [ 10 + wallThickness, boxWidth - 10 - wallThickness - 4 ]) {
        for (y = [ 20, boxDepth - 50 ]) {
          translate([ x, y, wallThickness ]) {
            screwPost(height = raisedFloorScrewPostHeight, radius = 2,
                      holeHeight = 4, holeRadius = 0.5);
          }
        }
      }
    }
  }

  translate([ boxWidth / 2, boxDepth - 20, xlrJackHeight / 2 + 20 ]) {
    rotate([ 90, 0, 0 ]) { cylinder(h = 20, r = xlrJackMainRadius * 0.8); }
  }

  translate([ boxWidth / 2 - xlrJackWidth / 2, boxDepth, 20 ]) { xlrJack(); }
}

translate([ -100, 0, 0 ]) { circuitBoard(); }

translate([ -200, 0, 0 ]) { batteryHolderPosts(); }

translate([ -200, 0, 0 ]) { batteryHolder(); }