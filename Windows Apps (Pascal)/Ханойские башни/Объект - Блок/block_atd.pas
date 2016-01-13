unit block_atd;

interface

uses crt;

      type  block = object

        public
        constructor Init (E_Color, E_Length : byte);  {���樠������}
        procedure Draw (x, y : byte);        {���ᮢ��� ����}
        procedure Move (To_X, SpeeNowLength, SpeeNeedLength, Spee_Color : byte); {��६����� ����}

        private
        Color,   {梥� �����}
        Length,  {����� - ᨬ�����}
        Current_X, {���⮯�������� - �}
        Current_Y : byte;  {���⮯�������� - Y}

         procedure RestoreBack (x, y : byte); {����⠭����� 䮭 �� ������}
        procedure Horizontal_To (x : shortint); {��६����� ���� ��ਧ��⠫쭮}
        procedure Vertical_To_S (x : shortint; e_color : byte); {��६����� ���� ���⨪��쭮 �� ᯨ�}

        end;


implementation

     constructor block.Init (E_Color, E_Length : byte); {���樠������}
     begin
        Color := E_Color;
        Length := E_Length;
        Current_X := 0; {�� ��।����}
        Current_Y := 0  {�� ��।����}
     end;


     procedure block.Draw (x, y : byte);     {���ᮢ��� ����}
     const sym = ' ';
     var temp : byte;
     begin

            temp := Length;  {��ᢠ����� ����� ⥬����� ��६�����}
             textbackground (Color);  {��⠭�������� 梥� �����}
             Gotoxy (x, y); {���室�� �㤠 ����}
            repeat              {�����塞}
                write (sym);    {���㥬 ᨬ��� �����}
                dec (temp)      {㬥��蠥� ⥬����� ��६�����}
            until temp = 0;     {���� ⥬� �� ࠢ�� 0}

            Current_X := x;
            Current_Y := y;

     end;

     procedure block.RestoreBack (x, y : byte);  {����⠭����� 䮭 �� ������}
        const sym = ' ';
        var i : byte;
     begin
           textbackground (Black);
          Gotoxy (x, y);
           for i := 1 to Length do
                write (sym);
     end;



    procedure block.Vertical_To_S (x : shortint; E_Color : byte);  {��६����� ���� ���⨪��쭮 �� ᯨ�}
    type Position = (Up, Down);  {���ࠢ����� - �����, ����}

    var center : byte;
        Pos : Position;
        first : boolean;


    begin
           first := false;

           center := Length div 2; {業�� ࠢ�� = ����� ࠧ������ �� 2}

           if x > 0 then         {�᫨ � ����� ���}
                Pos := Up      {� ���� �㤥� �����������}
           else if x < 0 then begin      {�᫨ � ����� ���}
                Pos := Down;   {� ���� �㤥� ���᪠����}
                first := true
           end;



           x := Abs (x); {��⠭�������� � ������⥫쭮� ���祭�� (����� �)}

          while x <> 0 do begin
                delay (30); {����প�}
                RestoreBack (Current_X, Current_Y);   {����⠭�������� 䮭}

                if not first then begin
                Gotoxy (Current_X + center, Current_Y);   {��㥬}
                textbackground (e_Color);                      {業�ࠫ���}
                write (' ');            {��� - ᯨ��}
                  end;

                if Pos = Up then   {�᫨ ���ࠢ����� - �����}
                dec (Current_Y)                        {㬥��蠥� Y �� 1}
                else inc (Current_Y);  {���� 㢥��稢��� Y �� 1}

                Self.Draw (Current_X, Current_Y);      {��㥬 � ����� ���� ����}

                dec (x); {㬥��蠥� �}

                first := false;
            end
    end;

     procedure block.Horizontal_To (x : shortint); {��६����� ���� ��ਧ��⠫쭮}
             type Position = (Left, Right); {���ࠢ����� - ��ࠢ�, �����}
             var Pos : Position;
       begin
        textbackground (Color);

           if x > 0 then         {�᫨ � ����� ���}
                Pos := Right      {� ���� �㤥� ��������� ��ࠢ�}
           else if x < 0 then       {�᫨ � ����� ���}
                Pos := Left;   {� ���� �㤥� ��������� �����}

           x := Abs (x);

           while x <> 0 do begin
                delay (30); {����প�}
                     RestoreBack (Current_X, Current_Y);

                  if Pos = Left then   {�᫨ ���ࠢ����� - �����}
                dec (Current_X)                        {㬥��蠥� Y �� 1}
                else inc (Current_X);  {���� 㢥��稢��� Y �� 1}

                 Self.Draw (Current_X, Current_Y);   {��㥬 � ����� ���� ����}

                dec (x)
           end
       end;


     procedure block.Move (To_X, SpeeNowLength, SpeeNeedLength, Spee_Color : byte); {��६����� ����}
       var i : byte;
       var Hor_Len : shortint;   {�����, �� ������ �㤥� ������� ��ਧ��⠫쭮}

     begin

             Hor_Len := (To_X - Current_X) - Length div 2;   {���⠥� �� 楫�-� ��� ��襣� ����� � ��⮬ �����}


              Vertical_To_S (SpeeNowLength, Spee_Color);
              Horizontal_To (Hor_Len);
              Vertical_To_S (-SpeeNeedLength, Spee_Color);
     end;

     end.































