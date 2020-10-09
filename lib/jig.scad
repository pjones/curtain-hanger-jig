default_thickness = 3;

// A guide arm that goes into one side of a windowsill corner.
module curtain_guide(guide_width, guide_length, thickness) {
  translate([-(guide_length/2), -(guide_width/2), 0])
    cube([guide_length, guide_width, thickness]);

  translate([-(guide_length/2), -(guide_width/2), 0])
    cube([guide_width, thickness, guide_length]);
}

// Two guide arms, one for each side of a windowsill corner.
module curtain_guides(guide_width, guide_length, thickness)
{
  // Left arm:
  translate([-(guide_length/2),
             guide_width/2 - thickness,
             0])
    curtain_guide(guide_width, guide_length, thickness);

  // Right arm:
  translate([guide_width/2 - thickness,
             -(guide_length/2),
             , 0])
    rotate([0, 0, -90])
    mirror([1, 0, 0])
    curtain_guide(guide_width, guide_length, thickness);

  // Connection point.
  translate([guide_width/2 - thickness,
             guide_width/2 - thickness,
             thickness/2])
    cube([guide_width,
          guide_width,
          thickness], center=true);
}

// https://en.wikipedia.org/wiki/Solution_of_triangles#Two_sides_and_the_included_angle_given_(SAS)
function curtain_sas(A, b, c) =
  let ( a = sqrt(pow(b, 2) + pow(c, 2) - (2 * b * c * cos(A)))
      , B = acos((pow(c, 2) + pow(a, 2) - pow(b, 2)) / (2 * c * a))
      , C = 180 - B - A
      )
  [a, B, C];

// Construct an arm to offset the hole jig.
/*
      Target Holder Location
               /|
              / |
             /  |
            / B |
           /    | <- Vertical offset
       a  /     |
         /      |
        /       | c
       /        |
      /         |
     /          |
    /           |
   / C        A |
   \____________/
         b

  Horizontal offset

*/
module curtain_offset_arm(horizontal_offset, vertical_offset, width, thickness)
{
  saa = curtain_sas(90, horizontal_offset, vertical_offset);
  length = saa[0];
  angle = -saa[2];

  difference() {
    rotate([0, 0, angle])
      translate([-(width/2), 0, 0])
      cube([width, length, thickness]);

    union() {
      translate([0, vertical_offset, -0.1])
        cube([horizontal_offset + width, width, thickness + 0.2]);

      translate([horizontal_offset, 0, -0.1])
        cube([width, vertical_offset, thickness + 0.2]);
    }
  }
}

// A curtain hanger jig with an arm that points to the center of where
// the rod hanger should go.
module curtain_hanger_jig(
  horizontal_offset,
  vertical_offset,
  thickness = default_thickness)
{
  guide_width = 8;
  guide_length = 20;

  curtain_guides(guide_width, guide_length, thickness);
  curtain_offset_arm(horizontal_offset, vertical_offset, guide_width, thickness);
}
