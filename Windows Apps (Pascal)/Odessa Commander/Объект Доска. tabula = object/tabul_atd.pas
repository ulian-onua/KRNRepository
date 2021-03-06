unit tabul_atd;





interface
        uses crt;

        type tabula_coord = record  {���न���� ��᪨}
         MinX, MinY, MaxX, MaxY : byte
         end;

        type Coords = record       {���न���� - �ᯮ������� ��� �ᥣ� ��⠫쭮��}
            LeftX, LeftY, RightX, RightY : byte
        end;

        type tabula_Colors = record  {梥�}
        Ramka_color, Up_menu_color, Down_menu_color, Right_Column_color,
                                               Left_Column_color,
                                               Console_color,
                                               Delimeters_color: byte
        end;

        type ramka_type = record     {⨯ ����� ࠬ�� - ��� ����}
             Left_up_corner, Right_up_corner,
             Left_down_corner, Right_down_corner,
             Down_Line, Forward_line : char;
        end;

        type Main_tabula = record {�᭮���� �����}
         Tabula_pos : tabula_coord; {���न���� ��᪨}
         Up_menu_pos,  {���न���� ���孥�� ����}
         Down_Menu_pos,   {���न���� ������� ����}
         Left_Column_pos,  {���न���� ������ �⮫��}
         Right_Column_pos, {���न���� �ࠢ��� �⮫��}
         Console_pos : Coords;   {���न���� ���᮫�}
         ramka_lines : ramka_type;   {⨯ ����� ࠬ��}
         Colors : tabula_colors  {梥�}
         end;

       type main_lines_type = record  {⨯� ����� ࠧ����� ����}
           Menu_Up_lines,
           Menu_Down_lines,
           Left_Column_lines,
           Right_Column_lines,
           Console_lines       : ramka_type;
           Right_Delimiter_line,
           Left_Delimiter_line : char;
       end;

       type tabula = object
       public
        constructor init (_step : integer; r_color : integer); {���樠������}
        procedure draw_ramka;   {��㥬 ࠬ��}
        procedure draw_Up_Menu;  {��㥬 ���孥� ����}
        procedure Draw_Down_Menu; {��㥬 ������ ����}
        procedure Draw_Left_Column; {��㥬 ���� �⮫���}
        procedure Draw_Right_Column; {��㥬 �ࠢ� �⮫���}
        procedure Draw_Console;      {��㥬 ��������� ��ப�}
        procedure Draw_Visual_Part;  {���� ��}
        function Get_ramka_coordinates : Tabula_Coord; {������� ���न���� ࠬ��}
        function Get_Up_menu_coordinates : Coords;   {������� ���न���� ���孥�� ����}
        function Get_Down_menu_coordinates : Coords; {������� ���न���� ������� ����}
        function Get_Left_Column_Coordinates : Coords; {������� ���न���� ������ �⮫��}
        function Get_Right_Column_Coordinates : Coords; {������� ���न���� �ࠢ��� �⮫��}
        function Get_Console_Coordinates : Coords; {������� ���न���� ��������� ��ப�}
        procedure Set_ramka_coordinates (coordinates : Tabula_Coord); {��⠭����� ���न���� ࠬ��}
        procedure Set_Up_menu_coordinates (coordinates : Coords); {��⠭����� ���न���� ���孥�� ����}
        procedure Set_Down_menu_coordinates (coordinates : Coords); {��⠭����� ���न���� ������� ����}
        procedure Set_Left_Column_Coordinates (coordinates : Coords); {��⠭����� ���न���� ������ �⮫��}
        procedure Set_Right_Column_Coordinates (coordinates : Coords); {��⠭����� ���न���� ���᮫�}
        procedure Set_Console_Coordinates (coordinates : Coords); {��⠭����� ���न���� ���᮫�}
        procedure Get_Cursor_Position_Coordinates (Coordinates : Coords; var first, second : Coords);{������� ���न���� ��砫� � ���� �⮫��}
        function Get_Colors : Tabula_Colors;  {������� 梥� }
        procedure Set_Colors (enter_colors : Tabula_colors); {��⠭����� 梥�}
        procedure Set_Ramka_color (enter_color : byte);  {��⠭����� 梥� ࠬ��}
        procedure Set_Up_Menu_color (enter_color : byte); {��⠭����� 梥� ���孥�� ����}
        procedure Set_Down_Menu_color (enter_color : byte); {��⠭����� 梥� ������� ����}
        procedure Set_Left_Column_color (enter_color : byte); {��⠭����� 梥� ����� �������}
        procedure Set_Right_Column_color (enter_color : byte); {��⠭����� 梥� �ࠢ�� �������}
        procedure Set_Delimeters_color (enter_color : byte); {��⠭����� 梥� ࠧ����⥫��}


       private
          main : main_tabula;
          lines_type : main_lines_type;
          step, length_delimeters : byte; {蠣 �ᮢ���� ����}

          procedure GetMaxXY;  {��।����� � ����ᨬ��� �� ��� ०��� - ���� ���������}
          procedure Draw_Rectangle (Left_X, Left_Y, Right_X,
            Right_Y: byte; sym : ramka_type);  {���ᮢ��� ���� � ࠬ���}
          procedure Draw_Down_Line  (Left_X, Left_Y,      {���ᮢ���}
                                     Right_Y : byte; sym : char); {����� ����}
          procedure Draw_Delimiters (Left_X, Left_Y,       {���ᮢ��� }
                                    Right_X, Right_Y, length : byte; sym : char); {ࠧ����⥫�}

       end;


