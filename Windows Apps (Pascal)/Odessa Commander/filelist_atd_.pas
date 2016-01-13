unit filelist_atd;

interface

        uses Dos, Crt, Tabul_Atd, onefile_atd, DOSWIN;

        type onefilearray = array [1..maxint] of onefile;
             files_pointer = ^onefilearray;


        type filelist = object

           public
           constructor init (Coordinates : Coords; thistabula : tabula);
           procedure getfilelist;  {получить список файлов}
           procedure ClearDisplay; {очистить колонки}
           procedure DoDisplay (i : word); {вывести список файлов}
           procedure filelist_driver;    {управляющая подпрограмма}

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
         end;


implementation

          constructor filelist.init (Coordinates : Coords; thistabula : tabula);
           begin
                thistabula.Get_Cursor_Position_Coordinates (Coordinates,
                                                   first, second);
                numfiles := 0;   {кол-во файлов}
                window (1, 1, 80, 25);
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
                   Write (files^[i].GetFileName);  {выводим имя}
                   inc (i);
                   inc (i2)
                 end;
            end;


            procedure filelist.DoDisplay (i : word);


            begin
                  ClearDisplay;         {очищаем экран}
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
               Write (files^[i].GetFileName);      {рисуем}
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

             Write (files^[i].GetFileName);   {написать}
             textbackground (black);          {вернуть черный цвет}
       end;


       procedure filelist.filelist_Driver;
       var i : word;    {счетчик массива}
           i2 : byte; {счетчик столбца - "движение" }
              ch : char;
              CurrentX : byte;

       const Cursor_Color = 5;

       begin

            i := 1;   {счетчик равен единице}
            DoDisplay (i);
           i2 := first.LeftY; {начало курсора -  в начале левого столбца}

            CurrentX := first.LeftX;  {соответственно х в данный момент - левый}


            Draw_Cursor (CurrentX, i2, i, Cursor_Color);

            repeat
            ch := readkey;  {жмем клавишу}
            if ch = #0 then  {если считанный символ = 0, то}
            ch := readkey;   {считываем расширенный код}
                              {если это - стрелка вниз}

           if ch = #80 then begin     {если это стрелка вниз то}




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
                inc (i2);     {и положение курсора}
                end;

             Draw_Cursor (CurrentX, i2, i, Cursor_color);
          end
          end

          else if ch = #72 then begin


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
