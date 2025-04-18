/*Created by Hands on Katie and BlackjackDuck (Andy)
This code and all parts derived from it are Licensed Creative Commons 4.0 Attribution Non-Commercial Share-Alike (CC-BY-NC-SA)

Documentation available at https://handsonkatie.com/underware-2-0-the-made-to-measure-collection/

Change Log:
- 2024-12-06 
    - Initial release
- 2024-12-09
    - Fix to threading of snap connector by adding flare and new slop parameter
2025-03-20
    - Stronger profile options
2025-04-13
    - Initial implementation for openGrid


Credit to 
    First and foremost - Katie and her community at Hands on Katie on Youtube, Patreon, and Discord
    @David D on Printables for Multiconnect
    Jonathan at Keep Making for Multiboard
    @cosmicdust on MakerWorld and @freakadings_1408562 on Printables for the idea of diagonals (forward and turn)
    @siyrahfall+1155967 on Printables for the idea of top exit holes
    @Lyric on Printables for the flush connector idea
    @fawix on GitHub for her contributions on parameter descriptors
    PedroL on inital implementation of the monokini profile
    @BlackjackDuck on Printables for the original profiles and the idea of a channel


*/


include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/threading.scad>



/*[Channel Size]*/
//Width (X axis) of channel in units. Default unit is 28mm
Channel_Width_in_Units = 1;  // Ensure this is an integer
//Height (Z axis) including connector (in mm)
Channel_Total_Height = 22; //[22:6:72]
//Number of grids extending along the Y axis from the corner grid in units to the bottom (default unit is 28mm)
X_Channel_Length_in_Units_Y_Axis_Bottom = 1;
//Number of grids extending along the Y axis from the corner grid in units to the top (default unit is 28mm)
X_Channel_Length_in_Units_Y_Axis_Top = 1;
//Number of grids extending along the X axis from the corner grid in units to the left (default unit is 28mm)
X_Channel_Length_in_Units_X_Axis_Left = 1;
//Number of grids extending along the X axis from the corner grid in units to the right (default unit is 28mm)
X_Channel_Length_in_Units_X_Axis_Right = 1;

/*[Cord Cutouts]*/
Number_of_Cord_Cutouts = 0;
//Cutouts on left side, right side, or both (note that it can be flipped so left and right is moot)
Cord_Side_Cutouts = "Both Sides"; //[Left Side, Right Side, Both Sides, None]
//Width of each cord cutout (in mm)
Cord_Cutout_Width = 12;
// in mm
Distance_Between_Cutouts = 28;
//Distance (in mm) to offset cutouts along Y axis. Forward is positive, back is negative
Shift_Cutouts_Forward_or_Back = 0;

