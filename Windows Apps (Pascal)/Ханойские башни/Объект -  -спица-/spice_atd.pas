unit spice_atd;




interface
        uses crt, block_atd;

type P_BlockStack = ^BlockStack;  {указатель на BlockStack}
     BlockStack = record     {запись - спицы}
     T_Block : block;        {состоит из блока}
     Link : P_BlockStack      {и указателя на след элемент}
     end;

type Coordinates = record           {координаты}
        X1, X2, Y1, Y2 : byte
end;

type Spice = object
     public
        procedure init (E_Color, X, Y1, Y2 : byte);  {инициализация}
        procedure AddBlock (A_Block : block; Success : boolean); {добавить блок}
        procedure PushBLock (var R_Block : block); {выкинуть блок}
        procedure Draw; {нарисовать спицу}
        function GetFreeUp : byte;  {возращает верх свободного места}
        function GetX : byte;  {возвращает Х местоположения спицы}
        function GetLengthToFree : byte; {возращает кол-во перемещений вверх, чтобы "выехать"}

     private
        Color,         {цвет}
        BlocksNum,     {число блоков в настоящий момент}
        MaxBlocks : byte; {макс. кол-во блоков на спице}
        Coords : Coordinates;   {координаты спицы}
        Top : P_BlockStack; {указатель на вершину стека}
     end;





implementation

      procedure Spice.init (E_Color, X, Y1, Y2 : byte); {инициализация}
      begin
           Color := E_Color;    {цвет}
                                {координаты}
           Coords.X1 := X;
           Coords.X2 := Coords.X1;
           Coords.Y1 := Y1;
           Coords.Y2 := Y2;

           BlocksNum := 0;     {кол-во блоков = 0}
           MaxBlocks := (Y2 - Y1) - 1; {максимальное кол-во блоков}

           Top := nil
      end;

      procedure Spice.Draw;         {нарисовать спицу}
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

      procedure Spice.AddBlock (A_Block : block; Success : boolean); {добавить блок}
      var Top_Temp : P_BlockStack;
      begin
           if BlocksNum <= MaxBlocks then begin {если число блоков меньше максимума}
                     {добавляем в стек}
              Top_Temp := Top;
              New (Top);
              Top^.T_Block := A_Block;
              Top^.Link := Top_Temp;

           Success := True; {успех}
           inc (BlocksNum);
           end else
                Success := False;

      end;


       procedure Spice.PushBLock (var R_Block : BLock); {выкинуть блок}
         var Top_Temp : P_BlockStack;
       begin
            {  Вытягиваем из стека }
             if top = nil then halt
             else begin

            Top_Temp := Top;
            R_BLock := Top^.T_BLock;
            Top := Top^.Link;
           Dispose (Top_Temp);

            dec (BlocksNum);
            end;
       end;

        function Spice.GetFreeUp : byte;  {возращает верх свободного места}
        begin
              GetFreeUp := Coords.Y2 - BlocksNum {вычитаем из нижним Y кол-во блоков}

        end;

        function Spice.GetX : byte;  {возращает Х}
        begin
              GetX := Coords.X1
        end;


       function Spice.GetLengthToFree : byte;
       begin
             GetLengthTofree := Self.GetFreeUp - Coords.Y1 + 1;  {возращает кол-во перемещений вверх, чтобы "выехать"}

       end;




end.
