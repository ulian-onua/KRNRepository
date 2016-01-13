program cuxtstringpr;

const delimeters : set of char = [',','.',':',';','-', '!', '?'];


type Spisok = ^spisoks;
     spisoks = record
     words : string;
     link : spisok;
     end;

     spsrecord = record
     First, Last : spisok;
     end;

     spsarray = array [1..128] of word;

var s : string;
    p : spisok;
    sps : spsrecord;



function changetosps (s : string) : string;  {заменим все разделители пробелами}
var i : byte;
begin
        for i := 1 to length(s) do
         if s[i] in delimeters then
           s[i] := #32;

         changetosps := s
end;

function clearsps (s : string) : string; {удалим лишние пробелы}
var x : byte;
begin
     repeat
     x := pos (#32#32, s);
     if x <> 0 then
       delete (s, x, 1)
     until x = 0;

     if s[1] = #32 then
     delete (s, 1, 1);
     if s[length(s)]  <> #32 then
       s := s + ' ';

      clearsps := s
end;


procedure cutstring (var sps : spsrecord; s : string);
var i, i2, i3, start : byte;
    x : spsarray;
    numwords : byte;


procedure addsps (var sps : spsrecord; s : string);  {добавить в список}
     var p : spisok;
begin
       with sps do begin
     if first = nil then begin
       new (last);
       first := last
     end else begin
        new (last^.link);
        last := last^.link
     end;
        last^.words := s;
        last^.link := nil
     end

end;

begin
       sps.first := nil;
       sps.last := nil;
       numwords := 0;  {кол-во слов - 0}

     s := clearsps (changetosps(s));  {очистим строку от мусора}

               {найдем кол-во пробелов и добавим их расположение
                        в массив}

     i2 := 0; {длина заполненного массива}
     for i := 1 to length (s) do
         if s[i] = #32 then begin
        inc (numwords);
        inc (i2);
        x[i2] := i
       end;

          {добавляем слова в список}
           start := 1;
      for i3 := 1 to i2 do begin
        addsps (sps, copy (s, start, x[i3] - start));
        start := x[i3] + 1
      end;




  end;


begin
    s := 'Hello, Mike! How are you, my dear friend?';
     cutstring (sps, s);

     p := sps.first;
     while p <> nil do begin
      writeln (p^.words);
      p := p^.link
     end;


    readln


end.