/*[Text Label]*/
//Labels (1) only work on MakerWorld, (2) must be exported as 3MF, and (3) must be imported into slicer as project (not geometry).
Add_Label = false;
//Text to appear on label
Text = "Hands on Katie";  // Text to be displayed
// Adjust the X axis position of the text
Text_x_coordinate = 0; 
//Depth of text (in mm). Increments of 0.2 to match layer heights. 
Text_Depth = 0.0; // [0:0.2:1] 
//Font must be installed on local machine if using local OpenSCAD
Font = "Raleway"; // [Asap, Bangers, Changa One, Chewy, Harmony OS Sans,Inter,Inter Tight,Lora,Merriweather Sans,Montserrat,Noto Emoji,Noto Sans,Noto Sans Adlam,Noto Sans Adlam Unjoined,Noto Sans Arabic,Noto Sans Arabic UI,Noto Sans Armenian,Noto Sans Balinese,Noto Sans Bamum,Noto Sans Bassa Vah,Noto Sans Bengali,Noto Sans Bengali UI,Noto Sans Canadian Aboriginal,Noto Sans Cham,Noto Sans Cherokee,Noto Sans Devanagari,Noto Sans Display,Noto Sans Ethiopic,Noto Sans Georgian,Noto Sans Gujarati,Noto Sans Gunjala Gondi,Noto Sans Gurmukhi,Noto Sans Gurmukhi UI,Noto Sans HK,Noto Sans Hanifi Rohingya,Noto Sans Hebrew,Noto Sans JP,Noto Sans Javanese,Noto Sans KR,Noto Sans Kannada,Noto Sans Kannada UI,Noto Sans Kawi,Noto Sans Kayah Li,Noto Sans Khmer,Noto Sans Khmer UI,Noto Sans Lao,Noto Sans Lao Looped,Noto Sans Lao UI,Noto Sans Lisu,Noto Sans Malayalam,Noto Sans Malayalam UI,Noto Sans Medefaidrin,Noto Sans Meetei Mayek,Noto Sans Mono,Noto Sans Myanmar,Noto Sans NKo Unjoined,Noto Sans Nag Mundari,Noto Sans New Tai Lue,Noto Sans Ol Chiki,Noto Sans Oriya,Noto Sans SC,Noto Sans Sinhala,Noto Sans Sinhala UI,Noto Sans Sora Sompeng,Noto Sans Sundanese,Noto Sans Symbols,Noto Sans Syriac,Noto Sans Syriac Eastern,Noto Sans TC,Noto Sans Tai Tham,Noto Sans Tamil,Noto Sans Tamil UI,Noto Sans Tangsa,Noto Sans Telugu,Noto Sans Telugu UI,Noto Sans Thaana,Noto Sans Thai,Noto Sans Thai UI,Noto Sans Vithkuqi,Nunito,Nunito Sans,Open Sans,Open Sans Condensed,Oswald,Playfair Display,Plus Jakarta Sans,Raleway,Roboto,Roboto Condensed,Roboto Flex,Roboto Mono,Roboto Serif,Roboto Slab,Rubik,Source Sans 3,Ubuntu Sans,Ubuntu Sans Mono,Work Sans]
//Styling of selecte font. Note that not all fonts support all styles. 
Font_Style = "Regular"; // [Regular,Bold,Medium,SemiBold,Light,ExtraBold,Black,ExtraLight,Thin,Bold Italic,Italic,Light Italic,Medium Italic]
Text_size = 10;    // Font size
//Color of label text (color names found at https://en.wikipedia.org/wiki/Web_colors)
Text_Color = "Pink";
surname_font = str(Font , ":style=", Font_Style);

/*[Advanced Options]*/
//Color of part (color names found at https://en.wikipedia.org/wiki/Web_colors)
Global_Color = "SlateBlue";
//Supression string Key: N - None, L - Left suppressed, R - Right suppressed, B - Both suppressed. With multiple channels, separate them with comma.
Suppress_Connectors = ""; // 

/*[Hidden]*/
//Units of measurement (in mm) for hole and length spacing. Multiboard is 25mm. Untested
Grid_Size = 28;
channelWidthSeparation = 0.8; //distance between the two channels in the monokini profile
channelWidth = (Grid_Size-channelWidthSeparation*2) + (Channel_Width_in_Units-1) * Grid_Size;
curveWidth = Channel_Width_in_Units * Grid_Size;
lengthMM = X_Channel_Length_in_Units_Y_Axis_Bottom * Grid_Size;
lengthMM2 = X_Channel_Length_in_Units_X_Axis_Right * Grid_Size;
lengthMM3 = X_Channel_Length_in_Units_X_Axis_Left * Grid_Size;
lengthMM4 = X_Channel_Length_in_Units_Y_Axis_Top * Grid_Size;
baseHeight = 3.40;
topHeight = 18.60;
interlockOverlap = 3.40; //distance that the top and base overlap each other
interlockFromFloor = 3.40; //distance from the bottom of the base to the bottom of the top when interlocked
partSeparation = 10;
topChamfer = 4;
Nudge = 0.01; //nudge the profile to avoid z-fighting
snapWallThickness = 2;
gripSize = 15;

