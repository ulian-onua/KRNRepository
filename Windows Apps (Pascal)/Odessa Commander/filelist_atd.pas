unit filelist_atd;

interface

        uses Dos, Crt, Tabul_Atd, onefile_atd, DOSWIN(*, com_proc_atd*);

        type onefilearray = array [1..maxint] of onefile;
             files_pointer = ^onefilearray;


        type filelist = object


           constructor init (Coordinates : Coords; thistabula : tabula);
           procedure getfilelist;  {получить список файлов}
           procedure ClearDisplay; {очистить колонки}
           procedure DoDisplay (i : word); {вывести список файлов}
           procedure filelist_driver (var i : word);     {управляющая подпрограмма}
        {   procedure all_driver;}
           procedure commander (ch : char; i : word);
           destructor destroy;


         private
                first, second : Coords; {координаты первого и второго стобцов}
                numfiles : word;
                files : files_pointer;
                procedure addfileinfo (var i : word; S : SearchRec); {добавить информацию о файле в массив}
                procedure ClearColumn (X : Coords); {очистить колонку}
                procedure  DisplayColumn (X : Coords; var i : word);  {вывести колонку}
                procedure Restore_Native (X, Y : byte; i : word);  {вернуть файлу на экране родной цвет}
                procedure Draw_Cursor (X, Y : byte; i : word; Color : byte);
                converter : doswinconverter;
              {  commander : com_proc;  }
                procedure ChangeI (var i : word); {правильно изменяет i -для процедуры DoDosplay}
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
                numfiles := 0;   {кол-во файлов}
                window (1, 1, 80, 25);
                ComInt := 0;
           end;


           procedure filelist.addfileinfo (var i : word; S : SearchRec);  {добавить информацию о файле в массив}
           begin
                    inc (i);            {увеличиваем счетчик массива}
                    files^[i].GetFromSearch (S);  {копируем информацию из SearchRec в элемент массива}
                    files^[i].SetFileInformation; {устанавливаем информацию файла (см. onefile_atd)}
           end;

           procedure filelist.getfilelist;
           var S : SearchRec;
               i : word;
           begin

                Findfirst ('*.*', Anyfile, S);    {ищем первый файл}

                if DoSError = 0 then            {если не ошибка и }
                if S.Name <> '.' then           {Имя файла - не точка}
                       inc (numfiles);          {увеличиваем кол-во файлов}

                while DosError = 0 do begin       {найдем кол-во файлов}
                      FindNext (s);
                      if DoSError = 0 then
                      inc (numfiles)
                end;


                GetMem (files, Sizeof (onefile) * numfiles); {выделим память}
                 i := 0;      {счетчик массива}

                      Findfirst ('*.*', Anyfile, S);  {первую точку пропускаем}
                        if DoSError = 0 then            {если не ошибка и }
                        if S.Name <> '.' then begin         {Имя файла - не точка}
                            converter.decode_string (S.Name);
                            Self.addfileinfo (i, S);    {добавляем файл}
                          end;
                      while DoSError = 0 do begin
                            FindNext (s);
                        if DoSError = 0 then begin
                            converter.decode_string (S.Name);
                            Self.addfileinfo (i, S);  {добавляем инфу о файле}
                        end
                      end
           end;

             procedure filelist.DisplayColumn (X : Coords; var i : word);
            var i2 : byte;
            begin
                    i2 := X.LeftY;

                   while (i <= numfiles) and (i2 <= X.RightY) do begin
                   Gotoxy (X.LeftX, i2);
                   textcolor (files^[i].GetFileColor); {получаем цвет файла}
                   files^[i].SetCoordinates (X.LeftX, i2);  {устанавливаем координаты}

                   Write (files^[i].Share (files^[i].GetFileName));  {выводим имя}
                   inc (i);
                   inc (i2)
                 end;
            end;



            procedure  filelist.ChangeI (var i : word); {правильно изменяет i -для процедуры DoDosplay}
            begin
                if i <= 36 then  {если i <= 36}
                    i := 1       {то i равно 1 - начинаем с 1}
                else                   {иначе}
                    i := i - (i mod 36) + 1;{отнимаем от i остаток от деления i на 36 и прибавляем 1}
            end;

            procedure filelist.DoDisplay (i : word);


            begin
                  ClearDisplay;         {очищаем экран}
                  ChangeI (i);    {выставляем правильное i}
                  DisplayColumn (First, i);   {отобразить первую колонку}

              if i <= numfiles then             {если элемент массива меньше кол-ва файлов то}
                   DisplayColumn (Second, i);  {отобразить вторую колонку}

           Gotoxy (1, 1);
       end;


          procedure filelist.ClearColumn (X : Coords);  {очистить колонку}
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
                ClearColumn (First);   {очищаем первую колонку}
                ClearColumn (Second);  {очищаем вторую колонку}
          end;


      procedure filelist.Restore_Native (X, Y : byte; i : word);  {вернуть родной цвет после курсора}
       begin
               GotoXy (X, Y);   {переходим куда нам надо}
               textcolor (files^[i].GetFileColoR);  {востанавливаем родной цвет}
               Write (files^[i].Share (files^[i].GetFileName));      {рисуем}
       end;

       procedure filelist.Draw_Cursor (X, Y : byte; i : word; Color : byte);
       begin
             GotoXY (X, Y);  {переходим к нужному месту}
             if Color = 0 then   {если цвет = 0}
             textcolor (files^[i].GetFileColor + Blink) {то будет мерцание}
             else begin                         {иначе}
              textbackground (color);            {вводимый цвет - фоновый}
              textcolor (files^[i].GetFileColor) {а цвет текста - стандартный}
             end;

             Write (files^[i].Share (files^[i].GetFileName));   {написать}
             textbackground (black);          {вернуть черный цвет}
       end;


       procedure filelist.SetPosition_and_CurrentX (var i2, CurrentX : byte;
                                            i : byte);  {определить позицию курсора и настоящий Х}
       begin
             if i > 36 then      {если i > 36}
                 i := i mod 36;  {то уменьшим i - на остаток}

             if i <= 18 then begin    {если i <= 18}
             i2 := first.LeftX + i - 1; {прибавляем Левый верхний угол первого стобца + позицию i - 1}
             CurrentX := first.LeftX  {соответственно настоящий Х равен Левому Х}
             end
             else begin
             i2 := Second.LeftY + i - 18 - 1;
             CurrentX := Second.LeftX
             end
       end;

       procedure filelist.Cursor_Down (var i : word; var i2, CurrentX : byte);
       begin
              if i <> numfiles then begin {если номер массива равен длине массива, то пока ничего не делать}
                         Restore_Native (CurrentX, i2, i); {восстанавливаем стандарт}

                if (i2 = first.RightY) and (CurrentX = first.LeftX) then begin {если это конец столбца, то}
                  i2 := second.LeftY;    {левый Y - игрек правого столбца}
                  CurrentX := Second.LeftX;  {"настоящий" Х - Второй Х}
                  inc (i)              {увеличиваем элемент массива на 1}
               end
               else if i2 = Second.RightY then begin  {иначе, если это конец правого столбца}
                  inc (i);          {увеличиваем элемент массива на 1}
                  DoDisplay (i);    {выводим таблицу, начиная с элемента массива}
                  i2 := first.LeftY;      {даем  новые координаты i2 (Левый верхний игрек)}
                  CurrentX := first.LeftX {настоящий Х - первый.ЛевыйХ}
               end
               else begin      {иначе}
                inc (i);      {увеличиваем элемент массива на 1}
                inc (i2)     {и положение курсора}
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
                   Restore_Native (CurrentX, i2, i); {восстанавливаем стандарт}

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

              if ch = #13 then begin   {если это enter}

              if files^[i].GetFileType = executable then begin  {если файл - исполнительный}
               clrscr;                          {очищаем экран}
               exec (files^[i].GetFileName, '');  {запускаем файл}
               ComInt := 1                        {прерывание = 1}
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




       procedure filelist.filelist_Driver (var i : word);{счетчик массива}

        var   i2 : byte; {счетчик столбца - "движение" }
              ch : char;
              CurrentX : byte;
              field : tabula;

       const Cursor_Color = 5;



       begin


            repeat

             if comInt = 1 then begin  {если прерывание комм. процессора равно 1}
                 Self.destroy;
                 field.init (1, 3);      {заново}
                 field.Draw_Visual_Part; {вырисовываем поле}
                 Self.init (field.Get_Left_Column_Coordinates, field); {и управление}
                 Self.GetFilelist;
                 ComInt := 0;          {прерывание опять 0}
             end;

              if comInt = 2 then begin  {если прерывание комм. процессора равно 1}
                 Self.destroy;
                 field.init (1, 3);
                 Self.init (field.Get_Left_Column_Coordinates, field);
                 Self.GetFilelist;
                 i := 1;
                 ComInt := 0;          {прерывание опять 0}
             end;


            DoDisplay (i);   {рисуем в соответствии с i}
            filelist.SetPosition_and_CurrentX (i2, CurrentX, i);  {определяем позицию курсора и настоящийХ}

            Draw_Cursor (CurrentX, i2, i, Cursor_Color);  {рисуем курсор}

            repeat
            ch := readkey;  {жмем клавишу}



            if ch = #0 then begin {если считанный символ = 0, то}
            ch := readkey;   {считываем расширенный код}
                              {если это - стрелка вниз}

         if ch in [#80, #72, #77, #75] then begin

           if ch = #80 then     {если это стрелка вниз то}

                Cursor_Down (i, i2, CurrentX)  {сдвигаем на одну вниз}

          else if ch = #72 then

             Cursor_Up (i, i2, CurrentX)   {сдвигаем на одну вверх}

          else if ch = #77 then

             Cursor_Right (i, i2, CurrentX)  {сдвигаем вправо}

          else if ch = #75 then

               Cursor_Left (i, i2, CurrentX); {сдвигаем влево}


            Draw_Cursor (CurrentX, i2, i, Cursor_color) {рисуем курсор}
         end
         end
         else

            if ch = #13 then
                 commander (ch, i);  {запускаем процедуру обработки комманд}



             until (ch = #27) or (ComInt <> 0);
             until ch = #27;

       end;


    destructor filelist.destroy;
    begin
        FreeMem (files, Sizeof (onefile) * numfiles)
    end;

   end.
