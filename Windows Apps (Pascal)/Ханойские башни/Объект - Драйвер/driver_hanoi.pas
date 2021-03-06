unit driver_hanoi;

interface

uses block_atd, spice_atd, crt;


type spices = (First, Last, Aux);   {⨯ ᯨ�� - ��ࢠ�, ����筠�, �஬����筠�}
type spices_array = array [spices] of spice; {���ᨢ ᯨ�}

type driver = object
     public
     procedure init; {���樠������}
     procedure EnterNumOfBlocks; {������ ���-�� ������}

     procedure DrawSpices;   {���ᮢ뢠�� ᯨ��}
     procedure AddandDrawBlocks; {�������� � ���ᮢ��� �����}
     procedure DoIt;  {��६����� �����}
     private
     spica : spices_array;  {���ᨢ �� ��� ᯨ�}
     NumOfBlocks : byte;  {���-�� ᯨ�}
     MaxOfBlocks : byte;  {����. ���-�� ������}


     end;


implementation



      procedure driver.init;    {���樠������}

       begin
            spica[First].init (4, 20, 15, 23); {���樠������ ��ࢮ� ᯨ��}
            spica[Aux].init (4, 40, 15, 23); {���樠������ �஬����筮� ᯨ��}
            spica[Last].init (4, 60, 15, 23); {���樠������ ����筮� ᯨ��}

            NumOfBlocks := 0; {���-�� ������ = 0 }
            MaxofBlocks := 7;  {���ᨬ��쭮� ���-�� ������ = 7}
       end;

       procedure driver.EnterNumOfBlocks;  {������ ���-�� ������}
       const head = '���-�� ������: ';
       var tempch : char;
       begin
                                 {��㥬 ���������}
            Gotoxy (55, 1);
            TextColor (Green);
            TextBackGround (red);
            Write (head);
            Gotoxy (58, 2);
            TextBackground (black);
            textcolor (blue);

            Write ('(1 - 7)');

            TextColor (White);

            repeat
                Gotoxy (55 + Length (head), 1);
               tempch := readkey;  {���뢠�� ᨬ���}

                 if tempch = #27    {�᫨ �� esc, � ��室��}
                        then halt
                 else if tempch in ['1'..'7'] then begin  {�᫨ ᨬ��� �� 1 �� 7}
                        Write (tempch);  {��襬 ��� ᨬ���}
                        Numofblocks := ord (tempch) - 48; {��ᢠ����� ���-�� ������}
                  end;

            until  (tempch = #13) and (numofblocks <> 0 ); {���� �� �㤥� ������ ���� � ���-�� ������ �� �㤥� ����� 1}
        end;



       procedure driver.DrawSpices;   {���ᮢ뢠�� ᯨ��}
       var i : spices;
       begin
       clrscr;
             for i := First to Aux do
                spica [i].draw
       end;

       procedure driver.AddandDrawBlocks;  {�������� � ���ᮢ��� �����}


       var BlockSize : byte;  {����� �����}
           BlockTo : ^Block; {㪠��⥫� �� ����}
           BlockX, BlockY : byte; {���न����, ��� �ᮢ��� ����}
           Success : boolean;
           BlockColor : byte;
           Temp : byte;
       begin
              Blockcolor := 1;   {梥� ���� = 1}
              BlockSize := Maxofblocks * 2 + 1; {����� �����}
              Temp := NumOfBlocks;

              repeat

              New (BlockTo, init (Blockcolor, blocksize));  {���� ��ꥪ� ���� �ࠧ� �� � ���樠����樥�}
              BlockX := spica[First].GetX - Blocksize div 2;  {��।����� � ���न���� �����}
              BlockY := spica[First].GetFreeUp;  {��।����� Y ���न���� �����}

              BlockTo^.Draw (BlockX, BlockY);   {���ᮢ��� ����}
              spica[First].AddBlock (BlockTo^, success);  {�������� ���� �� ����� ᯨ��}

              dec (NumOfBlocks);  {㬥��蠥� ���-�� ������}
              dec (Blocksize, 2); {㬥��蠥� �� 2 ����� �����}

              if (BlockColor = 3) or (Blockcolor mod 7 = 0) then    {�᫨ 梥� ����� = 3, � �ய�᪠��}
              inc (blockcolor, 2)
              else inc (blockcolor)

              until NumofBlocks = 0;

              NumOfBlocks := Temp;

       end;

      procedure driver.doit;
        procedure do_recourse (First, Last, Aux : spices; num : byte);
         var x : block;
           Success : boolean;
        begin

             if num = 1 then begin

               spica[first].PushBlock (x);    {����ࠥ� ���� � ��ࢮ� ᯨ��}

             x.Move (spica[Last].GetX, spica[First].GetLengthToFree,
                      spica[Last].GetLengthToFree, 4);    {��४���뢠��}

              spica[Last].Addblock (x, Success);  {����� ���� �� ��᫥���� ᯨ��}

            end else begin
                 do_recourse (First, Aux, Last, num - 1); {४����}

                  spica[first].PushBlock (x);  {����ࠥ� ��᫥���� ���� � ��ࢮ� ᯨ��}
                  x.Move (spica[Last].GetX, spica[First].GetLengthToFree,
                      spica[Last].GetLengthToFree, 4); {��४���뢠��}

                       spica[Last].Addblock (x, Success);{����� ���� �� ��᫥���� ᯨ��}

                 do_recourse (Aux, Last, First, num - 1) {४����}
              end;


        end;

        const a : spices = first;
              b : spices = last;
              c : spices = aux;

       begin
               do_recourse (a, b, c, NumOfBlocks);



       end;

end.