Suppress_List = str_split(upcase(Suppress_Connectors), ",");
//Convert the string to a list of strings. This is used to determine if the connector should be suppressed or not.

///*[Visual Options]*/
Debug_Show_Grid = false;
//View the parts as they attach. Note that you must disable this before exporting for printing. 
Show_Attached = false;


//module mw_plate_1 {
union() {
fwd(lengthMM/2+curveWidth/2)
diff() {
color_this(Global_Color) 
  monokiniChannel(lengthMM = lengthMM, widthMM = channelWidth, heightMM = Channel_Total_Height, anchor = CENTER, orient = TOP, spin = 0, suppress = Suppress_List[0])

  if (Cord_Side_Cutouts != "None" && Number_of_Cord_Cutouts > 0) {
    /*
                translate(v = [internalWidth/2+cordCutoutLateralOffset,internalDepth/2+cordCutoutDepthOffset,-1]) {
                    union(){
                        cylinder(h = baseThickness + frontLowerCapture + 2, r = cordCutoutDiameter/2);
                        translate(v = [-cordCutoutDiameter/2,0,0]) cube([cordCutoutDiameter,internalWidth/2+wallThickness+1,baseThickness + frontLowerCapture + 2]);
                    }
                }
                */
                tag("remove") color_this(Global_Color) attach(CENTER) up(snapWallThickness) fwd(Shift_Cutouts_Forward_or_Back) {
                    ycopies(n=Number_of_Cord_Cutouts, spacing=Distance_Between_Cutouts) {
                        left(Cord_Side_Cutouts == "Right Side" ? channelWidth/2 : 0)
                        left(Cord_Side_Cutouts == "Left Side" ? -channelWidth/2 : 0)
                            // cuboid([Cord_Side_Cutouts == "Both Sides" ? channelWidth + 5 : channelWidth/2, Cord_Cutout_Width, Channel_Total_Height-snapWallThickness], chamfer = 2, edges=[BOT+FWD, BOT+BACK], orient=TOP, anchor=BOTTOM);
                            up(snapWallThickness) color_this(Global_Color) cylinder(h = Cord_Side_Cutouts == "Both Sides" ? channelWidth + 5 : channelWidth/2, r = Cord_Cutout_Width/2, orient=LEFT, anchor=LEFT, $fn=50)
                            attach(RIGHT,BOT, overlap=Cord_Cutout_Width/2) color_this(Global_Color) cube([Cord_Side_Cutouts == "Both Sides" ? channelWidth + 5 : channelWidth/2, Cord_Cutout_Width, Channel_Total_Height-snapWallThickness-Cord_Cutout_Width/2], spin=90);
                    }
                }

            }
            
 if(Add_Label) tag("remove") recolor(Text_Color)
    right(Text_x_coordinate) text3d(Text, size = Text_size, h=Text_Depth > 0.05 ? Nudge+Text_Depth : 0.05, font = surname_font, atype="ycenter", anchor=CENTER, spin=-90, orient=BOT);
if(Add_Label) tag("keep") recolor(Text_Color)
    right(Text_x_coordinate) text3d(Text, size = Text_size, h=Text_Depth > 0.05 ? Text_Depth : 0.05, font = surname_font, atype="ycenter", anchor=CENTER, spin=-90, orient=BOT);
}

right(lengthMM2/2+curveWidth/2) color_this(Global_Color) 
  monokiniChannel(lengthMM = lengthMM2, widthMM = channelWidth, heightMM = Channel_Total_Height, anchor = CENTER, orient = TOP, spin = 90, suppress = Suppress_List[1]);

left(lengthMM3/2+curveWidth/2) color_this(Global_Color) 
  monokiniChannel(lengthMM = lengthMM3, widthMM = channelWidth, heightMM = Channel_Total_Height, anchor = CENTER, orient = TOP, spin = -90, suppress = Suppress_List[2]);

back(lengthMM4/2+curveWidth/2)
color_this(Global_Color) 
  monokiniChannel(lengthMM = lengthMM4, widthMM = channelWidth, heightMM = Channel_Total_Height, anchor = CENTER, orient = TOP, spin = 0, suppress = Suppress_List[3]);

color_this(Global_Color)
zrot_copies(n = 2) {
     
        front_half(y=Nudge) right_half(x=-Nudge)
        monokiniChannelCurve(lengthMM = lengthMM, widthMM = channelWidth, heightMM = Channel_Total_Height);


        xflip() front_half(y=Nudge) right_half(x=-Nudge)
        monokiniChannelCurve(lengthMM = lengthMM, widthMM = channelWidth, heightMM = Channel_Total_Height);
}

}

