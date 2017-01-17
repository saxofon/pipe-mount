// title      : Pipe mount/fastener
// author     : Per Hallsmark <per@hallsmark.se>
// license    : GPL
// revision   : 1.0
// tags       : pipe, mount, fastener

include <libs/nutsnbolts/cyl_head_bolt.scad>
include <libs/nutsnbolts/materials.scad>

pipe_diameter = 40;
base_length = 100;
base_width = 50;
base_height = 80;

df_M8 = _get_screw_fam("M8x70");
M8_head_height = df_M8[_NB_F_HEAD_HEIGHT];
M8_nut_height = df_M8[_NB_F_NUT_HEIGHT];

df_M6 = _get_screw_fam("M6x45");
M6_head_height = df_M6[_NB_F_HEAD_HEIGHT];

$fn = 100;

// for a surface that is flush to another surface when doing difference(), need to add a small bit more on
// the "extractor" length otherwise I see thin surface as if they are not aligned. Most times only visible
// in preview but sometimes also in rendered view.
// Is it a effect only visible in openscad or also in printed models? time will tell...
strange_align=1;

module pipe(diameter, length) {
    rotate([90,0,0])
        cylinder(r=diameter/2, h=length, center=true);
}

module tool_round_corner_3D(radius, length) {
    difference() {
        cube([radius*2+2*strange_align, radius*2+2*strange_align, length]);
        translate([radius+strange_align,radius+strange_align,-strange_align]) cylinder(r=radius, h=length+2*strange_align);
        translate([radius,-strange_align,-strange_align]) cube([radius*2+4*strange_align, radius*2+2*strange_align, length+2*strange_align]);
        translate([-strange_align,radius,-strange_align]) cube([radius*2+4*strange_align, radius*2+2*strange_align, length+2*strange_align]);
    }
}

module tool_round_corner_2D(radius) {
    difference() {
        square(radius*2+2*strange_align, center=true);
        circle(r=radius, center=true);
        translate([radius+2*strange_align,0]) square(radius*2+4*strange_align, center=true);
        translate([0,radius+2*strange_align]) square(radius*2+4*strange_align, center=true);
    }
}

module base_lower_ends(length, width, height) {
    difference() {
        rotate([90,0,0])
            cylinder(r=length, h=width, center=true, $fn=200);
        rotate(a=[90,0,0])
            cylinder(r=length/2, h=width, center=true, $fn=200);
        translate([-length/2,-width/2,0])
            cube([length*2, width, height]);
    }
}

// if cutouts == 0, generate bolt/nut set
// if cutouts == 1, generate tooling to cutout where bolts&nuts go into place.
module bolts_n_nuts(diameter, length, width, height, cutouts) {
    rotate([180,0,0])
        translate ([diameter/2+10, width/4, height/2+strange_align]) {
            if (cutouts) {
                hole_through("M8", l=70, h=M8_head_height+3, cld=0.2, hcld=0.2);
            } else {
                screw("M8x70");
            }
        }
    rotate([180,0,0])
        translate ([diameter/2+10, width/4, -height/2+M8_nut_height]) {
            if (cutouts) {
                nutcatch_parallel("M8", l=M8_nut_height+20, clk=0.2);
            } else {
                nut("M8");
            }
        }
    rotate([180,0,0])
        translate ([diameter/2+10, -width/4, height/2+strange_align]) {
            if (cutouts) {
                hole_through("M8", l=70, h=M8_head_height+3, cld=0.2, hcld=0.2);
            } else {
                screw("M8x70");
            }
        }
    rotate([180,0,0])
        translate ([diameter/2+10, -width/4, -height/2+M8_nut_height]) {
            if (cutouts) {
                nutcatch_parallel("M8", l=M8_nut_height+20, clk=0.2);
            } else {
                nut("M8");
            }
        }
    rotate([180,0,0])
        translate ([diameter/2+(length/2-diameter/2)/2, 0, 0+strange_align]) {
            if (cutouts) {
                hole_through("M6", l=45, h=M6_head_height+1+strange_align, cld=0.2, hcld=0.2);
            } else {
                screw("M6x45");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-10, width/4, height/2+strange_align]) {
            if (cutouts) {
                hole_through("M8", l=70, h=M8_head_height+3, cld=0.2, hcld=0.2);
            } else {
                screw("M8x70");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-10, width/4, -height/2+M8_nut_height]) {
            if (cutouts) {
                nutcatch_parallel("M8", l=M8_nut_height+20, clk=0.2);
            } else {
                nut("M8");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-10, -width/4, height/2+strange_align]) {
            if (cutouts) {
                hole_through("M8", l=70, h=M8_head_height+3, cld=0.2, hcld=0.2);
            } else {
                screw("M8x70");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-10, -width/4, -height/2+M8_nut_height]) {
            if (cutouts) {
                nutcatch_parallel("M8", l=M8_nut_height+20, clk=0.2);
            } else {
                nut("M8");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-(length/2-diameter/2)/2, 0, 0+strange_align]) {
            if (cutouts) {
                hole_through("M6", l=45, h=M6_head_height+1+strange_align, cld=0.2, hcld=0.2);
            } else {
                screw("M6x45");
            }
        }
}

