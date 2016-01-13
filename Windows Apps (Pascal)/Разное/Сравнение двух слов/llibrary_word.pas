      uses crt;
  var x : byte;
      a, b : string;


function langue (a, b : string) : byte;  {определяет отношение по словарю между двумя словами}

const i : byte = 1;



begin
         a := upcase (a);
         b := upcase (b);

      if not (i in [1..Length(a)]) and not (i in [1..Length (b)]) then
      langue := 3   {если индекс вышел за пределы длин обоих слов, то слова равны}
      else

      if (i > length (a)) or (a[i] < b[i]) then
          langue := 1   {если i больше длины строки A, или буква строки а меньше буквы строки b, то а по алфавиту меньше}
      else if (i > length (b)) or ( b [i] < a[i]) then
           langue := 2
      else if b[i] = a[i] then begin
              inc (i);
              langue := langue (a, b);
              dec (i)
      end
end;





begin
       repeat
     Writeln ('Введите два слова: ');
     readln (a);
     readln (b);

     x := langue (a, b);

     if x = 3 then writeln ('Слова равны')
     else if x = 1 then writeln ('Слово "', a, '" меньше по словарю, чем слово "', b, '"')
     else  if x = 2 then writeln ('Слово "', b, '" меньше по словарю, чем слово "', a, '"');

      Writeln ('Повторить? y/n')
     until readkey in ['n', 'N', 'т', 'Т'];

end.
