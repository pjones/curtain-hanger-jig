include <jig.scad>

// The solid shape of an oval hanger.
module curtain_oval_holder_shape(width, height, thickness)
{
  resize(newsize=[0, height, 0])
    linear_extrude(height=thickness)
    circle(d=width);
}

// An oval-shaped curtain rod hanger.
module curtain_oval_holder(
  // Distance from the windowsill to the center of the hanger in the
  // horizontal direction.
  horizontal_offset,

  // Distance from the windowsill to the center of the hanger in the
  // vertical direction.
  vertical_offset,

  // How wide is the oval hanger at its widest?
  width,

  // How tall is the oval hanger?
  height,

  // How think to make the jig.
  thickness=default_thickness)
{
  difference() {
    union() {
      curtain_hanger_jig(horizontal_offset, vertical_offset, thickness);

      translate([horizontal_offset, vertical_offset, 0])
        resize(newsize=[width+thickness*2, height+thickness*2, 0])
        curtain_oval_holder_shape(width, height, thickness);
    }

    translate([horizontal_offset, vertical_offset, 0]) {
      curtain_oval_holder_shape(width, height, thickness);
      translate([-(horizontal_offset/2), 0, 0])
        cube([horizontal_offset, vertical_offset, thickness]);
    }
  }
}