module attachement(length, width, height) {
    translate([0,width/2-5,height/2+5])
        cube([length, 10, 10], center=true);
    translate([0,-width/2+5,height/2+5])
        cube([length, 10, 10], center=true);
}
module base(diameter, length, width, height) {
    difference() {
        union() {
            cube([length, width, height], center=true);
            attachement(length, width, height);
        }
        pipe(diameter, base_width+1);
        base_lower_ends(length, width+1, height);
        bolts_n_nuts(diameter, length, width, height, 1);
    }

}

module base_upper(diameter, length, width, height) {
    difference() {
        base(diameter, base_length, base_width, base_height);
        translate([-base_length/2-strange_align,-base_width/2-strange_align,-height])
            cube([base_length+2, base_width+2, base_height]);
        translate ([-length/2-strange_align, -width/2-strange_align, -strange_align])
            rotate([0,0,0]) tool_round_corner_3D(10, 100);
        translate ([-length/2-strange_align, width/2+strange_align, -strange_align])
            rotate([0,0,-90]) tool_round_corner_3D(10, 100);
        translate ([length/2+strange_align, width/2+strange_align, -strange_align])
            rotate([0,0,180]) tool_round_corner_3D(10, 100);
        translate ([length/2+strange_align, -width/2-strange_align, -strange_align])
            rotate([0,0,90]) tool_round_corner_3D(10, 100);
   }
   /*
        translate ([-length/2, -width/2-strange_align, height/2+10+strange_align])
            rotate([0,90,0]) rotate([0,0,0]) tool_round_corner_3D(10, 100);
        translate ([-length/2, width/2+strange_align, height/2+10+strange_align])
            rotate([0,90,0])  rotate([0,0,-90]) tool_round_corner_3D(10, 100);*/
}



module base_lower(diameter, length, width, height) {

    difference() {
        base(diameter, base_length, base_width, base_height);
        translate([-base_length/2-strange_align, -base_width/2-strange_align, 0])
            cube([base_length+2, base_width+2, base_height]);
        rotate([90,0,0])
          rotate_extrude(angle = 90)
            translate ([-length/2+10, -width/2+10, 0])
              tool_round_corner_2D(10);
        rotate([-90,0,0])
          rotate_extrude(angle = 90)
            translate ([-length/2+10, -width/2+10, 0])
              tool_round_corner_2D(10);

        translate ([-length/2-strange_align, -width/2-strange_align, -height/2-strange_align])
            rotate([0,90,0]) rotate([0,0,90]) tool_round_corner_3D(10, 100);
        translate ([-length/2-strange_align, width/2+strange_align, -height/2-strange_align])
            rotate([0,90,0]) rotate([0,0,180]) tool_round_corner_3D(10, 100);
    }
}

// lower part of base
base_lower(pipe_diameter, base_length, base_width, base_height);

// upper part of base
//base_upper(pipe_diameter, base_length, base_width, base_height);

/*
// set of bolts and nuts
translate([0, base_width*2, 0])
    %bolts_n_nuts(pipe_diameter, base_length, base_width, base_height, 0);

// all parts assembled plus pipe
%translate([0, base_width*4, 0])
    base(pipe_diameter, base_length, base_width, base_height);
%translate([0, base_width*4, 0])
    bolts_n_nuts(pipe_diameter, base_length, base_width, base_height, 0);
%pipe(pipe_diameter, 1000);
*/