implementation

        procedure tabula.GetMaxXY;
        begin

        with main do begin
            with tabula_Pos do begin
               MaxX := 80;
               MaxY := 25;
            end
        end
        end;

        procedure tabula.Draw_Rectangle (Left_X, Left_Y, Right_X, Right_Y : byte; sym : ramka_type);
        var i : byte;
        begin


          GotoXY (Left_X, Left_Y);           {��㥬}
          Write (Sym.Left_Up_Corner);   {���� ���孨� 㣮�}

          GotoXY (Right_X, Left_Y);         {��㥬}
          Write (Sym.Right_Up_Corner); {�ࠢ� ���孨� 㣮�}

          GotoXY  (Left_X, Right_Y);          {��㥬}
          Write (Sym.Left_Down_Corner);  {���� ������ 㣮�}

          GotoXY (Right_X, Right_Y);         {��㥬}
          Write (Sym.Right_Down_Corner); {�ࠢ� ������ 㣮�}

          GotoXY (Left_X + 1, Left_Y);             {��㥬}
          for i := Left_X + 1 to Right_X - 1 do   {������}
               Write (Sym.Forward_line);           {�����}

          GotoXY (Left_X + 1, Right_Y);            {��㥬}
          for i := Left_X + 1 to Right_X - 1 do    {������}
                Write (Sym.Forward_Line);           {�����}

          for i := Left_Y + 1 to Right_Y - 1 do begin {��㥬}
                GotoXY (Left_X, i);                   {�����}
                Write (Sym.Down_line)                 {�����}
          end;

           for i := Left_Y + 1 to Right_Y - 1 do begin {��㥬}
                GotoXY (Right_X, i);                   {�ࠢ��}
                Write (Sym.Down_line)                  {�����}
          end
       end;


       procedure tabula.Draw_Down_Line (Left_X, Left_Y, Right_Y : byte;
                                                                sym : char);
               var i : byte;
          begin

                for i := Left_Y to Right_Y do begin
                gotoxy (Left_X, i);
                Write (sym)
                end
          end;



        procedure tabula.draw_delimiters (Left_X, Left_Y,
                                    Right_X, Right_Y, length : byte;
                                        sym : char);
        begin
             textcolor (main.colors.delimeters_color);
             Self.Draw_Down_Line (Left_X + length, Left_Y + 1, Right_Y - 1, sym);
             Self.Draw_Down_Line (Left_X + 2 * length, Left_Y + 1, Right_Y - 1, #186)

        end;

        constructor tabula.init (_step : integer; r_color : integer);
        begin
            step := _step;

        with main do begin
            with tabula_Pos do begin {��⠭�������� ���न���� ��᪨}
               MinX := 1;
               MinY := 1;
               GetMaxXY
            end;

             with Ramka_lines do begin {��⠭�������� ᨬ���� ࠬ��}
             Left_up_corner := #218;
             Right_up_corner := #191;
             Left_Down_corner := #192;
             Right_Down_corner := #217;
             Down_line := #179;
             Forward_line := #196
           {    Left_up_corner := #201;
             Right_up_corner := #187;
             Left_Down_corner := #200;
             Right_Down_corner := #188;
             Down_line := #186;
             Forward_line := #205 }
             end;

            begin          {��⠭�������� ���न���� ���孥�� ����}
            Up_menu_pos.LeftX := Tabula_Pos.MinX;
            Up_menu_pos.LeftY := Tabula_Pos.MinY;
            Up_menu_pos.RightX := Tabula_Pos.MaxX;
            Up_menu_pos.Righty := Tabula_Pos.MinY + step;
            end;

            begin         {��⠭�������� ���न���� ������� ����}
            Down_menu_pos.LeftX := Tabula_Pos.MinX;
            Down_menu_pos.LeftY := Tabula_Pos.MaxY - step;
            Down_menu_pos.RightX := Tabula_Pos.MaxX;
            Down_menu_pos.RightY := Tabula_Pos.MaxY
            end;

            begin           {��⠭�������� ���न���� ����� �������}
            Left_Column_Pos.LeftX := Tabula_Pos.MinX + (step * 2);
            Left_Column_Pos.LeftY := Tabula_Pos.MinY + (step * 2);
            Left_Column_Pos.RightX := Tabula_Pos.MaXX div 2 - step;
            Left_Column_Pos.RightY := Tabula_Pos.MaxY - step * 3
             end;

              begin           {��⠭�������� ���न���� �ࠢ�� �������}
            Right_Column_Pos.LeftX := Tabula_Pos.MaXX div 2 + step ;
            Right_Column_Pos.LeftY := Tabula_Pos.MinY + (step * 2);
            Right_Column_Pos.RightX := Tabula_Pos.MaXX - (step * 2);
            Right_Column_Pos.RightY := Tabula_Pos.MaxY - step * 3
             end;

              begin           {��⠭�������� ���न���� ��������� ��ப�}
            Console_Pos.LeftX := Tabula_Pos.MinX + step;
            Console_Pos.LeftY := Tabula_Pos.MaxY - (step * 2);
            Console_Pos.RightX := Tabula_Pos.MaxX;
            Console_Pos.RightY := Tabula_Pos.MaxY - step
             end;

        with colors do begin

        ramka_color := r_color;     {梥� ࠬ��}
        Up_Menu_color := blue; {梥� ���孥�� ����}
        Down_Menu_color := blue;  {梥� ������� ����}
        Left_Column_color := green;
        Right_Column_color := green;
        Console_color := lightgray;
        Delimeters_color := 2
        end
        end;

        length_delimeters := 13 {����� ࠧ����⥫�� ���� - 13}
        end;

       procedure tabula.draw_ramka;  {���ᮢ��� ࠬ��}
       var i : byte;
       begin

           textcolor (main.colors.ramka_color);
           HighVideo;

            with main do
            Draw_Rectangle (Tabula_Pos.MinX, Tabula_Pos.MinX,
                        Tabula_Pos.MaxX, Tabula_Pos.MaxY, ramka_lines)

  end;

  procedure tabula.Draw_Up_Menu;
  begin
         textcolor (main.colors.Up_Menu_color);{梥� ᨬ�����}
         highvideo; {� ०��� ����襭��� �મ��}

    Lines_type.Menu_Up_lines := Main.Ramka_lines; {⨯ ����� - ⠪�� ��, ��� � ࠬ��}

       Draw_Rectangle (Main.UP_Menu_pos.LeftX, Main.Up_Menu_pos.LeftY,
                       Main.Up_Menu_pos.RightX, Main.Up_Menu_pos.RightY,
                       Lines_type.Menu_Up_lines) {��㥬}

  end;

   procedure tabula.Draw_Down_Menu;
  begin


         textcolor (main.colors.Down_Menu_color);{梥� ᨬ�����}
         highvideo;  {� ०��� ����襭��� �મ��}

           Lines_type.Menu_Down_lines := Main.Ramka_lines;{⨯ ����� - ⠪�� ��, ��� � ࠬ��}

       Draw_Rectangle (Main.Down_Menu_pos.LeftX, Main.Down_Menu_pos.LeftY,
                       Main.Down_Menu_pos.RightX, Main.Down_Menu_pos.RightY,
                       Lines_type.Menu_Down_lines) {��㥬}

  end;


  procedure Tabula.Draw_Left_Column;

  begin
       textcolor (main.colors.Left_Column_color); {梥� ᨬ�����}
       highvideo;  {� ०��� ����襭��� �મ��}

            with lines_type.Left_column_lines do begin {������祭�� ᨬ�����}
             Left_up_corner := #213;
             Right_up_corner := #184;
             Left_Down_corner := #212;
             Right_Down_corner := #190;
             Down_line := #179;
             Forward_line := #205
            end;


           Lines_type.Left_Delimiter_line := #179;

            Draw_Rectangle (Main.Left_Column_pos.LeftX, Main.Left_COlumn_pos.LeftY,
                       Main.Left_Column_pos.RightX, Main.Left_Column_pos.RightY,
                       Lines_type.Left_Column_lines); {��㥬}

            Draw_delimiters (Main.Left_Column_pos.LeftX, Main.Left_COlumn_pos.LeftY,
                       Main.Left_Column_pos.RightX, Main.Left_Column_pos.RightY, length_delimeters,
                       Lines_type.Left_Delimiter_line)

            end;

   procedure Tabula.Draw_Right_Column;

  begin
       textcolor (main.colors.Right_Column_color); {梥� ᨬ�����}
       highvideo;  {� ०��� ����襭��� �મ��}

            with lines_type.Right_column_lines do begin {������祭�� ᨬ�����}
             Left_up_corner := #213;
             Right_up_corner := #184;
             Left_Down_corner := #212;
             Right_Down_corner := #190;
             Down_line := #179;
             Forward_line := #205
            end;

            Lines_Type.Right_Delimiter_Line := #179;

            Draw_Rectangle (Main.Right_Column_pos.LeftX, Main.RIght_COlumn_pos.LeftY,
                       Main.Right_Column_pos.RightX, Main.Right_Column_pos.RightY,
                       Lines_type.Right_Column_lines); {��㥬}

             Draw_delimiters (Main.Right_Column_pos.LeftX, Main.Right_COlumn_pos.LeftY,
                       Main.Right_Column_pos.RightX, Main.Right_Column_pos.RightY, length_delimeters,
                       Lines_type.Right_Delimiter_line)

            end;



   procedure Tabula.Draw_Console;

  begin
       textcolor (main.colors.Console_color); {梥� ᨬ�����}
       Lowvideo;  {� ०��� ����襭��� �મ��}

              {������祭�� ᨬ�����}
            Lines_type.Console_lines := Main.Ramka_lines;

            textbackground (black);

            Window (Main.Console_pos.LeftX, Main.Console_pos.LeftY,
                       Main.Console_pos.RightX, Main.Console_pos.RightY);


            gotoxy (Main.Console_pos.LeftX, Main.Console_pos.RightY);
            Write ('C:\')



       end;

  procedure Tabula.Draw_Visual_Part;
  begin
        clrscr;
        Draw_ramka;   {��㥬 ࠬ��}
        Draw_Up_Menu;  {��㥬 ���孥� ����}
        Draw_Down_Menu; {��㥬 ������ ����}
        Draw_Left_Column; {��㥬 ���� �⮫���}
        Draw_Right_Column; {��㥬 �ࠢ� �⮫���}
        Draw_Console   {���᮫�}
  end;

     function Tabula.Get_ramka_coordinates : Tabula_coord;
      begin
             Get_Ramka_coordinates := main.tabula_pos
      end;

     function Tabula.Get_Up_menu_coordinates : Coords;
     begin
                Get_Up_Menu_coordinates := Main.Up_Menu_pos
     end;

     function Tabula.Get_Down_menu_coordinates : Coords;
       begin
                Get_Down_menu_coordinates := Main.Down_menu_pos
       end;

     function Tabula.Get_Left_Column_Coordinates : Coords;
        begin
               Get_Left_Column_coordinates := Main.Left_column_pos
        end;

     function Tabula.Get_Right_Column_Coordinates : Coords;
        begin
                Get_Right_Column_Coordinates := Main.Right_COlumn_Pos
        end;

     function Tabula.Get_Console_Coordinates : Coords;
       begin
             Get_Console_Coordinates := Main.Console_pos
       end;


       procedure Tabula.Set_ramka_coordinates (coordinates : Tabula_coord);
       begin
                 Main.Tabula_Pos := Coordinates
       end;

        procedure Tabula.Set_Up_menu_coordinates (coordinates : Coords);
        begin
                   Main.Up_Menu_pos := Coordinates
        end;

        procedure Tabula.Set_Down_menu_coordinates (coordinates : Coords);
        begin
                   Main.Down_menu_pos := Coordinates
        end;

        procedure Tabula.Set_Left_Column_Coordinates (coordinates : Coords);
        begin
                  Main.Left_column_pos := Coordinates
        end;

        procedure  Tabula.Set_Right_Column_Coordinates (coordinates : Coords);
        begin
                   Main.Right_column_pos := Coordinates
        end;

        procedure Tabula.Set_Console_Coordinates (coordinates : Coords);
         begin
                  Main.Console_Pos := Coordinates
         end;

       procedure Tabula.Get_Cursor_Position_Coordinates (Coordinates : Coords; var first, second : Coords);
       begin
                       {���� �⮫���}
            First.LeftX := Coordinates.LeftX + 1;
            First.LeftY := Coordinates.LeftY + 1;
            First.RightX := Coordinates.LeftX + 1;
            First.RightY := Coordinates. RightY - 1;
                       {��ன �⮫���}
            Second.LeftX :=  Coordinates.LeftX + length_delimeters + 1;
            Second.LeftY := Coordinates.LeftY + 1;
            Second.RightX := Coordinates.LeftX + length_delimeters + 1;
            Second.RightY := Coordinates. RightY - 1
       end;

        function Tabula.Get_Colors : Tabula_Colors;
        begin
                Get_Colors := Main.Colors
        end;

        procedure Tabula.Set_Colors (enter_colors : Tabula_Colors);
        begin
                 Main.Colors := enter_colors
        end;

        procedure Tabula.Set_Ramka_color (enter_color : byte);
        begin
                 Main.Colors.Ramka_color := enter_color
        end;

        procedure Tabula.Set_Up_Menu_color (enter_color : byte);
        begin
                 Main.Colors.Up_menu_color := enter_color
        end;

         procedure Tabula.Set_Down_Menu_color (enter_color : byte);
        begin
                  Main.Colors.Down_menu_color := enter_color
        end;

         procedure Tabula.Set_Right_Column_color (enter_color : byte);
        begin
                 Main.Colors.Right_Column_color := enter_color
        end;

          procedure Tabula.Set_Left_Column_color (enter_color : byte);
        begin
                 Main.Colors.Left_Column_color := enter_color
        end;

          procedure Tabula.Set_Delimeters_color (enter_color : byte);
        begin
                 Main.Colors.Right_Column_color := enter_color
        end;


end.











