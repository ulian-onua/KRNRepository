unit filelist_atd;

interface

        uses Dos, Crt, Tabul_Atd, onefile_atd, DOSWIN(*, com_proc_atd*);

        type onefilearray = array [1..maxint] of onefile;
             files_pointer = ^onefilearray;


        type filelist = object


           constructor init (Coordinates : Coords; thistabula : tabula);
           procedure getfilelist;  {������� ᯨ᮪ 䠩���}
           procedure ClearDisplay; {������ �������}
           procedure DoDisplay (i : word); {�뢥�� ᯨ᮪ 䠩���}
           procedure filelist_driver (var i : word);     {�ࠢ����� ����ணࠬ��}
        {   procedure all_driver;}
           procedure commander (ch : char; i : word);
           destructor destroy;


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
              {  commander : com_proc;  }
                procedure ChangeI (var i : word); {�ࠢ��쭮 ������� i -��� ��楤��� DoDosplay}
                procedure SetPosition_and_CurrentX (var i2, CurrentX : byte; i : byte);
                procedure Cursor_Right (var i : word; var i2, CurrentX : byte);
                procedure Cursor_Left (var i : word; var i2, CurrentX : byte);
                procedure Cursor_Down (var i : word; var i2, CurrentX : byte);
                procedure Cursor_Up (var i : word; var i2, CurrentX : byte);
                ComInt : byte;
         end;


implementation

       {   procedure filelist.all_driver;
           begin
                 getfilelist;
                 filelist_driver (i);
           end;    }


          constructor filelist.init (Coordinates : Coords; thistabula : tabula);
           begin
                thistabula.Get_Cursor_Position_Coordinates (Coordinates,
                                                   first, second);
                numfiles := 0;   {���-�� 䠩���}
                window (1, 1, 80, 25);
                ComInt := 0;
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

                   Write (files^[i].Share (files^[i].GetFileName));  {�뢮��� ���}
                   inc (i);
                   inc (i2)
                 end;
            end;



            procedure  filelist.ChangeI (var i : word); {�ࠢ��쭮 ������� i -��� ��楤��� DoDosplay}
            begin
                if i <= 36 then  {�᫨ i <= 36}
                    i := 1       {� i ࠢ�� 1 - ��稭��� � 1}
                else                   {����}
                    i := i - (i mod 36) + 1;{�⭨���� �� i ���⮪ �� ������� i �� 36 � �ਡ���塞 1}
            end;

            procedure filelist.DoDisplay (i : word);


            begin
                  ClearDisplay;         {��頥� �࠭}
                  ChangeI (i);    {���⠢�塞 �ࠢ��쭮� i}
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
               Write (files^[i].Share (files^[i].GetFileName));      {��㥬}
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

             Write (files^[i].Share (files^[i].GetFileName));   {�������}
             textbackground (black);          {������ ��� 梥�}
       end;


       procedure filelist.SetPosition_and_CurrentX (var i2, CurrentX : byte;
                                            i : byte);  {��।����� ������ ����� � �����騩 �}
       begin
             if i > 36 then      {�᫨ i > 36}
                 i := i mod 36;  {� 㬥��訬 i - �� ���⮪}

             if i <= 18 then begin    {�᫨ i <= 18}
             i2 := first.LeftX + i - 1; {�ਡ���塞 ���� ���孨� 㣮� ��ࢮ�� �⮡� + ������ i - 1}
             CurrentX := first.LeftX  {ᮮ⢥��⢥��� �����騩 � ࠢ�� ������ �}
             end
             else begin
             i2 := Second.LeftY + i - 18 - 1;
             CurrentX := Second.LeftX
             end
       end;

       procedure filelist.Cursor_Down (var i : word; var i2, CurrentX : byte);
       begin
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
                inc (i2)     {� ��������� �����}
                end
                end
       end;

      procedure filelist.Cursor_Right (var i : word; var i2, CurrentX : byte);
      begin
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
        end;
     end;

           procedure filelist.Cursor_Left (var i : word; var i2, CurrentX : byte);
      begin
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
           end
          end
     end;

       procedure filelist.Cursor_Up (var i : word; var i2, CurrentX : byte);
       begin
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
              end
       end
       end;

        procedure filelist.commander (ch : char; i : word);
        var S : string;
        begin
              S := files^[i].GetFileName;

              if ch = #13 then begin   {�᫨ �� enter}

              if files^[i].GetFileType = executable then begin  {�᫨ 䠩� - �ᯮ���⥫��}
               clrscr;                          {��頥� �࠭}
               exec (files^[i].GetFileName, '');  {����᪠�� 䠩�}
               ComInt := 1                        {���뢠��� = 1}
               end;

              if files^[i].GetFileType = Down_Dir then begin
                 converter.uncode_string (S);
                 ChDir (S);
                 ComInt := 2
              end;

                if files^[i].GetFileType = Up_Dir then begin
                     ChDir (S);

                 ComInt := 2
              end;

               end
       end;




       procedure filelist.filelist_Driver (var i : word);{���稪 ���ᨢ�}

        var   i2 : byte; {���稪 �⮫�� - "��������" }
              ch : char;
              CurrentX : byte;
              field : tabula;

       const Cursor_Color = 5;



       begin


            repeat

             if comInt = 1 then begin  {�᫨ ���뢠��� ����. ������ ࠢ�� 1}
                 Self.destroy;
                 field.init (1, 3);      {������}
                 field.Draw_Visual_Part; {���ᮢ뢠�� ����}
                 Self.init (field.Get_Left_Column_Coordinates, field); {� �ࠢ�����}
                 Self.GetFilelist;
                 ComInt := 0;          {���뢠��� ����� 0}
             end;

              if comInt = 2 then begin  {�᫨ ���뢠��� ����. ������ ࠢ�� 1}
                 Self.destroy;
                 field.init (1, 3);
                 Self.init (field.Get_Left_Column_Coordinates, field);
                 Self.GetFilelist;
                 i := 1;
                 ComInt := 0;          {���뢠��� ����� 0}
             end;


            DoDisplay (i);   {��㥬 � ᮮ⢥��⢨� � i}
            filelist.SetPosition_and_CurrentX (i2, CurrentX, i);  {��।��塞 ������ ����� � �����騩�}

            Draw_Cursor (CurrentX, i2, i, Cursor_Color);  {��㥬 �����}

            repeat
            ch := readkey;  {���� �������}



            if ch = #0 then begin {�᫨ ��⠭�� ᨬ��� = 0, �}
            ch := readkey;   {���뢠�� ���७�� ���}
                              {�᫨ �� - ��५�� ����}

         if ch in [#80, #72, #77, #75] then begin

           if ch = #80 then     {�᫨ �� ��५�� ���� �}

                Cursor_Down (i, i2, CurrentX)  {ᤢ����� �� ���� ����}

          else if ch = #72 then

             Cursor_Up (i, i2, CurrentX)   {ᤢ����� �� ���� �����}

          else if ch = #77 then

             Cursor_Right (i, i2, CurrentX)  {ᤢ����� ��ࠢ�}

          else if ch = #75 then

               Cursor_Left (i, i2, CurrentX); {ᤢ����� �����}


            Draw_Cursor (CurrentX, i2, i, Cursor_color) {��㥬 �����}
         end
         end
         else

            if ch = #13 then
                 commander (ch, i);  {����᪠�� ��楤��� ��ࠡ�⪨ �������}



             until (ch = #27) or (ComInt <> 0);
             until ch = #27;

       end;


    destructor filelist.destroy;
    begin
        FreeMem (files, Sizeof (onefile) * numfiles)
    end;

   end.
