program shtrixkoder;

uses crt, graph;

type usnum = string[13];
     codeabc = string [6];

type graphobj = object {объект "Поле"}
   public
     procedure init (x, y : word);  {инициализация координат поля}
     procedure drawfield; {рисуеи поле}
     procedure drawline (s : string; x : byte); {рисуем линии}
     procedure drawcounts (usernumber : usnum); {рисуем цифры}
     procedure move (var ch : char);
     procedure destrfield;   {выходим из граф. режим}
   private
        x1, y1, x2, y2 : integer; {координаты поля}
        x1line, y1line, x2line, y2line : integer; {координаты линии}
   end;




var user_number : usnum; {введённый пользователем код}
    firstcode, seccode : codeabc;     {левая, правая части}
    bitcode : string[7]; {расшифрованный двоичный код}
    error : byte;
    ch : char;

var field : graphobj;

procedure graphobj.init (x, y : word);  {инициализация объекта "поле}
 const driver : integer = detect; {переменная графического драйвера}
 var mode : integer; {переменная графического режима}

begin
                {-----координаты прямоугольника-----}
    x1 := x;
    x2 := x1 + 210;  {правая граница + 210 пикселей}
    y1 := y;
    y2 := y1 + 105;
                 {-----координаты линии-----}
    y1line := y1 + 2;
    y2line := y2 - 10;
    x1line := x1 + 10;
    x2line := x1 + 10;

    Initgraph (driver, mode, ' ')  {инициализация граф. режима}
end;

procedure graphobj.drawfield; {рисуем поле}
var xtmp, ytmp : word; {счетчики цикла для зарисовки поля}
begin
        setcolor (white);
        Rectangle (x1,y1,x2,y2);  {рисуем прямоугольник как поле}

       for ytmp := y1 to y2 do   {более быстрая заливка поля, чем floodfill}
       for xtmp := x1 to x2 do
       putpixel (xtmp, ytmp, white)
end;

procedure graphobj.drawline (s : string; x : byte); {рисуем линии}
                           {если x = 1, то рисуем разделительные линии}
var ygr2 : word; {вспомогательня переменная}
        i, i2 : byte;  {счётчикi цикла}
begin
       ygr2 := y2line;
       if x = 1 then       {если x = 1, то увеличим}
         inc (ygr2, 5);    {нижнюю границу линии на 5 пикселей}

       for i := 1 to length (s) do begin {"прогоняем" всю двоичную строку и рисуем}
           if s[i] = '0' then      {если знак = 0, то нарисуем белую линию}
                setcolor (white)
           else                     {иначе черную}
                setcolor (black);

         i2 := 2;
         repeat
         line (x1line, y1line, x2line, ygr2);
         inc (x1line);
         inc (x2line);
         dec (i2)
         until i2 = 0

       end
end;

procedure graphobj.drawcounts(usernumber : usnum);

var i : byte;
begin
setcolor (black);
settextstyle (3, 0, 1);
outtextxy (x1 + 3, y2 - 8, usernumber[1]);
inc (x1, 18);

for i := 2 to 7 do begin
   outtextxy (x1, y2 -8, usernumber[i]);
   inc (x1, 14);
   end;

inc (x1, 8);
for i := 8 to 13 do begin
   outtextxy (x1, y2 -8, usernumber[i]);
   inc (x1, 14);
   end;


end;

procedure graphobj.move (var ch : char);

var imsize : word;
    i : integer;
    b : string;
begin
      ch := readkey;

      if ch in ['a', 's', 'd', 'w'] then begin

        imsize := 4 + imagesize (x1, y1, x2, y2);
       Getimage (x1, y1, x2, y2, imsize);
       setcolor (black);
       rectangle (x1, y1, x2, y2);


       if ch = 'w' then begin
        inc (y1);
        inc (y2)
       end else if ch = 's' then begin
        dec (y1);
        dec (y2)
       end else if ch = 'a' then begin
        dec (x1);
        dec (x2)
       end else if ch = 'd' then begin
        inc (x1);
        inc (x2)
        end;

      putimage (x1, y1, i, CopyPUt);


      end;

end;


procedure graphobj.destrfield; {выходим из графического режима}
begin

       closegraph;
end;




procedure enternum (var user_number : usnum); {вводим код}

 procedure errorcheck (user_number : usnum; var error : byte);
  var i : byte;
  begin

        error := 0;
        for i := 1 to length (user_number) do
            if not (user_number[i] in ['0'..'9']) then begin
            error := 2;
            Writeln ('Not counts');
            exit
            end;
        if length (user_number) <> 13 then begin
        Writeln ('Error entering! You should enter 13 numbers! Re-enter, please.');
        error := 1
                end;
  end;

begin
        clrscr;

        repeat
        Write ('Enter 13-num EAN-13 ');
        readln (user_number);
        if user_number = 'exit' then halt;
        errorcheck (user_number, error);
        until (error = 0);
end;

function firstsixcode (x : char) : codeabc; {находим кодировку 1-х шести цифр (кроме 1)}
begin
      case x of
          '0' : firstsixcode := 'AAAAAA';
          '1' : firstsixcode := 'AABABB';
          '2' : firstsixcode := 'AABBAB';
          '3' : firstsixcode := 'AABBBA';
          '4' : firstsixcode := 'ABAABB';
          '5' : firstsixcode := 'ABBAAB';
          '6' : firstsixcode := 'ABBBAA';
          '7' : firstsixcode := 'ABABAB';
          '8' : firstsixcode := 'ABABBA';
          '9' : firstsixcode := 'ABBABA';
          end
      end;

function decode (x, code : char) : string; {раскодируем число по его коду}
var tempstr : string;

function changebit (s : string) : string; {меняем в строках 1 на 0 и наоборот}
var i : byte;
begin
        for i := 1 to length (s) do
            s[i] := Chr (Abs (ord (s[i]) - 49) + 48);
            changebit := s
end;

function naoborot (s : string) : string;         {меняем строку наоборот}
var x : string[1];
    i : byte;
begin
        for i := 2 to length (s)  do begin

           x := Copy (s, i, 1);
           delete (s, i, 1);
           s := x + s;
        end;
        naoborot := s;
end;

begin
     case x of
        '0' : tempstr := '0001101';
        '1' : tempstr := '0011001';
        '2' : tempstr := '0010011';
        '3' : tempstr := '0111101';
        '4' : tempstr := '0100011';
        '5' : tempstr := '0110001';
        '6' : tempstr := '0101111';
        '7' : tempstr := '0111011';
        '8' : tempstr := '0110111';
        '9' : tempstr := '0001011';
        end;

         if code = 'C' then
                tempstr := changebit (tempstr);
         if code = 'B' then
                tempstr := naoborot (changebit(tempstr));

         decode := tempstr;
end;


procedure paintcode (user_number : usnum; code : codeabc; x : byte);
var  i, i2 : byte;

begin
        i2 := 1;
       for i := x to x + 5 do begin
         field.drawline (decode (user_number[i], code [i2]), 0);
         inc (i2)
         end;
       end;


begin

 enternum (user_number); (*вводим код*)

 firstcode := firstsixcode (user_number[1]);  (* находим код первых 6 цифр *)
 seccode := 'CCCCCC';  (*код вторых шести цифр*)
 field.init (550, 400);
 field.drawfield;
 field.drawline ('101', 1);
 paintcode (user_number, firstcode, 2);
 field.drawline ('01010', 1);
 paintcode (user_number, seccode, 8);
 field.drawline ('101', 1);
 field.drawcounts (user_number);

 repeat
 field.move (ch);
 until ch = 'q';

 field.destrfield;


end.
