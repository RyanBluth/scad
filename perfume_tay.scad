$fn = 300;

/// sizes = [[diameter, row_count], ...]
/// columns = number of columns
module perfumeTray(sizes = [ [], [] ], columns) {
  maxDiameter = maxDiameter(sizes = sizes);
  totalRows = countRows(sizes = sizes);
  spacing = 8;
  height = 15;

  width = totalRows * (maxDiameter + spacing);
  depth = columns * (maxDiameter + spacing);

  difference() {
    minkowski() {
      translate([ 4, 4, 0 ]) { cube([ width - 8, depth - 8, height / 2 ]); }
      cylinder(h = height / 2, r = 4);
    }

    for (i = [0:len(sizes) - 1]) {
      for (column = [0:columns - 1]) {
        // Calculate starting row for current size group
        startingRow =
            (i == 0) ? 0 : countRows(sizes = [for (j = [0:i - 1]) sizes[j]]);

        // Create rows for current diameter
        for (row = [0:sizes[i][1] - 1]) {
          currentRow = startingRow + row;
          translate([
            (currentRow * (maxDiameter + spacing)) +
                (maxDiameter + spacing) / 2,
            (column * (maxDiameter + spacing)) + (maxDiameter + spacing) / 2, 3
          ]) {

            minkowski() {
                cylinder(h = 17, d = sizes[i][0]);
            }

            translate([ 0, 0, height - 3 - 2]) {
                cylinder(h = 3, r1 = sizes[i][0] / 2, r2 = sizes[i][0] / 2 * 1.2);
            }
          }
        }
      }
    }
  }
}

function maxDiameter(sizes, current_index = 0, current_max = 0) =
    current_index < len(sizes)
        ? maxDiameter(sizes, current_index + 1,
                      max(current_max, sizes[current_index][0]))
        : current_max;

function countRows(sizes, current_index = 0, current_count = 0) =
    current_index < len(sizes)
        ? countRows(sizes, current_index + 1,
                    current_count + sizes[current_index][1])
        : current_count;

largeBottleDiameter = 10.6;
smallBottleDiameter = 8.3;
perfumeTray(sizes = [[smallBottleDiameter, 4], [largeBottleDiameter, 2]],
            columns = 3);