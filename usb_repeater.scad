// a sketch of the 20m USB extender from jaycar.
// USB hub with line-driver on a USB socket, in an over-moulding




overmould_dims=[25.6,12.6, 53.6];
overmould_width=overmould_dims[0];
overmould_height=overmould_dims[1];
overmould_length=overmould_dims[2];
overmould_face_width = 22.5;
overmould_face_ramp_len=11;




internal_mould_outline=[
  [ 0, 10-14.5/2],
  [ 14.5/2, 10],
  [ 21/2, 13],
  [ 21/2, 47.5],
  [ 11.5/2, 47.5],
  [ 7.5/2, 50],
  [-7.5/2, 50],
  [-11.5/2, 47.5],
  [-21/2, 47.5],
  [-21/2, 13],
  [-14.5/2, 10],
];
internal_mould_section = [21,7.5];

internal_mould_thickness = internal_mould_section[1];

usb_slot_main_dims=[14.5,7.5];



usb_a_overmould_main_dims=[15.8,7.8];
usb_a_overmould_r=1.5;




module usb_a_overmould_outline(){
  offset(usb_a_overmould_r+0.1)offset(-usb_a_overmould_r)
    square(usb_a_overmould_main_dims, center=true);
}



function usb_repeater_cable_dia() = 4.5;

ellipse_dims=[12,24, 1];
ellipse_centre=[0,0,0];

slot_width=0.8;
slot_depth=0.8;
num_slots=8;
slotting_length=15;
slot_pitch=(slotting_length-slot_width)/num_slots;

overmould_rear=[
  [overmould_face_width/2, 0],
  [overmould_width/2, overmould_face_ramp_len],
  [overmould_width/2, overmould_length],
  [-overmould_width/2, overmould_length],
  [-overmould_width/2, overmould_face_ramp_len],
  [-overmould_face_width/2, 0],
];
overmould_front=[
  [overmould_face_width/2, 0],
  [overmould_width/2, overmould_face_ramp_len],
  [-overmould_width/2, overmould_face_ramp_len],
  [-overmould_face_width/2, 0],
];



rounding_rad_x=1;
rounding_rad_rear=5;
rounding_rad_front=2;
rounding_rad_z=2.5;

/*
offset(r=rounding_rad_rear)
  offset(-rounding_rad_rear)
    polygon(overmould_rear);

offset(r=rounding_rad_front)
  offset(-rounding_rad_front)
    polygon(overmould_front);
*/
module terminal_hub_internal_section(wall=0.2){
  offset(r=1.5+wall)
    offset(r=-1.5)
      square(internal_mould_section, center=true);
}
module terminal_hub_internal(wall=0.2){

  // 2d drawing of the internal overmould
  rotate([90,0,0])
    minkowski(){
      sphere(r=1.5+wall);
      linear_extrude(internal_mould_thickness-3,center=true)
        offset(r=-1.5)
          polygon(internal_mould_outline);
    }

  // usb port
  linear_extrude(15)
    square(usb_slot_main_dims, center=true);
  //greebles in the USB port
  translate([0,0,6])
    linear_extrude(15-6)
      for(x=[-1,1])
        translate([x*((16/2)-2), 0])
          circle(r=2);

}





terminal_hub_internal();








