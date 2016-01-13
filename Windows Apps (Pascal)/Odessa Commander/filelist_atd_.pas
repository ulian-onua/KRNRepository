unit filelist_atd;

interface

        uses Dos, Crt, Tabul_Atd, onefile_atd, DOSWIN;

        type onefilearray = array [1..maxint] of onefile;
             files_pointer = ^onefilearray;


        type filelist = object

           public
           constructor init (Coordinates : Coords; thistabula : tabula);
           procedure getfilelist;  {������� ᯨ᮪ 䠩���}
           procedure ClearDisplay; {������ �������}
           procedure DoDisplay (i : word); {�뢥�� ᯨ᮪ 䠩���}
           procedure filelist_driver;    {�ࠢ����� ����ணࠬ��}

         private
                first, second : Coords; {���न���� ��ࢮ�� � ��ண� �⮡殢}
                numfiles : word;
                files : files_pointer;
                procedure addfileinfo (var i : word; S : SearchRec); {�������� ���ଠ�� � 䠩�� � ���ᨢ}
                procedure ClearColumn (X : Coords); {������ �������}
                procedure  DisplayColumn (X : Coords; var i : word);  {�뢥�� �������}
                procedure Restore_Native (X, Y : byte; i : word);  {������ 䠩�� �� �࠭� த��� 梥�}
                procedure Draw_Cursor (X, Y : byte; i : word; Color : byte);
                converter : doswinconverter;
         end;


