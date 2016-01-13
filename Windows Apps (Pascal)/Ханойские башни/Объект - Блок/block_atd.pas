unit block_atd;

interface

uses crt;

      type  block = object

        public
        constructor Init (E_Color, E_Length : byte);  {инициализация}
        procedure Draw (x, y : byte);        {нарисовать блок}
        procedure Move (To_X, SpeeNowLength, SpeeNeedLength, Spee_Color : byte); {переместить блок}

        private
        Color,   {цвет блока}
        Length,  {длина - символов}
        Current_X, {местоположение - Х}
        Current_Y : byte;  {местоположение - Y}

         procedure RestoreBack (x, y : byte); {восстановить фон за блоком}
        procedure Horizontal_To (x : shortint); {переместить блок горизонтально}
        procedure Vertical_To_S (x : shortint; e_color : byte); {переместить блок вертикально по спице}

        end;


implementation

     constructor block.Init (E_Color, E_Length : byte); {инициализация}
     begin
        Color := E_Color;
        Length := E_Length;
        Current_X := 0; {не определен}
        Current_Y := 0  {не определен}
     end;


     procedure block.Draw (x, y : byte);     {нарисовать блок}
     const sym = ' ';
     var temp : byte;
     begin

            temp := Length;  {присваиваем длину темповой переменной}
             textbackground (Color);  {устанавливаем цвет блока}
             Gotoxy (x, y); {переходим куда надо}
            repeat              {повторяем}
                write (sym);    {Рисуем символ блока}
                dec (temp)      {уменьшаем темповую переменную}
            until temp = 0;     {пока темп не равен 0}

            Current_X := x;
            Current_Y := y;

     end;

     procedure block.RestoreBack (x, y : byte);  {восстановить фон за блоком}
        const sym = ' ';
        var i : byte;
     begin
           textbackground (Black);
          Gotoxy (x, y);
           for i := 1 to Length do
                write (sym);
     end;



    procedure block.Vertical_To_S (x : shortint; E_Color : byte);  {переместить блок вертикально по спице}
    type Position = (Up, Down);  {направление - вверх, вниз}

    var center : byte;
        Pos : Position;
        first : boolean;


    begin
           first := false;

           center := Length div 2; {центр равен = длина разделить на 2}

           if x > 0 then         {если х больше нуля}
                Pos := Up      {то блок будет подниматься}
           else if x < 0 then begin      {если х меньше нуля}
                Pos := Down;   {то блок будет опускаться}
                first := true
           end;



           x := Abs (x); {устанавливаем х положительное значение (модуль х)}

          while x <> 0 do begin
                delay (30); {задержка}
                RestoreBack (Current_X, Current_Y);   {восстанавливаем фон}

                if not first then begin
                Gotoxy (Current_X + center, Current_Y);   {рисуем}
                textbackground (e_Color);                      {центральную}
                write (' ');            {точку - спицы}
                  end;

                if Pos = Up then   {если направление - вверх}
                dec (Current_Y)                        {уменьшаем Y на 1}
                else inc (Current_Y);  {иначе увеличиваем Y на 1}

                Self.Draw (Current_X, Current_Y);      {рисуем в новом месте блок}

                dec (x); {уменьшаем х}

                first := false;
            end
    end;

     procedure block.Horizontal_To (x : shortint); {переместить блок горизонтально}
             type Position = (Left, Right); {направление - вправо, влево}
             var Pos : Position;
       begin
        textbackground (Color);

           if x > 0 then         {если х больше нуля}
                Pos := Right      {то блок будет двигаться вправо}
           else if x < 0 then       {если х меньше нуля}
                Pos := Left;   {то блок будет двигаться влево}

           x := Abs (x);

           while x <> 0 do begin
                delay (30); {задержка}
                     RestoreBack (Current_X, Current_Y);

                  if Pos = Left then   {если направление - влево}
                dec (Current_X)                        {уменьшаем Y на 1}
                else inc (Current_X);  {иначе увеличиваем Y на 1}

                 Self.Draw (Current_X, Current_Y);   {рисуем в новом месте блок}

                dec (x)
           end
       end;


     procedure block.Move (To_X, SpeeNowLength, SpeeNeedLength, Spee_Color : byte); {переместить блок}
       var i : byte;
       var Hor_Len : shortint;   {длина, на которую будем двигать горизонтально}

     begin

             Hor_Len := (To_X - Current_X) - Length div 2;   {вычитаем из цели-Х икс нашего блока с учетом длины}


              Vertical_To_S (SpeeNowLength, Spee_Color);
              Horizontal_To (Hor_Len);
              Vertical_To_S (-SpeeNeedLength, Spee_Color);
     end;

     end.































