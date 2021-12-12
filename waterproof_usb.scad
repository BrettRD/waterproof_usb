// Creative Commons, Attribution, Share-Alike.
// author Brett Downing 2021
// developed for Thaum pty ltd as a retrofit kit for a USB repeater cable
// this is an approximation of Amphenol's IP67 USB-A connector.
// No warranty is given or implied, Printed models must be tested for printer settings and tolerances

// the gasket is on the plug side with the collar and stuck down with a high-tack adhesive.


use <threadlib/threadlib.scad>
use <usb_repeater.scad>
$fs=0.2;
$fa=0.2;

thread_designator = "28-UN-13/16";

gasket_len=1;
ridge_len=3.5;
ridge_dia=19.3;
ridge_slip_dia=17.5;

thread_min_len = 9.5-ridge_len+1;
//thread_min_len=10;


thread_int_designator = str(thread_designator , "-int");
thread_ext_designator = str(thread_designator , "-ext");
thread_pitch = thread_specs(thread_ext_designator)[0];
thread_ext_dia = thread_specs(thread_ext_designator)[2];
thread_int_dia = thread_specs(thread_int_designator)[2];

// thread lib adds half a turn both sides
thread_ext_len = 1.2*thread_min_len + 0.5*thread_pitch; 
thread_int_len = thread_min_len+ridge_len + 0.5*thread_pitch; 
cap_thread_ext_len = thread_ext_len;
thread_ext_turns = (thread_ext_len / thread_pitch)-0.5; 
thread_int_turns = (thread_int_len / thread_pitch)-1; 

thread_start_len = 0.5*thread_pitch;
thread_clearance=0.1;
thread_shrink = (thread_ext_dia-thread_clearance)/thread_ext_dia;

cap_thread_len=10;

usb_slot_offset=[0,0];  //lovely!
usb_slot_dims=[12.6,6]; //socket dims
usb_slot_face_thickness=0.6;


module repeater_case(){
  wall=2.5;
  difference() {
    union(){
      translate([0,0,thread_pitch/2])
        scale([thread_shrink, thread_shrink, 1])  //2d shrink for extra tolerance
          bolt(thread_designator, turns=thread_ext_turns, higbee_arc=30);
      
      translate([0,0,30])
        linear_extrude(40)
          terminal_hub_internal_section(wall=wall);


      translate([0,0,thread_ext_len+ 0.5*thread_pitch])
        cylinder(d1=thread_ext_dia, d2=0, h=thread_ext_dia);
      translate([0,0,usb_slot_face_thickness])
        terminal_hub_internal(wall=wall);
    }
    union(){
      linear_extrude(2*thread_ext_len, center=true)
        offset(r=0)
          square(usb_slot_dims, center=true);
      translate([0,0,30])
        linear_extrude(40)
          terminal_hub_internal_section(wall=0.2);

      translate([0,0,usb_slot_face_thickness])
        terminal_hub_internal(wall=0.2);


    }
  }
}


module cable_clamp_spiral(len=25, dia=4.5, n=3){
  linear_extrude(height = len, twist = n*360, slices = 50)
    translate([dia/10,0, 0])
      circle(d=1.1*dia);
}

module cable_clamp_cones(len=25, dia=4.5, n=6){
  od=dia*1.2;
  id=dia*0.9;
  h1=len/n * 0.2;
  h2=len/n - h1;
  for(i=[0:n-1]){
    translate([0,0,(i*len/n)])
      cylinder(d1=od, d2=id, h=h1+0.001);
    translate([0,0,(i*len/n)+h1])
      cylinder(d1=id, d2=od, h=h2+0.001);
  }


}


module repeater_case_cable_clamp(){
  difference(){
    union(){
      translate([0,0,45])
        linear_extrude(23)
          terminal_hub_internal_section(wall=0.1);
      translate([0,0,45])
        linear_extrude(25)
          terminal_hub_internal_section(wall=-2);
    }
    // steady the clamp on the terminal hub
    translate([0,0,usb_slot_face_thickness])
      terminal_hub_internal(wall=0.2);
    //wire proper, with a texture to grip the wire outer
    translate([0,0,45])
      cable_clamp_cones(len=25, dia=usb_repeater_cable_dia());
      //cable_clamp_spiral(len=25, dia=usb_repeater_cable_dia());
  }
}

module repeater_case_cable_clamp_l(){
  intersection(){
    repeater_case_cable_clamp();
    translate([500,0,0])
      cube([1000,1000,1000], center=true);
  }
}
module repeater_case_cable_clamp_r(){
  intersection(){
    repeater_case_cable_clamp();
    translate(-[500,0,0])
      cube([1000,1000,1000], center=true);
  }
}


module usb_a_shroud_gasket(clearance=0.1){
  difference() {
      circle(d=ridge_dia);
      offset(r=0.5 + clearance)offset(-0.5)
        square([12, 4.5],center=true);
  }
}
module usb_a_shroud(gasket_len=gasket_len, clearance=0.1){
  difference() {
    union(){
      cylinder(d=ridge_dia, h=ridge_len-gasket_len);
      cylinder(d=ridge_slip_dia, h=15);
    }
    union(){
      translate([0,0,(12-9)-gasket_len])
        linear_extrude(30)
          usb_a_overmould_outline();
      linear_extrude(30)
        offset(r=0.5 + clearance)offset(-0.5)
          square([12, 4.5],center=true);
    }
  }
}




knurl_n = 8;
module collar(h=thread_int_len+3){
  difference(){
    union(){
      for(a=[0,180/knurl_n])
        rotate([0,0,a])
          cylinder(d=26, h=h, $fn=knurl_n);

    }
    union(){
      translate([0,0,h-thread_int_len + 0.5*thread_pitch])
        tap(thread_designator, turns=thread_int_turns, higbee_arc=30);
      cylinder(d=ridge_slip_dia+0.3, h=h+1);
    }
  }
}


module cap(){
  difference() {
    union(){
      translate([0,0,thread_pitch/2])
        scale([thread_shrink, thread_shrink, 1])  //dodgy 2d shrink for extra tolerance
          bolt(thread_designator, turns=(cap_thread_ext_len/thread_pitch)-1, higbee_arc=30);
      cylinder(d=thread_ext_dia, h=13);
      cylinder(d=20*sqrt(3)/2, h=20, $fn=6);
    }
    union(){
    linear_extrude(2*cap_thread_ext_len, center=true)
      offset(r=0)
        square(usb_slot_dims, center=true);
    }
  }
}


// Printable assets:



// A collar and shroud providing the full waterproof USB-A connector,
// usb_a_shroud_gasket() is a 2d item and must be glued to the face of usb_a_shroud().
//collar();
//usb_a_shroud();
//usb_a_shroud_gasket()

// a waterproofing end-cap sockek for the USB-A plug
//cap();

// The IP67 socket connector and body to suit a USB2.0 repeater described in usb_repeater.scad 
// this component relies on the gasket fitted to the USB-A plug
repeater_case();
//repeater_case_cable_clamp_l();
//repeater_case_cable_clamp_r();

