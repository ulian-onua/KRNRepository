unit core;

interface
uses crt, dos, atd_linklist;

type way_type = (up, down, left, right); {���� �������� ������}

type field_Obj = object  {��ꥪ� - "����"}
private
        x1, y1, x2, y2 : integer;  {���न���� ����}
public
        constructor Init (const e_x1, e_y1, e_x2, e_y2 : integer); {���樠������}
        procedure Draw; {���ᮢ��� ����}
        procedure Delete; {㤠���� ����}
        function GetX1 : integer;  {������ �1}
        function GetX2 : integer;  {������ �2}
        function GetY1 : integer;  {������ y1}
        function GetY2 : integer;  {������ y2}
end;

type zm_el_Obj = object {��ꥪ� - "������� ������"}
private
        X, Y : integer; {���न���� �������}
public
        constructor Init (const e_X, e_Y : integer); {���樠������}
        procedure Draw; {���ᮢ��� �������}
        procedure Delete; {㤠���� �������}
        function GetX : integer; {������ �}
        function GetY : integer; {������ y}
        procedure SetX (const e_X : integer); {��⠭����� �}
        procedure SetY (const e_Y : integer); {��⠭����� Y}
end;

type zmeika_Obj = object  {��ꥪ� "������"}
private
        zm_els : array[1..200] of zm_el_Obj; {���ᨢ ������⮢ ������}
        way : way_type; {���ࠢ����� �������� ������}
        speed : word; {᪮���� �������� ������}
        length : word; {����� ������}
        AddEl : boolean; {����砥�, �� �㦭� �������� ������� �� ��������}
public
        constructor Init(startX, startY : integer; const e_length : integer);  {���樠������}
        procedure Draw;    {���ᮢ��� ������}
        procedure Delete;  {㤠���� ������}
        procedure Move;    {������ ������ � ᮮ⢥��⢨� � ᪮����� � ���ࠢ������}
        procedure Add;     {�������� ������� � ������}
        procedure SetWay (const e_way : way_type); {��⠭����� ���ࠢ�����}
        function GetWay : way_type; {������ ���ࠢ�����}
        procedure GetHeadXY (var x, y : integer); {������ ���न���� ������ ������}
        function CheckHead : boolean;   {�஢���� ������ ������ �� ᮯਪ�᭮����� � ��㣨�� ������⠬�}
        function CheckApple (const x_apple, y_apple : integer) : boolean;
end;

type apple_Obj = object (zm_el_Obj)  {��ꥪ� "������" - ��᫥���� ��ꥪ� "������� ������"}
public
        procedure Draw;
        procedure RandomPosition(zmeika : zmeika_obj);
        end;

type help_display_obj = object
     procedure ShowTitle (x : boolean);  {�����뢠�� ��� ��뢠�� �������� ����}
     procedure ShowSpeed (x : boolean; var temp_str : string);  {�।������ ����� ᪮����}
     procedure ShowPause (x : boolean);  {�����뢠�� �� ��㧥 �� ���}
     procedure ShowRepeat (x : boolean); {�।������ ������� ���� ᭮��}
     procedure ShowInfo (x : boolean);   {�����뢠�� ���ଠ�� ᫥��}
     private
     procedure WriteSpaces (const x, y : integer; num : integer); {��ॢ���� ����� � 㪠������ ��� � �뢮��� 㪠������ ���-�� �஡����}
end;

type driver_Obj = object
private
        Clock : word;
public
     (*   constructor Init; *)
       procedure Game;
       procedure Done (var Exit_game : Boolean);
private
        procedure SetSpeed;
end;



procedure CursorHide;