/*

***BEGIN MODULES***

*/
module monokiniGrip(widthMM = 26.4, heightMM = 22) {

        
        snapCaptureStrength = 0.7;
        baseChamfer = 0.5;
        topLittleChamfer = 0.4;
        spacingFromChannel = 6.5;
        
        chamferPosY = spacingFromChannel - (baseHeight - snapWallThickness);
        chamferPosY2 = gripSize + spacingFromChannel + (baseHeight - snapWallThickness);

        

 monokiniProfileGrip =
        [
            [snapCaptureStrength,0],
            [snapCaptureStrength, baseHeight-snapWallThickness],
            [0, baseHeight-snapWallThickness/2],
            [0, baseHeight-topLittleChamfer],
            [snapCaptureStrength, baseHeight],
            [snapWallThickness, baseHeight],
            [snapWallThickness, 0]
        ];


    gripPath = [[-1*widthMM/2,spacingFromChannel],[-1*widthMM/2,gripSize+spacingFromChannel]];
    up(heightMM-baseHeight) difference() { 
        path_extrude2d( gripPath ) 
            polygon(monokiniProfileGrip); 
            //path_extrude(path, shape, anchor=BOTTOM, orient=TOP, spin=0, size=[2,2], $fn=50)
            //color("red")
            up(baseHeight)
            left(11.2)
            back(chamferPosY) 
            zrot(-90)
            yrot(180) 
            xrot(90)
            linear_extrude(snapWallThickness) 
            right_triangle([baseHeight,baseHeight]);
            //color("red")
            up(baseHeight)
            left(13.2)
            back(chamferPosY2) 
            zrot(90)
            yrot(180) 
            xrot(90)
            linear_extrude(snapWallThickness) 
            right_triangle([baseHeight,baseHeight]);
    }
}

module monokiniChannel(lengthMM = 28, widthMM = 26.4, heightMM = 22, anchor, spin, orient, suppress = "") {
    
    // echo("Suppress: ", suppress);
    // zrot(180) xrot(90) path_extrude( monokiniProfile()) square([2,channelWidth]); //path_extrude(path, shape, anchor=BOTTOM, orient=TOP, spin=0, size=[2,2], $fn=50)
    monokiniProfile = [
            [-1*widthMM/2, heightMM-baseHeight],
            [-1*widthMM/2, topChamfer],
            [-1*widthMM/2+topChamfer, 0],
            [widthMM/2-topChamfer, 0],
            [widthMM/2, topChamfer],
            [widthMM/2, heightMM-baseHeight]
        ];
    pathChannel = [[0,0],[0,lengthMM-Nudge]];
    
    roff_Profile = offset(monokiniProfile, delta=-snapWallThickness); //create the monokini profile
    point1 = select(monokiniProfile, 0); //get the first point of the profile
    point2 = select(roff_Profile, 0); //get the first point of the offset profile
    point3 = select(roff_Profile, -1); //get the last point of the offset profile
    roff_Profile2 = list_set(roff_Profile, 0, [point2[0], point1[1]]); //fix the first point to be the same as the original profile
    roff_Profile3 = list_set(roff_Profile2, -1, [point3[0], point1[1]]); //fix the first point to be the same as the original profile

