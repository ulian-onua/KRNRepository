program razb_stroka;

const delimeters : set of char = [',','.',':',';','-', '!', '?'];


type Spisok = ^spisoks;
     spisoks = record
     words : string;
     link : spisok;
     end;

type spsarray = array [1..128] of byte;

var s : string; {��ப�, ������ ���� ࠧ����}
    sps, p : spisok;
    numwords : byte;
    x : spsarray;

function changetosps (s : string) : string;  {������� �� ࠧ����⥫� �஡�����}
var i : byte;
begin
        for i := 1 to length(s) do
         if s[i] in delimeters then
           s[i] := #32;

         changetosps := s
end;

function clearsps (s : string) : string; {㤠��� ��譨� �஡���}
var x : byte;
begin
     repeat
     x := pos (#32#32, s);
     if x <> 0 then
       delete (s, x, 1)
     until x = 0;

     if s[1] = #32 then
     delete (s, 1, 1);
     if s[length(s)] = #32 then
      delete (s, length (s), 1);

      clearsps := s
end;


procedure kicktowords (var sps : spisok; s : string; var numwords : byte);
var i, i2, i3, start : byte;



procedure addsps (var sps : spisok; s : string);
     var p : spisok;
begin
      p := sps;
      new (sps);
      sps^.words := s;
      sps^.link := p;
end;

begin
       sps := nil;
       numwords := 0;

     s := clearsps (changetosps(s));

               {������ ���-�� �஡����}
     i2 := 0;
     for i := 1 to length (s) do
         if s[i] = #32 then begin
        inc (numwords);
        inc (i2);
        x[i2] := i;
       end;

      inc (numwords); {���-�� ᫮� = ���-�� �஡���� + 1}
      inc (i2);
      x[i2] := length (s);
         {  writeln (i2); }

      start := 1;
                               {������塞 ᫮��}
      for i3 := 1 to i2 do begin

        addsps (sps, copy (s, start, x[i3] - start));
        x[i3] := start
      end;




  end;


begin
    s := 'I go to magazine';
     kicktowords (sps, s, numwords);

     p := sps;
     while p <> nil do begin
      writeln (p^.words);
      p := p^.link
     end;


    readln


end.