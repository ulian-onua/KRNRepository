      uses crt;
  var x : byte;
      a, b : string;


function langue (a, b : string) : byte;  {��।���� �⭮襭�� �� ᫮���� ����� ���� ᫮����}

const i : byte = 1;



begin
         a := upcase (a);
         b := upcase (b);

      if not (i in [1..Length(a)]) and not (i in [1..Length (b)]) then
      langue := 3   {�᫨ ������ ��襫 �� �।��� ���� ����� ᫮�, � ᫮�� ࠢ��}
      else

      if (i > length (a)) or (a[i] < b[i]) then
          langue := 1   {�᫨ i ����� ����� ��ப� A, ��� �㪢� ��ப� � ����� �㪢� ��ப� b, � � �� ��䠢��� �����}
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
     Writeln ('������ ��� ᫮��: ');
     readln (a);
     readln (b);

     x := langue (a, b);

     if x = 3 then writeln ('����� ࠢ��')
     else if x = 1 then writeln ('����� "', a, '" ����� �� ᫮����, 祬 ᫮�� "', b, '"')
     else  if x = 2 then writeln ('����� "', b, '" ����� �� ᫮����, 祬 ᫮�� "', a, '"');

      Writeln ('�������? y/n')
     until readkey in ['n', 'N', '�', '�'];

end.
