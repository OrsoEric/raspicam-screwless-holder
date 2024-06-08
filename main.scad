//This is an OpenSCAD code that designs a holder for the Raspberry Pi Camera (Raspicam) module. Here's a breakdown of what the code does:

//**Variables and Parameters**
//
//The code defines various variables and parameters related to the Raspicam module, such as its width, height, thickness, pin positions, and clip dimensions.
//
//**Modules**
//
//The code includes several custom modules that define specific parts of the design:
//
//1. `drill()`: A simple module for creating a drilled hole.
//2. `raspicam()`: The main module for designing the Raspicam holder. It creates the PCB shape, MIPI connector, and optics area.
//3. `rpi_pin()`: A module for creating individual Raspberry Pi pins.
//4. `four_rpi_pin()`: A module that creates four Raspberry Pi pins in a row.
//5. `clip_p()`: A module for designing a vertical clip retaining PCBs in place.
//6. `four_rpicam_clips()`: A module that creates two clips on the left and right sides of the Raspicam holder.
//7. `base_rpicam_alternate()`: A module for creating an alternate base design using 3D printing.
//
//**Main Design**
//
//The code defines a main module, `rpi_holder`, which combines all the individual parts to create the complete Raspicam holder. It includes:
//
//1. The dummy base outline of the Raspicam.
//2. Four Raspberry Pi pins where the Raspicam rests.
//3. A Lego base or 3D printed base design (depending on the value of `gx_lego_base`).
//4. Two clips on the left and right sides to retain PCBs in place.
//
//**Show/Hide Options**
//
//The code provides two show/hide options:
//
//1. `gx_show_raspicam`: If set to `true`, the Raspicam design is visible.
//2. `gx_lego_base`: If set to `true`, a Lego base design is used; otherwise, a 3D printed base design is used.
//
//By adjusting these variables and parameters, you can customize the design of the Raspicam holder to suit your specific needs.

//I tried making weak bendy clips, but it doesn't work, I can only print vertically, and the clips are too weak and snaps
//Instead I make strong clips, with very tight tollerances on a small interference, so the clip barely moves at all
//It's a very satisfying clip mechanism, and retains very well and it's stable, easy to put and easy to remove while being stable. I'm mildly worried about PCB cut tollerances and erosion of the clips, time will tell.

//Lego beam library
include <customizable_straight_beam_v4o.scad>

//Rounded Poly Library
include <polyround.scad>

//FLAGS to control the rpicam holder options
gx_show_raspicam = false;
gx_lego_base = true;

gn_rpicam_width = 25.00;
gn_rpicam_height = 23.86;

//Thickness of jusst PCB
gn_rpicam_thickness_pcb = 1.0;
//Thickness of PCB and MIPI connector
gn_rpicam_thickness_connector = 3.5;

gn_rpicam_pin_top_offset = 2.0;
gn_rpicam_pin_bot_offset = gn_rpicam_height -14.5;
gn_rpicam_pin_left_offset = 2.0;
gn_rpicam_pin_right_offset = 2.0;

gd_rpicam_drill = 2.0+0.3;

gd_rpicam_optics = 7.0;
gh_rpicam_optics = 5.0;

gn_rpicam_pin_large_diameter = 4.0;
gn_rpicam_pin_large_height = gn_rpicam_thickness_connector -gn_rpicam_thickness_pcb+0.5;
gn_rpicam_pin_small_diameter = 1.8;
gn_rpicam_pin_small_height = gn_rpicam_thickness_pcb +0.5;

//Percentage of length of the clip
gl_rpicam_clip = 0.35;
//Strength of the clip
gw_rpicam_clip = 2.0;
//Interference between clip and PCB
gw_rpicam_clip_retain = 0.6;

//Distance of clips to raspicam
gs_clip_margin = 0.4;
//Height margin from top of PCB
gh_clip_margin = 0.3;

module drill( ind, inz, in_precision = 0.5 )
{
    linear_extrude(inz)
    circle( d=ind, $fa=in_precision, $fs=in_precision );
}