implementation

       procedure CursorHide;
       var r : registers;
       begin
          Windmax := Hi(windmax) + 256;
          Gotoxy (1, 26)
                end;



        constructor field_Obj.Init (const e_x1, e_y1, e_x2, e_y2 : Integer); {���樠������ ��ꥪ� "����"}
        begin
                if (e_x2 > e_x1) and (e_y2 > e_y1) then
                begin
                        x1 := e_x1;
                        x2 := e_x2;
                        y1 := e_y1;
                        y2 := e_y2;
                end
        end;

        procedure field_Obj.Draw; {���ᮢ��� ��ꥪ� "����"}
        var count1, count2 : word; {����稪� 横���}
        begin
                gotoxy (x1, y1);
                Write (#218);
                gotoxy (x2, y1);
                Write (#191);
                gotoxy (x1, y2);
                Write (#192);
                gotoxy (x2, y2);
                Write (#217);

                for count1 := x1 + 1 to x2 - 1 do
                begin
                        gotoxy (count1, y1);
                        write (#196);
                        gotoxy (count1, y2);
                        write (#196);
                end;

                for count2 := y1 + 1 to y2 - 1 do
                begin
                        gotoxy (x1, count2);
                        write (#179);
                        gotoxy (x2, count2);
                        write (#179)
                end;
        end;

        procedure field_Obj.Delete; {㤠���� ��ꥪ� "����"}
        var count1, count2 : word;
        begin
                for count1 := x1 to x2 do
                begin
                        gotoxy (count1, y1);
                        write (' ');
                        gotoxy (count1, y2);
                        write (' ');
                end;


                for count2 := y1 to y2 do
                begin
                        gotoxy (x1, count2);
                        write (' ');
                        gotoxy (x2, count2);
                        write (' ')
                end
        end;

        function field_Obj.GetX1 : integer; {������ �1-���न���� ����}
        begin
              GetX1 := x1;
        end;

        function field_Obj.GetX2 : integer; {������ �2-���न���� ����}
        begin
              GetX2 := x2;
        end;

        function field_Obj.GetY1 : integer; {������ y1-���न���� ����}
        begin
              GetY1 := y1;
        end;

        function field_Obj.GetY2 : integer; {������ y2-���न���� ����}
        begin
              GetY2 := y2;
        end;


        constructor zm_el_Obj.Init (const e_X, e_Y : integer); {���樠������ ������� ������}
        begin
                X := e_X;
                Y := e_Y;
        end;

        procedure zm_el_Obj.Draw;  {���ᮢ��� ������� ������}
        begin
                gotoxy (x, y);
                Write (#219);
        end;

        procedure zm_el_Obj.Delete; {㤠���� ������� ������}
        begin
                gotoxy (x, y);
                Write (' ');
        end;

        function zm_el_Obj.GetX : integer; {������ X-���न���� ������� ������}
        begin
                GetX := x
        end;

        function zm_el_Obj.GetY : integer; {������ Y-���न���� ������� ������}
        begin
                GetY := y
        end;

        procedure zm_el_Obj.SetX (const e_X : integer); {��⠭����� �-���न���� ������� ������}
        begin
                x := e_X
        end;

        procedure zm_el_Obj.SetY (const e_Y : integer); {������ Y-���न����� ������� ������}
        begin
                y := e_Y
        end;

        constructor zmeika_Obj.Init(startX, startY : integer; const e_length : integer); {���樠������ ������}
        var count : byte;
        begin
                length := e_length;

                for count := length downto 1 do
                begin
                        zm_els[count].SetX(startX);
                        zm_els[count].SetY(startY);
                        inc(startX);
                end;
                way := right;    {���� - ��ࠢ�}
                AddEl := false;
        end;

        procedure zmeika_Obj.Draw; {���ᮢ��� ������}
        var count : integer;
        begin
              for count := 1 to length do
                zm_els[count].Draw;

        end;

        procedure zmeika_Obj.Delete; {㤠���� ������}
        var count : integer;
        begin
              for count := 1 to length do
                zm_els[count].Delete
        end;

        procedure zmeika_Obj.Move;  {�������� ������}
        var count, tempX, tempY : integer;
        begin

               if addEl then
               begin
                        tempX := zm_els[length].GetX;
                        tempY := zm_els[length].GetY;
                        zm_els[length + 1].SetX(tempX);
                        zm_els[length + 1].SetY(tempY);
               end

                 else
                      zm_els[length].delete;

              for  count := length downto 2 do
              begin
                   tempX := zm_els[count-1].GetX;
                   tempY := zm_els[count-1].GetY;
                   zm_els[count].SetX(tempX);
                   zm_els[count].SetY(tempY);
              end;

              case way of
                up : zm_els[1].SetY(zm_els[1].GetY - 1);
                down : zm_els[1].SetY(zm_els[1].GetY + 1);
                left : zm_els[1].SetX(zm_els[1].GetX - 1);
                right :  zm_els[1].SetX(zm_els[1].GetX + 1);
              end;

              zm_els[1].draw;

              if (addEl) then
              begin
                inc(length);
                addEl := false;
              end;
              gotoxy (79, 25)

        end;


        procedure zmeika_Obj.Add;  {�������� ������� � ������}
        var tempX, tempY : integer;
        begin

                addEl := true;
        end;

        procedure zmeika_Obj.SetWay (const e_way : way_type); {��⠭����� ���ࠢ�����}
        begin
                way := e_way;
        end;

        function zmeika_Obj.GetWay : way_type;  {������ ���ࠢ����� ������}
        begin
                GetWay := way;
        end;

        procedure zmeika_Obj.GetHeadXY (var x, y : integer);  {������� ���न���� ������ ������}
        begin
                x := zm_els[1].GetX;
                y := zm_els[1].GetY;
        end;

        function zmeika_Obj.CheckHead : boolean;
        var count : integer;
            x : boolean;
        begin
                x := true;
                for count := 2 to length do
                        if (zm_els[1].GetX = zm_els[count].GetX) and
                            (zm_els[1].GetY = zm_els[count].GetY) then
                        begin
                             x := false;
                             break;
                        end;
                CheckHead := x;
        end;

        function zmeika_obj.CheckApple (const x_apple, y_apple : integer) : boolean;
        var count : integer;
            x : boolean;
        begin
                x := true;

                for count := 1 to length do
                        if (x_apple = zm_els[count].GetX) and
                           (y_apple = zm_els[count].GetY) then
                        begin
                                x := false;
                                break;
                        end;
                CheckApple := x;
        end;


        procedure Apple_Obj.Draw;  {���ᮢ��� ���}
        begin
                gotoxy (x, y);
                Write ('*');
                gotoxy (79, 25);
        end;



           procedure Apple_Obj.RandomPosition (zmeika : zmeika_obj);
           var spisok : linklist;
               count1, count2, gencount : integer;
            //   temp_x, temp_y : integer;

           begin
                spisok.init;

                for count1 := 6 to 22 do
                        for count2 := 21 to 59 do
                         if zmeika.CheckApple (count2, count1) then
                                spisok.addtolink (count2, count1);

                 Randomize;
                 gencount := random (spisok.Getlength) + 1;
                 spisok.getByNumber (gencount, x, y);
               {  gotoxy (40, 2);
                 write (temp_x, '  ', temp_y);
                 x := temp_x;
                 y := temp_y;  //debug }
           end;

       procedure help_display_obj.WriteSpaces (const x, y : integer; num : integer);
       begin
            Gotoxy (x, y);
            while num <> 0 do
            begin
                write (' ');
                dec(num);
            end;
       end;

       procedure help_display_obj.ShowTitle (x : boolean);
       var temp_str : string;
       begin
              temp_str := '���: "������". �����: 1.0. ����: kornet.';
              Gotoxy (20, 1);
              if x then
                Write (temp_str)
              else
                Self.WriteSpaces (30, 1, Length(temp_str));
       end;



       procedure help_display_obj.ShowSpeed (x : boolean; var temp_str : string);

       begin
              temp_str := '������ ᪮���� ���� (� ��) : ';
              GoToXy (25, 3);

            if x then
               Write (temp_str)
            else
               //Write ('                                      ');
               Self.WriteSpaces (25, 3, Length(temp_str) + 10);
       end;

       procedure help_display_obj.ShowPause (x : boolean);
       begin

              GoToXy (38, 24);
            if x then
               Write ('��㧠')
            else
                Write ('     ');
            Gotoxy (79, 24);
       end;

       procedure help_display_obj.ShowRepeat (x : boolean);
       begin
                GoToXy (35, 23);
                 if x then
                   Write ('��� ����祭�? ������� (y/n)?')
                 else
                   Write ('                               ')
       end;

         procedure help_display_obj.ShowInfo (x : boolean);
         begin
                Gotoxy (64, 13);
                Write ('[��㧠] - P');
                Gotoxy (64, 15);
                Write ('[��室] - Esc');
         end;


        procedure driver_Obj.SetSpeed;
        var temp_str : string;
        var key : char;
        begin
              clock := 7;

              temp_str := '�롥�� ᪮���� ���� : ';
              GoToXy (25, 3);
              write (temp_str);
              gotoxy (25 + length(temp_str) + 1, 3);
              Write (clock);
              Gotoxy (79, 24);

              repeat
              key := readkey;
              if (UpCase (key) in ['W', 'S']) then
              begin
                if (UpCase (key) = 'W') then
                begin
                   if clock = 7 then
                        clock := 1
                   else
                        inc (clock);
                end
                 else
                   begin
                      if clock = 1 then
                        clock := 7
                   else
                        dec (clock);
                   end;
              gotoxy (25 + length(temp_str) + 1, 3);
              Write (clock);
              Gotoxy (79, 24);
              end;

              until key = #13;

              case clock of
                 7 : clock := 50;
                 6 : clock := 75;
                 5 : clock := 100;
                 4 : clock := 125;
                 3 : clock := 150;
                 2 : clock := 175;
                 1 : clock := 200;
              end;

         end;
        procedure driver_Obj.game;
        var field : field_obj;
            zmeika : zmeika_obj;
            apple : apple_obj;
            game_over : boolean;
            key : char;
            tempX, tempY : integer;
            disp : help_display_obj;
            temp : string;
        begin
            clrscr;
            disp.ShowTitle (true);
            field.init (20, 5, 60, 23);
            field.draw;
           // disp.ShowSpeed (true);
            Self.SetSpeed;
           // Readln (clock);
            disp.ShowSpeed (false, temp);
            disp.ShowInfo(true);
            zmeika.init (23, 14, 3);
            zmeika.draw;
            Apple.Init (34, 10);
            Apple.RandomPosition(zmeika);
            Apple.Draw;
            game_over := false;



            while not game_over do
            begin
                Delay (clock);
                zmeika.Move;

                zmeika.GetHeadXY (tempX, tempY);
                if (tempX in [field.GetX1, field.GetX2]) or
                                  (tempY in [field.GetY1, field.GetY2]) then
                        game_over := true;
                if zmeika.CheckHead = false then
                        game_over := true;

                if not game_over then
                begin
                        if (tempX = apple.GetX) and (tempY = apple.GetY) then
                        begin
                                zmeika.Add;
                                apple.RandomPosition(zmeika);
                                apple.Draw;
                        end;

                        if keypressed then
                        begin
                                key := readkey;
                                if UpCase(key) in ['W', 'A', 'S', 'D'] then
                                begin
                                        case Upcase(key) of
                                        'W' : if zmeika.GetWay <> down then
                                                zmeika.SetWay(up);
                                        'A' : if zmeika.GetWay <> right then
                                                zmeika.SetWay(left);
                                        'D' : if zmeika.GetWay <> left then
                                                zmeika.SetWay(right);
                                        'S' : if zmeika.GetWay <> up then
                                                zmeika.SetWay(down);
                                        end;
                                end
                                else
                                     if Upcase(key) = 'P' then
                                     begin
                                        key := #0;
                                        disp.ShowPause(true);
                                        repeat
                                        if keypressed then
                                                key := readkey;
                                        until key = 'p';
                                        disp.ShowPause(false);
                                     end {if key = p}
                                     else
                                        if key = #27 then
                                                halt;
                         end; {if keypressed}
                 end; {if not game_over}
            end; {while not gameover}
        end;

 procedure driver_Obj.Done(var Exit_game : Boolean);
 var key: char;
 begin
        Gotoxy (20, 24);
        Write ('��� ����祭�? ������� (y/n)?');
        Gotoxy (79, 24);
        key := #0;
        repeat
        key := readkey;
        until UpCase (key) in ['Y', 'N'];

        Exit_Game := UpCase(key) = 'Y';
 end;

end.

























