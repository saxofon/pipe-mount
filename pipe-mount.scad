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

ds_M8_70 = _get_screw("M8x70");
df_M8_70 = _get_screw_fam("M8x70");
M8_70_head_height = df_M8_70[_NB_F_HEAD_HEIGHT];
M8_70_nut_height = df_M8_70[_NB_F_NUT_HEIGHT];

ds_M6_45 = _get_screw("M6x45");
df_M6_45 = _get_screw_fam("M6x45");
M6_45_head_height = df_M6_45[_NB_F_HEAD_HEIGHT];

// for a surface that is flush to another surface when doing difference(), need to add a small bit more on
// the "extractor" length otherwise I see thin surface as if they are not aligned. Most times only visible
// in preview but sometimes also in rendered view.
// Is it a effect only visible in openscad or also in printed models? time will tell...
strange_clearence=1;

module pipe(diameter, length) {
    rotate([90,0,0])
        cylinder(r=diameter/2, h=length, center=true, $fn=100);
}

module tool_round_corner(radius, length) {
    difference() {
        cube([radius*2+2*strange_clearence, radius*2+2*strange_clearence, length]);
        translate([radius+strange_clearence,radius+strange_clearence,-strance_clearence]) cylinder(r=radius, h=length+2*strange_clearence, $fn=100);
        translate([radius,-strange_clearence,-strange_clearence]) cube([radius*2+4*strange_clearence, radius*2+2*strange_clearence, length+2*strange_clearence]);
        translate([-strange_clearence,radius,-strange_clearence]) cube([radius*2+4*strange_clearence, radius*2+2*strange_clearence, length+2*strange_clearence]);
    }
}

module base_lower_ends(length, width, height) {
    difference() {
        rotate([90,0,0])
            cylinder(r=length, h=width, center=true, $fn=100);
        rotate(a=[90,0,0])
            cylinder(r=length/2, h=width, center=true, $fn=100);
        translate([-length/2,-width/2,0])
            cube([length*2, width, height]);
    }
}

module bolts_n_nuts(diameter, length, width, height, cutouts) {
    rotate([180,0,0])
        translate ([diameter/2+10, width/4, height/2+strange_clearence]) {
            if (cutouts) {
                hole_through("M8", l=70, h=M8_70_head_height+3);
            } else {
                screw("M8x70");
            }
        }
    rotate([180,0,0])
        translate ([diameter/2+10, width/4, -height/2+M8_70_nut_height]) {
            if (cutouts) {
                nutcatch_parallel("M8", l=M8_70_nut_height);
            } else {
                nut("M8");
            }
        }
    rotate([180,0,0])
        translate ([diameter/2+10, -width/4, height/2+strange_clearence]) {
            if (cutouts) {
                hole_through("M8", l=70, h=M8_70_head_height+3);
            } else {
                screw("M8x70");
            }
        }
    rotate([180,0,0])
        translate ([diameter/2+10, -width/4, -height/2+M8_70_nut_height]) {
            if (cutouts) {
                nutcatch_parallel("M8", l=M8_70_nut_height);
            } else {
                nut("M8");
            }
        }
    rotate([180,0,0])
        translate ([diameter/2+(length/2-diameter/2)/2, 0, 0+strange_clearence]) {
            if (cutouts) {
                hole_through("M6", l=45, h=M6_45_head_height+1+strange_clearence);
            } else {
                screw("M6x45");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-10, width/4, height/2+strange_clearence]) {
            if (cutouts) {
                hole_through("M8", l=70, h=M8_70_head_height+3);
            } else {
                screw("M8x70");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-10, width/4, -height/2+M8_70_nut_height]) {
            if (cutouts) {
                nutcatch_parallel("M8", l=M8_70_nut_height);
            } else {
                nut("M8");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-10, -width/4, height/2+strange_clearence]) {
            if (cutouts) {
                hole_through("M8", l=70, h=M8_70_head_height+3);
            } else {
                screw("M8x70");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-10, -width/4, -height/2+M8_70_nut_height]) {
            if (cutouts) {
                nutcatch_parallel("M8", l=M8_70_nut_height);
            } else {
                nut("M8");
            }
        }
    rotate([180,0,0])
        translate ([-diameter/2-(length/2-diameter/2)/2, 0, 0+strange_clearence]) {
            if (cutouts) {
                hole_through("M6", l=45, h=M6_45_head_height+1+strange_clearence);
            } else {
                screw("M6x45");
            }
        }
}

module base(diameter, length, width, height) {
    difference() { 
        cube([length, width, height], center=true);
        pipe(diameter, base_width+1);
        base_lower_ends(length, width+1, height);
        bolts_n_nuts(diameter, length, width, height, 1);
        translate ([-length/2-strange_clearence, -width/2-strange_clearence, -strange_clearence])
            rotate([0,0,0]) tool_round_corner(10, 100);
        translate ([-length/2-strange_clearence, width/2+strange_clearence, -strange_clearence])
            rotate([0,0,-90]) tool_round_corner(10, 100);
        translate ([length/2+strange_clearence, width/2+strange_clearence, -strange_clearence])
            rotate([0,0,180]) tool_round_corner(10, 100);
        translate ([length/2+strange_clearence, -width/2-strange_clearence, -strange_clearence])
            rotate([0,0,90]) tool_round_corner(10, 100);
        rotate([0,90,0]) translate ([width/2+15+strange_clearence, -width/2-strange_clearence, -length/2])
            rotate([0,0,90]) tool_round_corner(10, 100);
        rotate([0,90,0])  translate ([width/2+15+strange_clearence, width/2+strange_clearence, -length/2])
            rotate([0,0,180]) tool_round_corner(10, 100);
    }

}

module base_upper(diameter, length, width, height) {
    difference() {
        base(diameter, base_length, base_width, base_height);
        translate([-base_length/2-1,-base_width/2-1,-height])
            cube([base_length+2, base_width+2, base_height]);
    }
}

module base_lower(diameter, length, width, height) {
    difference() {
        base(diameter, base_length, base_width, base_height);
        translate([-base_length/2-1,-base_width/2-1,0])
            cube([base_length+2, base_width+2, base_height]);
    }
}

// lower part of base
translate([0, base_width*8, 0])
    %base_lower(pipe_diameter, base_length, base_width, base_height);

// upper part of base
translate([0, base_width*6, 0])
    base_upper(pipe_diameter, base_length, base_width, base_height);

// base parts assembled
translate([0, base_width*4, 0])
    %base(pipe_diameter, base_length, base_width, base_height);

// set of bolts and nuts
translate([0, base_width*2, 0])
    %bolts_n_nuts(pipe_diameter, base_length, base_width, base_height, 0);

// all parts assembled plus pipe
%base(pipe_diameter, base_length, base_width, base_height);
%bolts_n_nuts(pipe_diameter, base_length, base_width, base_height, 0);
%pipe(pipe_diameter, 1000);