module raspicam( in_precision = 0.5)
{
    color("green")
    difference()
    {
        union()
        {
            //PCB
            linear_extrude(gn_rpicam_thickness_pcb)
            square([gn_rpicam_height,gn_rpicam_width],center=true);
            
            //MIPI Connector
            translate([gn_rpicam_height/2-gn_rpicam_thickness_connector/2,0,-gn_rpicam_thickness_connector+gn_rpicam_thickness_pcb])
            linear_extrude(gn_rpicam_thickness_connector)
            square([gn_rpicam_thickness_connector,gn_rpicam_width],center=true);
            
            //Optics
            translate([gn_rpicam_height/2-gn_rpicam_pin_bot_offset,0,0])
            linear_extrude(gh_rpicam_optics)
            circle(d=gd_rpicam_optics, $fa=in_precision, $fs=in_precision);
        }
        union()
        {
            //Drill
            translate([gn_rpicam_height/2-gn_rpicam_pin_bot_offset,gn_rpicam_width/2-gn_rpicam_pin_left_offset,0])
			drill(gd_rpicam_drill, gn_rpicam_thickness_pcb,in_precision);
            
            translate([gn_rpicam_height/2-gn_rpicam_pin_bot_offset,-(gn_rpicam_width/2-gn_rpicam_pin_right_offset),0])
            linear_extrude(gn_rpicam_thickness_pcb)
            circle(d=gd_rpicam_drill, $fa=in_precision, $fs=in_precision);

            translate([-(gn_rpicam_height/2-gn_rpicam_pin_top_offset),gn_rpicam_width/2-gn_rpicam_pin_left_offset,0])
            linear_extrude(gn_rpicam_thickness_pcb)
            circle(d=gd_rpicam_drill, $fa=in_precision, $fs=in_precision);

            translate([-(gn_rpicam_height/2-gn_rpicam_pin_top_offset),-(gn_rpicam_width/2-gn_rpicam_pin_right_offset),0])
            linear_extrude(gn_rpicam_thickness_pcb)
            circle(d=gd_rpicam_drill, $fa=in_precision, $fs=in_precision);
            
        }
    }
}


module rpi_pin( in_precision = 0.5 )
{
	linear_extrude( gn_rpicam_pin_large_height )
	circle(d=gn_rpicam_pin_large_diameter, $fa=in_precision, $fs=in_precision );
	translate([0,0,gn_rpicam_pin_large_height])
	linear_extrude( gn_rpicam_pin_small_height )
	circle(d=gn_rpicam_pin_small_diameter, $fa=in_precision, $fs=in_precision );
}

//A vertical rounded clip retaining PCBs in place
//Example: clip_p( 30,2,10,1,2, 1 )
module clip_p( inl, inw, inh, inw_clip, inh_clip, inr_clip=1.0 )
{
    aan_points =
	([
        //base
        [0, 0, 0],
        [-inw, 0, 0],
        //top
		[-inw, inh+inh_clip, inw*0.5*inr_clip],
        //clip
		[0, inh+inh_clip, inr_clip],
        [0+inw_clip, inh +inh_clip*2/3, inh_clip*inr_clip],
        [0+inw_clip, inh +inh_clip*1/3, inh_clip*inr_clip],
        [0, inh +inh_clip*0/3, inh_clip*inr_clip],
        
    ]);
    translate([0,inl/2,0])
	rotate([90,0,0])
	linear_extrude(inl)
	polygon(polyRound(aan_points,100));
    
}

module four_rpi_pin( in_precision = 0.5)
{
	translate([gn_rpicam_height/2-gn_rpicam_pin_bot_offset,gn_rpicam_width/2-gn_rpicam_pin_left_offset,0])
	rpi_pin(in_precision);

	translate([gn_rpicam_height/2-gn_rpicam_pin_bot_offset,-(gn_rpicam_width/2-gn_rpicam_pin_right_offset),0])
	rpi_pin(in_precision);

	translate([-(gn_rpicam_height/2-gn_rpicam_pin_top_offset),gn_rpicam_width/2-gn_rpicam_pin_left_offset,0])
	rpi_pin(in_precision);

	translate([-(gn_rpicam_height/2-gn_rpicam_pin_top_offset),-(gn_rpicam_width/2-gn_rpicam_pin_right_offset),0])
	rpi_pin(in_precision);

}

