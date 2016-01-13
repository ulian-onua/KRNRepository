program test_tabula;

uses tabul_atd, crt;

var x : tabula;
var first, second : Coords;

begin

        x.init (1, 3);
        x.Draw_Visual_Part;

        x.Get_Cursor_Position_Coordinates
        (x.Get_Right_Column_Coordinates, first, second);

       {   window (1, 1, 80, 25);
          gotoxy (second.RightX, second.RightY);}
          readln
 end.