    off_Profile2 = concat(monokiniProfile,reverse(roff_Profile3)); //reverse the order of the points to match the original profile

    // stroke(off_Profile2);
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, topHeight + (heightMM-12)]){
    fwd(lengthMM/2) union() {
    back(lengthMM-Nudge/2) xrot(90) linear_extrude(height=lengthMM+Nudge) 
    polygon(off_Profile2);
     if (lengthMM > gripSize)
        path_copies(pathChannel, spacing=Grid_Size) {
            right(Grid_Size/2)
            zrot(90) 
            down(22-heightMM) {
            // echo("Index: ", $idx, " Suppress: ", suppress[$idx]);
                if (suppress[$idx] != "B" && suppress[$idx] != "L")
                    monokiniGrip(widthMM = widthMM);
                if (suppress[$idx] != "B" && suppress[$idx] != "R")
                    xflip() monokiniGrip(widthMM = widthMM);
            }
        }
    } children();
    } 
 }

 module monokiniChannelCurve(lengthMM = 28, widthMM = 26.4, heightMM = 22, anchor, spin, orient) {
    
    
    // zrot(180) xrot(90) path_extrude( monokiniProfile()) square([2,channelWidth]); //path_extrude(path, shape, anchor=BOTTOM, orient=TOP, spin=0, size=[2,2], $fn=50)
    monokiniProfile = [
            [-1*widthMM/2, heightMM-baseHeight],
            [-1*widthMM/2, topChamfer],
            [-1*widthMM/2+topChamfer, 0],
            [widthMM/2-topChamfer, 0],
            [widthMM/2, topChamfer],
            [widthMM/2, heightMM-baseHeight]
        ];
    pathChannel = list_rotate(list_insert(list_insert(arc(90, r = widthMM/2, angle = [180,90], endpoint= true), 0, [-widthMM/2,-channelWidthSeparation-Nudge]), 0, [channelWidthSeparation+Nudge,widthMM/2]));
    
    roff_Profile = offset(monokiniProfile, delta=-snapWallThickness); //create the monokini profile
    point1 = select(monokiniProfile, 0); //get the first point of the profile
    point2 = select(roff_Profile, 0); //get the first point of the offset profile
    point3 = select(roff_Profile, -1); //get the last point of the offset profile
    roff_Profile2 = list_set(roff_Profile, 0, [point2[0], point1[1]]); //fix the first point to be the same as the original profile
    roff_Profile3 = list_set(roff_Profile2, -1, [point3[0], point1[1]]); //fix the first point to be the same as the original profile

    off_Profile2 = concat(monokiniProfile,reverse(roff_Profile3)); //reverse the order of the points to match the original profile

    // stroke(off_Profile2);
    //attachable(anchor, spin, orient, size=[widthMM, lengthMM, topHeight + (heightMM-12)]){
    // fwd(lengthMM/2) 
   
    union() {
    // back(lengthMM-Nudge/2) xrot(90) linear_extrude(height=lengthMM+Nudge) 
    move(v=[widthMM/2,-widthMM/2,0]) 
 //   back_half(s = max(widthMM*2, heightMM*2), y=-Nudge) 
 //   left_half(s = max(widthMM*2, heightMM*2), x=Nudge) 
    path_extrude2d(pathChannel)
    polygon(off_Profile2);
 
    } children();
    //} 
 }


//calculate the max x and y points. Useful in calculating size of an object when the path are all positive variables originating from [0,0]
function maxX(path) = max([for (p = path) p[0]]) + abs(min([for (p = path) p[0]]));
function maxY(path) = max([for (p = path) p[1]]) + abs(min([for (p = path) p[1]]));
