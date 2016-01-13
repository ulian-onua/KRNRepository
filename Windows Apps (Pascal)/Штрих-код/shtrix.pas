program shtrixkoder;

uses crt, graph;

type usnum = string[13];
     codeabc = string [6];

type graphobj = object {��ꥪ� "����"}
   public
     procedure init (x, y : word);  {���樠������ ���न��� ����}
     procedure drawfield; {��㥨 ����}
     procedure drawline (s : string; x : byte); {��㥬 �����}
     procedure drawcounts (usernumber : usnum); {��㥬 ����}
     procedure move (var ch : char);
     procedure destrfield;   {��室�� �� ���. ०��}
   private
        x1, y1, x2, y2 : integer; {���न���� ����}
        x1line, y1line, x2line, y2line : integer; {���न���� �����}
   end;




var user_number : usnum; {������ ���짮��⥫�� ���}
    firstcode, seccode : codeabc;     {�����, �ࠢ�� ���}
    bitcode : string[7]; {����஢���� ������ ���}
    error : byte;
    ch : char;

var field : graphobj;

procedure graphobj.init (x, y : word);  {���樠������ ��ꥪ� "����}
 const driver : integer = detect; {��६����� ����᪮�� �ࠩ���}
 var mode : integer; {��६����� ����᪮�� ०���}

begin
                {-----���न���� ��אַ㣮�쭨��-----}
    x1 := x;
    x2 := x1 + 210;  {�ࠢ�� �࠭�� + 210 ���ᥫ��}
    y1 := y;
    y2 := y1 + 105;
                 {-----���न���� �����-----}
    y1line := y1 + 2;
    y2line := y2 - 10;
    x1line := x1 + 10;
    x2line := x1 + 10;

    Initgraph (driver, mode, ' ')  {���樠������ ���. ०���}
end;

procedure graphobj.drawfield; {��㥬 ����}
var xtmp, ytmp : word; {���稪� 横�� ��� ���ᮢ�� ����}
begin
        setcolor (white);
        Rectangle (x1,y1,x2,y2);  {��㥬 ��אַ㣮�쭨� ��� ����}

       for ytmp := y1 to y2 do   {����� ������ ������� ����, 祬 floodfill}
       for xtmp := x1 to x2 do
       putpixel (xtmp, ytmp, white)
end;

procedure graphobj.drawline (s : string; x : byte); {��㥬 �����}
                           {�᫨ x = 1, � ��㥬 ࠧ����⥫�� �����}
var ygr2 : word; {�ᯮ����⥫�� ��६�����}
        i, i2 : byte;  {����稪i 横��}
begin
       ygr2 := y2line;
       if x = 1 then       {�᫨ x = 1, � 㢥��稬}
         inc (ygr2, 5);    {������ �࠭��� ����� �� 5 ���ᥫ��}

       for i := 1 to length (s) do begin {"�ண��塞" ��� ������� ��ப� � ��㥬}
           if s[i] = '0' then      {�᫨ ���� = 0, � ����㥬 ����� �����}
                setcolor (white)
           else                     {���� ����}
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


procedure graphobj.destrfield; {��室�� �� ����᪮�� ०���}
begin

       closegraph;
end;




procedure enternum (var user_number : usnum); {������ ���}

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

function firstsixcode (x : char) : codeabc; {��室�� ����஢�� 1-� ��� ��� (�஬� 1)}
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

function decode (x, code : char) : string; {�᪮���㥬 �᫮ �� ��� ����}
var tempstr : string;

function changebit (s : string) : string; {���塞 � ��ப�� 1 �� 0 � �������}
var i : byte;
begin
        for i := 1 to length (s) do
            s[i] := Chr (Abs (ord (s[i]) - 49) + 48);
            changebit := s
end;

function naoborot (s : string) : string;         {���塞 ��ப� �������}
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

 enternum (user_number); (*������ ���*)

 firstcode := firstsixcode (user_number[1]);  (* ��室�� ��� ����� 6 ��� *)
 seccode := 'CCCCCC';  (*��� ����� ��� ���*)
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
