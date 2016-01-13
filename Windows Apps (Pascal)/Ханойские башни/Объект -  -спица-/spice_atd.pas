unit spice_atd;




interface
        uses crt, block_atd;

type P_BlockStack = ^BlockStack;  {㪠��⥫� �� BlockStack}
     BlockStack = record     {������ - ᯨ��}
     T_Block : block;        {��⮨� �� �����}
     Link : P_BlockStack      {� 㪠��⥫� �� ᫥� �����}
     end;

type Coordinates = record           {���न����}
        X1, X2, Y1, Y2 : byte
end;

type Spice = object
     public
        procedure init (E_Color, X, Y1, Y2 : byte);  {���樠������}
        procedure AddBlock (A_Block : block; Success : boolean); {�������� ����}
        procedure PushBLock (var R_Block : block); {�모���� ����}
        procedure Draw; {���ᮢ��� ᯨ��}
        function GetFreeUp : byte;  {����頥� ���� ᢮������� ����}
        function GetX : byte;  {�����頥� � ���⮯�������� ᯨ��}
        function GetLengthToFree : byte; {����頥� ���-�� ��६�饭�� �����, �⮡� "�����"}

     private
        Color,         {梥�}
        BlocksNum,     {�᫮ ������ � �����騩 ������}
        MaxBlocks : byte; {����. ���-�� ������ �� ᯨ�}
        Coords : Coordinates;   {���न���� ᯨ��}
        Top : P_BlockStack; {㪠��⥫� �� ���設� �⥪�}
     end;





implementation

      procedure Spice.init (E_Color, X, Y1, Y2 : byte); {���樠������}
      begin
           Color := E_Color;    {梥�}
                                {���न����}
           Coords.X1 := X;
           Coords.X2 := Coords.X1;
           Coords.Y1 := Y1;
           Coords.Y2 := Y2;

           BlocksNum := 0;     {���-�� ������ = 0}
           MaxBlocks := (Y2 - Y1) - 1; {���ᨬ��쭮� ���-�� ������}

           Top := nil
      end;

      procedure Spice.Draw;         {���ᮢ��� ᯨ��}
      var i : byte;
          X : byte;
      begin
             X := Coords.X1;
              textbackground (Color);

              for i := Coords.Y1 to Coords.Y2 do begin
              Gotoxy (X, i);
              Write (' ')
              end;
      end;

      procedure Spice.AddBlock (A_Block : block; Success : boolean); {�������� ����}
      var Top_Temp : P_BlockStack;
      begin
           if BlocksNum <= MaxBlocks then begin {�᫨ �᫮ ������ ����� ���ᨬ㬠}
                     {������塞 � �⥪}
              Top_Temp := Top;
              New (Top);
              Top^.T_Block := A_Block;
              Top^.Link := Top_Temp;

           Success := True; {�ᯥ�}
           inc (BlocksNum);
           end else
                Success := False;

      end;


       procedure Spice.PushBLock (var R_Block : BLock); {�모���� ����}
         var Top_Temp : P_BlockStack;
       begin
            {  ������� �� �⥪� }
             if top = nil then halt
             else begin

            Top_Temp := Top;
            R_BLock := Top^.T_BLock;
            Top := Top^.Link;
           Dispose (Top_Temp);

            dec (BlocksNum);
            end;
       end;

        function Spice.GetFreeUp : byte;  {����頥� ���� ᢮������� ����}
        begin
              GetFreeUp := Coords.Y2 - BlocksNum {���⠥� �� ������ Y ���-�� ������}

        end;

        function Spice.GetX : byte;  {����頥� �}
        begin
              GetX := Coords.X1
        end;


       function Spice.GetLengthToFree : byte;
       begin
             GetLengthTofree := Self.GetFreeUp - Coords.Y1 + 1;  {����頥� ���-�� ��६�饭�� �����, �⮡� "�����"}

       end;




end.