module four_rpicam_clips( in_precision = 0.5 )
{
    //right clip
    translate([gn_rpicam_height*(0.5-gl_rpicam_clip/2),-gn_rpicam_width/2-gs_clip_margin,0])
    rotate([0,0,90])
    clip_p( gn_rpicam_height*gl_rpicam_clip,gw_rpicam_clip,gn_rpicam_thickness_connector-gh_clip_margin,gw_rpicam_clip_retain,2, 1 );
    
    translate([-gn_rpicam_height*(0.5-gl_rpicam_clip/2),-gn_rpicam_width/2-gs_clip_margin,0])
    rotate([0,0,90])
    clip_p( gn_rpicam_height*gl_rpicam_clip,gw_rpicam_clip,gn_rpicam_thickness_connector-gh_clip_margin,gw_rpicam_clip_retain,2, 1 );
    
    //left clip
    translate([gn_rpicam_height*(0.5-gl_rpicam_clip/2),+gn_rpicam_width/2+gs_clip_margin,0])
    rotate([0,0,-90])
    clip_p( gn_rpicam_height*gl_rpicam_clip,gw_rpicam_clip,gn_rpicam_thickness_connector-gh_clip_margin,gw_rpicam_clip_retain,2, 1 );
    
    translate([-gn_rpicam_height*(0.5-gl_rpicam_clip/2),+gn_rpicam_width/2+gs_clip_margin,0])
    rotate([0,0,-90])
    clip_p( gn_rpicam_height*gl_rpicam_clip,gw_rpicam_clip,gn_rpicam_thickness_connector-gh_clip_margin,gw_rpicam_clip_retain,2, 1 );
    
    
}

module base_rpicam_alternate( in_precision = 0.5 )
{
    nd_screw_holes = 3.0+0.3;
    
    nd_screw_flap = nd_screw_holes *2.0;
    
    nw_base = gn_rpicam_width+(gw_rpicam_clip+gs_clip_margin)*2;
    //use the width of the clips as thickness of the base
    translate([0,0,-gw_rpicam_clip])
    difference()
    {
        union()
        {
            //Square base
            linear_extrude(gw_rpicam_clip)
            square([gn_rpicam_height, nw_base], center = true);
         
            //Right Round flaps
            translate([0,nw_base/2,0])
            linear_extrude(gw_rpicam_clip)
            circle( d=nd_screw_flap,$fa=in_precision, $fs=in_precision);
            
            //Left Round flaps
            translate([0,-nw_base/2,0])
            linear_extrude(gw_rpicam_clip)
            circle( d=nd_screw_flap,$fa=in_precision, $fs=in_precision);
        }
        union()
        {
            //Right Drill
            translate([0,nw_base/2,0])
            linear_extrude(gw_rpicam_clip)
            circle( d=nd_screw_holes,$fa=in_precision, $fs=in_precision);
            
            //Left Drill
            translate([0,-nw_base/2,0])
            linear_extrude(gw_rpicam_clip)
            circle( d=nd_screw_holes,$fa=in_precision, $fs=in_precision);
        }
    }
    
    
    //add two side flaps to have screw holes

}

module rpi_holder( in_precision = 0.5 )
{   
    //Dummy base, outline of raspicam
    linear_extrude(0)
	square([gn_rpicam_height,gn_rpicam_width],center=true);

    //Pins where the raspicam rests
	four_rpi_pin( in_precision );
    if (gx_lego_base == true)
    {
        //Lego base, rpicam rests on it
        translate([-cn_lego_pitch_stud*2,-cn_lego_pitch_stud*2,-cn_lego_width_beam/2])
        lego_plate_alternate
        ([
            "oooo",
            "oPPo",
            "oOOo",
            "oPPo",
            "oooo",
        ]);
    }
    //Use 3D printed base
    if (gx_lego_base == false)
    {
        base_rpicam_alternate(in_precision);
    }    
        
    four_rpicam_clips( in_precision );
    
}

if (gx_show_raspicam == true)
{

    translate([0,0,gn_rpicam_pin_large_height])
    raspicam();
}

rpi_holder( 0.25 );