implementation

          constructor filelist.init (Coordinates : Coords; thistabula : tabula);
           begin
                thistabula.Get_Cursor_Position_Coordinates (Coordinates,
                                                   first, second);
                numfiles := 0;   {���-�� 䠩���}
                window (1, 1, 80, 25);
           end;


           procedure filelist.addfileinfo (var i : word; S : SearchRec);  {�������� ���ଠ�� � 䠩�� � ���ᨢ}
           begin
                    inc (i);            {㢥��稢��� ���稪 ���ᨢ�}
                    files^[i].GetFromSearch (S);  {�����㥬 ���ଠ�� �� SearchRec � ����� ���ᨢ�}
                    files^[i].SetFileInformation; {��⠭�������� ���ଠ�� 䠩�� (�. onefile_atd)}
           end;

           procedure filelist.getfilelist;
           var S : SearchRec;
               i : word;
           begin

                Findfirst ('*.*', Anyfile, S);    {�饬 ���� 䠩�}

                if DoSError = 0 then            {�᫨ �� �訡�� � }
                if S.Name <> '.' then           {��� 䠩�� - �� �窠}
                       inc (numfiles);          {㢥��稢��� ���-�� 䠩���}

                while DosError = 0 do begin       {������ ���-�� 䠩���}
                      FindNext (s);
                      if DoSError = 0 then
                      inc (numfiles)
                end;


                GetMem (files, Sizeof (onefile) * numfiles); {�뤥��� ������}
                 i := 0;      {���稪 ���ᨢ�}

                      Findfirst ('*.*', Anyfile, S);  {����� ��� �ய�᪠��}
                        if DoSError = 0 then            {�᫨ �� �訡�� � }
                        if S.Name <> '.' then begin         {��� 䠩�� - �� �窠}
                            converter.decode_string (S.Name);
                            Self.addfileinfo (i, S);    {������塞 䠩�}
                          end;
                      while DoSError = 0 do begin
                            FindNext (s);
                        if DoSError = 0 then begin
                            converter.decode_string (S.Name);
                            Self.addfileinfo (i, S);  {������塞 ���� � 䠩��}
                        end
                      end
           end;

             procedure filelist.DisplayColumn (X : Coords; var i : word);
            var i2 : byte;
            begin
                    i2 := X.LeftY;

                   while (i <= numfiles) and (i2 <= X.RightY) do begin
                   Gotoxy (X.LeftX, i2);
                   textcolor (files^[i].GetFileColor); {����砥� 梥� 䠩��}
                   files^[i].SetCoordinates (X.LeftX, i2);  {��⠭�������� ���न����}
                   Write (files^[i].GetFileName);  {�뢮��� ���}
                   inc (i);
                   inc (i2)
                 end;
            end;


            procedure filelist.DoDisplay (i : word);


            begin
                  ClearDisplay;         {��頥� �࠭}
                  DisplayColumn (First, i);   {�⮡ࠧ��� ����� �������}

              if i <= numfiles then             {�᫨ ����� ���ᨢ� ����� ���-�� 䠩��� �}
                   DisplayColumn (Second, i);  {�⮡ࠧ��� ����� �������}

           Gotoxy (1, 1);
       end;


          procedure filelist.ClearColumn (X : Coords);  {������ �������}
          var i2 : byte;
          begin
                for i2 := X.LeftY to X.RightY do begin
                  gotoxy (X.LeftX, i2);
                  write (' ' : 12);
                end;
          end;


       procedure filelist.ClearDisplay;
          var i2 : byte;
          begin
                ClearColumn (First);   {��頥� ����� �������}
                ClearColumn (Second);  {��頥� ����� �������}
          end;


      procedure filelist.Restore_Native (X, Y : byte; i : word);  {������ த��� 梥� ��᫥ �����}
       begin
               GotoXy (X, Y);   {���室�� �㤠 ��� ����}
               textcolor (files^[i].GetFileColoR);  {���⠭�������� த��� 梥�}
               Write (files^[i].GetFileName);      {��㥬}
       end;

       procedure filelist.Draw_Cursor (X, Y : byte; i : word; Color : byte);
       begin
             GotoXY (X, Y);  {���室�� � �㦭��� �����}
             if Color = 0 then   {�᫨ 梥� = 0}
             textcolor (files^[i].GetFileColor + Blink) {� �㤥� ���栭��}
             else begin                         {����}
              textbackground (color);            {������� 梥� - 䮭���}
              textcolor (files^[i].GetFileColor) {� 梥� ⥪�� - �⠭�����}
             end;

             Write (files^[i].GetFileName);   {�������}
             textbackground (black);          {������ ��� 梥�}
       end;


       procedure filelist.filelist_Driver;
       var i : word;    {���稪 ���ᨢ�}
           i2 : byte; {���稪 �⮫�� - "��������" }
              ch : char;
              CurrentX : byte;

       const Cursor_Color = 5;

       begin

            i := 1;   {���稪 ࠢ�� ������}
            DoDisplay (i);
           i2 := first.LeftY; {��砫� ����� -  � ��砫� ������ �⮫��}

            CurrentX := first.LeftX;  {ᮮ⢥��⢥��� � � ����� ������ - ����}


            Draw_Cursor (CurrentX, i2, i, Cursor_Color);

            repeat
            ch := readkey;  {���� �������}
            if ch = #0 then  {�᫨ ��⠭�� ᨬ��� = 0, �}
            ch := readkey;   {���뢠�� ���७�� ���}
                              {�᫨ �� - ��५�� ����}

           if ch = #80 then begin     {�᫨ �� ��५�� ���� �}




               if i <> numfiles then begin {�᫨ ����� ���ᨢ� ࠢ�� ����� ���ᨢ�, � ���� ��祣� �� ������}
                         Restore_Native (CurrentX, i2, i); {����⠭�������� �⠭����}

                if (i2 = first.RightY) and (CurrentX = first.LeftX) then begin {�᫨ �� ����� �⮫��, �}
                  i2 := second.LeftY;    {���� Y - ��४ �ࠢ��� �⮫��}
                  CurrentX := Second.LeftX;  {"�����騩" � - ��ன �}
                  inc (i)              {㢥��稢��� ����� ���ᨢ� �� 1}
               end
               else if i2 = Second.RightY then begin  {����, �᫨ �� ����� �ࠢ��� �⮫��}
                  inc (i);          {㢥��稢��� ����� ���ᨢ� �� 1}
                  DoDisplay (i);    {�뢮��� ⠡����, ��稭�� � ����� ���ᨢ�}
                  i2 := first.LeftY;      {����  ���� ���न���� i2 (���� ���孨� ��४)}
                  CurrentX := first.LeftX {�����騩 � - ����.���멕}
               end
               else begin      {����}
                inc (i);      {㢥��稢��� ����� ���ᨢ� �� 1}
                inc (i2);     {� ��������� �����}
                end;

             Draw_Cursor (CurrentX, i2, i, Cursor_color);
          end
          end

          else if ch = #72 then begin


               if i <> 1 then begin
                   Restore_Native (CurrentX, i2, i); {����⠭�������� �⠭����}

               if (i2 = Second.LeftY) and (CurrentX = Second.LeftX) then begin
                   i2 := First.RightY;
                   CurrentX := First.LeftX;
                   dec (i);
              end
              else if i2 = First.LeftY then begin
                   Dodisplay (i - 36);
                   dec (i);
                   i2 := Second.RightY;
                   CurrentX := Second.LeftX;
              end
              else begin
                  dec (i);
                  dec (i2)
              end;

             Draw_Cursor (CurrentX, i2, i, Cursor_Color);
              end

          end

          else if ch = #77 then begin

             if i + 18 <= numfiles then begin
                Restore_Native (CurrentX, i2, i);

             if CurrentX = First.LeftX then begin
                inc (i, 18);
                CurrentX := Second.LeftX;
             end
             else if CurrentX = Second.LeftX then begin
                 Dodisplay (i + (Second.RightY - i2 + 1));
                 inc (i, 18);
                 CurrentX := First.LeftX
             end;


             Draw_Cursor (CurrentX, i2, i, Cursor_Color);
         end

         end

         else if ch = #75 then begin

           if i - 18 >= 1 then begin
              Restore_Native (CurrentX, i2, i);
           if CurrentX = Second.LeftX then begin
              dec (i, 18);
              CurrentX := First.LeftX
           end
           else if CurrentX = First.LeftX then begin
                Dodisplay (i - 36 - (i2 - First.LeftX));
                dec (i, 18);
                CurrentX := Second.LeftX
           end;

               Draw_Cursor (CurrentX, i2, i, Cursor_Color);
           end
         end;
             until ch = #27;

       end;




   end.
