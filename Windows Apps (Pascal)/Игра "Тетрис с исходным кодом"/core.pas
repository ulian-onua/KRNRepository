unit core;

interface
uses crt, dos;

const Figure_points = 4; {���-�� ����⮢ � ��� 䨣��}



type way_type = (Rigth, Left, Down, Up); {���ࠢ����� �������� 䨣���}
     double_position_type = (normal, rotated); {��������� �������� 䨣��(⨯� "��ଠ�쭮�}
     round_type = (ByClock, Against); {��� �����稢��� - �� �ᮢ��, ��� ��⨢ �ᮢ�� ��५��}

type Coordinates_type = record
     X1, X2, Y1, Y2 : integer;
end;


type Timer_Obj = object  {��ꥪ�, � ������� ���ண� �����⢫���� ����প� �������� �㡨���}
private
        Delay_time : longint; {����প� �६���}
        Start_time : longint;  {���⮢�� �६�}
        function Get_Convert_Time : longint; {������� �६� � ��४������஢����� �ଠ�}
public
        constructor Init(e_Delay : longint); {���樠������}
        procedure Start; {����� �����}
        function IsItTime : boolean; {�஢���� ᥪ㭤����}
end;

type field_Obj = object  {��ꥪ� - "����"}
private
        x1, y1, x2, y2 : integer;  {���न���� ����}
        Color, Background : byte; {梥�, 䮭}
public
        constructor Init (const e_x1, e_y1, e_x2, e_y2 : integer); {���樠������}
        procedure Draw; {���ᮢ��� ����}
        procedure Delete; {㤠���� ����}
        function GetX1 : integer;  {������ �1}
        function GetX2 : integer;  {������ �2}
        function GetY1 : integer;  {������ y1}
        function GetY2 : integer;  {������ y2}
        function GetCoordinates : Coordinates_type; {������� �ࠧ� 4 ���न���� � �����}
end;

type fig_el_Obj = object {��ꥪ� - "������� 䨣���"}
private
        X, Y : integer; {���न���� �����}
        Color : byte; {梥� �����}
public
        constructor Init (const e_X, e_Y : integer; const e_Color : byte); {���樠������}
        procedure Draw; {���ᮢ��� �����}
        procedure Delete; {㤠���� �����}
        function GetX : integer; {������ �}
        function GetY : integer; {������ y}
        procedure SetX (const e_X : integer); {��⠭����� �}
        procedure SetY (const e_Y : integer); {��⠭����� Y}
end;



type Els_Sps_Pointer = ^Els_Sps;      {㪠��⥫� �� ������ Els_Sps}
     Els_Sps = record              {�易��� ᯨ᮪ ����⮢ 䨣��}
     Fig_el : Fig_el_Obj;
     Link : Els_Sps_Pointer;
end;


type Figure_Array = array[1..Figure_points] of fig_el_Obj; {���ᨢ ����⮢ 䨣��}

function InY (const e_Y : integer; const fig_array : figure_array) : boolean; {�����頥� True, �᫨ ���� 䨣��� ��室���� �� 㪠������ y-��אַ�}
function InX (const e_X : integer; const fig_array : figure_array) : boolean; {�����頥� True, �᫨ ���� 䨣��� ��室���� �� 㪠������ x-��אַ�}
function InXY (const e_X, e_Y : integer; const fig_array : figure_array) : boolean;    {�����頥� true, �᫨ ���� 䨣��� ��室���� � 㪠������ ���न����}



type Figure_Obj = object {��ꥪ� - ����� (����ࠪ⭮)}
private
color : byte;
Full : Boolean;
public
        constructor Init (E_color : byte);  {���樠������ ������ - ���⮩}
        procedure Draw;  {���ᮢ��� 䨣��� - ���⮩}
        procedure Delete;  {㤠���� 䨣��� - ���⮩}
        destructor Done;
        function GetFull : boolean;
end;

type Quadro_Obj = object(Figure_Obj)  {��ꥪ� - ������(䨣��)}
private
        Fig_els : Figure_array; {���ᨢ ����⮢ 䨣���}
        procedure DrawOnChange (const change_array : figure_array); {��楤��, ����� ���ᯥ稢��� ���ᮢ�� ��ꥪ� �� ������ ��� ��������. ������᪨� ������. change_array - ���� ���न���� ����⮢ 䨣���}

public
        constructor Init (const Start_X, Start_Y : integer; const e_Color : byte);  {���樠������, ��� Start_X, Start_Y - ���न���� ���孥�� ������ �����}
        procedure Draw;   {���ᮢ��� ������}
        procedure Delete; {㤠���� ������}
        procedure Move (const e_way : way_type); {������� ������}
        function InY (const e_Y : integer) : boolean; {�����頥� True, �᫨ ���� 䨣��� ��室���� �� 㪠������ y-��אַ�}
        function InX (const e_X : integer) : boolean; {�����頥� True, �᫨ ���� 䨣��� ��室���� �� 㪠������ x-��אַ�}
        function InXY (const e_X, e_Y : integer) : boolean; {�����頥� True, �᫨ ���� 䨣��� ��室���� � 㪠������ ���न����}
        function GetFigArray : Figure_Array; {������� ���ᨢ � ����⠬� 䨣���}
        procedure MoveInField (const e_way : way_type; const Coords : Coordinates_type;Box : Els_Sps_Pointer); {������� 䨣��� � ���� - ��楤�� ᯥ樠�쭮 ��� ����}
        procedure Round (const roundv : round_type); virtual;
        procedure RoundT (const roundv : round_type; const Coords : Coordinates_type; Box : Els_Sps_Pointer); virtual;

end;



type Tank_Obj = object(Quadro_Obj) {��ꥪ� - ���� (��᫥���� ������)}
public
    constructor Init (const Start_X, Start_Y : integer; const e_Color : byte);
    procedure Round (const roundv : round_type); virtual;
    procedure RoundT (const roundv : round_type; const Coords : Coordinates_type; Box : Els_Sps_Pointer); virtual;
private
    procedure RoundAlg (const roundv : round_type; const temp_array : figure_array; var tempX, tempY : integer; const count : integer);
    function CheckField (const Coords : Coordinates_type; const temp_array : Figure_array) : boolean;  {�㭪�� �஢���� �� ��室���� �� ���ᨢ ����⮢ �� ����� � ����}
end;

type G_Normal = object (Tank_Obj) {��ꥪ� - 䨣�� "�㪢� �" (��᫥���� ⠭��)}
constructor Init (const Start_X, Start_Y : integer; const e_Color : byte);
end;

type G_Invalid = object (Tank_Obj) {��ꥪ� - 䨣�� "���ࠢ��쭠� �㪢� �" (��᫥���� ⠭��)}
constructor Init (const Start_X, Start_Y : integer; const e_Color : byte);
end;

type Z_Normal = object (Tank_Obj) {��ꥪ� - 䨣�� "�ࠢ��쭠� �㪢� Z" (��᫥���� ⠭��)}
private
position : double_position_type;
procedure RoundAlg (var temp_array : figure_array); virtual; {������ ������}
procedure RoundToRotated(var temp_array : figure_array); virtual;  {�������� �� �ᮢ��}
procedure RoundToNormal (var temp_array : figure_array); virtual;  {�������� ��⨢ �ᮢ��}
public
constructor Init (const Start_X, Start_Y : integer; const e_Color : byte);
procedure Round (const roundv : round_type); virtual;
procedure RoundT (const roundv : round_type; const Coords : Coordinates_type; Box : Els_Sps_Pointer); virtual;

end;

type Z_Invalid = object (Z_Normal)  {��ꥪ� - 䨣�� "���ࠢ��쭠� �㪢� Z" (��᫥���� 䨣��� "��ଠ�쭠� �㪢� Z")}
private
procedure RoundToRotated(var temp_array : figure_array); virtual;  {�������� �� �ᮢ��}
procedure RoundToNormal (var temp_array : figure_array); virtual;  {�������� ��⨢ �ᮢ��}
public
constructor Init (const Start_X, Start_Y : integer; const e_Color : byte);

end;

type Stick = object (Z_Normal) // ��ꥪ� - 䨣�� "�����" (��᫥���� 䨣��� "��ଠ�쭠� �㪢� Z")
private
procedure RoundToRotated(var temp_array : figure_array); virtual;  {�������� �� �ᮢ��}
procedure RoundToNormal (var temp_array : figure_array); virtual;  {�������� ��⨢ �ᮢ��}
public
constructor Init (const Start_X, Start_Y : integer; const e_Color : byte);
end;

type pQuadro = ^Quadro_Obj;    {㪠��⥫� �� ��ꥪ� "����� ������"}
     pTank   = ^Tank_Obj;      {㪠��⥫� �� ��ꥪ� "����� ����"}
     pG_Normal = ^G_Normal;    {㪠��⥫� �� ��ꥪ� "����� ��ଠ�쭠� �㪢� �"}
     pG_Invalid = ^G_Invalid;  {㪠��⥫� �� ��ꥪ� "����� ���ࠢ��쭠� �㪢� �"}
     pZ_Normal = ^Z_Normal;     {㪠��⥫� �� ��ꥪ� "����� ��ଠ�쭠� �㪢� Z"}
     pZ_Invalid = ^Z_Invalid;   {㪠��⥫� �� ��ꥪ� "����� ���ࠢ��쭠� �㪢� Z"}
     pStick = ^Stick;          {㪠��⥫� �� ��ꥪ� "�����"}

type floor_obj = object    {��ꥪ� - ���}
private
        Box : Els_Sps_Pointer; {��஡�� � �㡨����:)))) (�易��� ᯨ᮪ � ����⠬� 䨣���}
        Bottom, {y-���न��� ���� ����}
        Top,  {y-���न��� ���� ����}
        Width,  {�ਭ� ���� }
        Height : word;  {���� ����}
        function GetLastEl : Els_Sps_Pointer; {�����頥� 㪠��⥫� �� ��᫥���� ����� ᯨ᪠ ��� nil, �᫨ ᯨ᮪ ����}
        function SearchEl (const e_x, e_y : integer) : Els_Sps_Pointer; {��� ����� � ᯨ᪥}
        function FindPrev (Sps_El : Els_Sps_Pointer) : Els_Sps_Pointer; {��� �।��騩 ����� ��� 㪠�������}
        procedure DeleteByPointer (ptr : Els_Sps_Pointer; var Success : boolean);
public
        constructor Init(Field_Coords : Coordinates_type); {���樠����஢��� ���, ��� Field_Coords - ���न���� ����}
        procedure Add (const el : fig_el_obj);  {�������� ����� � �����}
        procedure AddStart (const el : fig_el_obj);  {�������� ����� ���砫�}
        procedure Delete (const e_x, e_y : integer; var Success : boolean); {㤠���� ����� � ������묨 ���न��⠬�}
        procedure DrawBox; {���ᮢ��� �� ������ ᯨ᪠}
        procedure DeleteBox; {㤠���� �� ������ ᯨ᪠}
        procedure GetElsFromFigure(const Fig_Arr : Figure_Array); {������� ������ �� ���ᨢ� ����⮢ (�� 䨣���)}
        procedure CheckFullEls(var Full : Boolean; var NumOfString : byte); {�஢����, ��� �� ����� � ��ப� �����������}
        procedure DelBoxString (const NumOfString : byte);  {㤠���� ��ப� �� ��஡��}
        procedure RedrawBox(const NumOfString : byte); {����ᮢ��� � ��६����� ������ ᯨ᪠ ��᫥ 㤠����� ��ப� }
        function GetHighestPoint : integer;  {������ y-���न���� ᠬ��� ��୥�� ����� ᯨ᪠}
        function GetBoxPointer : Els_Sps_Pointer;  {�����頥� 㪠��⥫� �� ��砫� ᯨ᪠}
end;

function FigureInFloor (const fig_ar : figure_array; Floor : Els_Sps_Pointer) : boolean;  {�஢����, �� ��室���� �� "䨣�� � ����", �����頥� True, �᫨ 䨣�� � ����}
function FigureOnFloor (const fig_ar : figure_array; Floor : Els_Sps_Pointer) : boolean;



type Points_Obj = object (Field_Obj) {��ꥪ�, ����� ��⠥� �窨 - ��᫥���� ��ꥪ� ����}
private
       Points : longint;    {�窨}
       Color_Pts, Background_Pts : byte; {梥� � 䮭 �窮�}
public
        constructor Init(const Coords : Coordinates_type; const xOffset : integer); {��� ��ꥪ� �㤥� ������� �� ��ꥪ� ���� � �㤥� ��室����� ᫥�� ��� �ࠢ� �� ���� � ��।������ ᤢ����}
        procedure Draw;
        procedure Delete;
        procedure DrawPoints;
        procedure AddPoints (num : longint);
end;

type Info_Obj = Object (Field_Obj) {��ꥪ�, ����� �뢮��� �ᯮ����⥫��� ���ଠ��}
private
procedure WriteType (const x, y : integer; textof : string; e_color, e_background : byte);
procedure WriteHeadEl (const x, y : integer; textof : string);
procedure WriteNormalEl (const x, y : integer; textof : string);
procedure WriteMainEL (const x, y : integer; textof : string);
color_head, back_head, color_normal, back_normal : byte; {梥� 䮭� � ⥪��}
public
constructor Init(const Coords : Coordinates_type; const xOffset : integer); {��� ��ꥪ� �㤥� ������� �� ��ꥪ� ���� � �㤥� ��室����� ᫥�� ��� �ࠢ� �� ���� � ��।������ ᤢ����}
procedure Draw;
procedure Delete;
end;


type Pause_Obj = object   {��ꥪ� - ��㧠}
procedure Proc(const key : char);
procedure Draw;
procedure Delete;
end;


type Header_Obj = object {��ꥪ� ���������}
private
textofhead : array[1..3] of string;
public
constructor Init;
procedure Draw;
procedure Delete;
end;

function Center (const x1, x2 : integer) : integer;  {������ 業�� ����� ���� �窠��}
procedure WriteSpaces (const x, y : integer; probels : integer); {�뢮��� ��।������� ���-�� �஡���� � 㪠������ �窥)}
procedure WriteSymbols (const x, y : integer; num : integer; const sym : char); {�뢮��� ��।������� ���-�� ᨬ����� � 㪠������ �窥)}
function GetSizeOfNum (const num : longint) : byte; {�㭪�� �����頥� ���-�� ��� � ���஡��� �᫥}
procedure textback (const color, background : byte); {��⠭�������� �ࠧ� 梥� ⥪�� � 䮭�}
procedure DeleteWindow (const Coords : Coordinates_type; const background : byte); {㤠��� ���� � 㪠����묨 ���न��⠬� ��� �ᯮ�짮����� �㭪樨 window);}



type Driver_Obj = object{�ࠢ���騩 ��ꥪ�}
public
procedure Init;
///procedure Game;
//procedure Done;
private
Timer : Timer_Obj; // ��ꥪ� ������
Field : Field_Obj; {����}
Floor : Floor_Obj;  {���}
Figure : pQuadro; {䨣��}
Points_Win : Points_Obj; {����, ���஥ �����뢠�� �窨}
Info : Info_Obj; {���� ���ଠ樨}
Pause : Pause_Obj; {��ꥪ�, ����� �⢥砥� �� ����}
Head : Header_Obj;
Game_Over : Boolean;
public
procedure GenerateFigures; {������� 䨣��}
procedure MovingFigures; {�������� 䨣��}
procedure DoingOnkey (const key : char); {ॠ��� �� ����⨥ ������}
procedure AddAndCheckFloor; {�������� � ���� � �஢���� ���  }
procedure GameOver (game_again : boolean);
end;


implementation


       function InY (const e_Y : integer; const fig_array : figure_array) : boolean; {�����頥� True, �᫨ ���� 䨣��� ��室���� �� 㪠������ y -��郞�}
       var count : integer;
           temp : boolean; //�६����� ��-��६����� ��� ��ᢠ������ �� १����� �㭪樨
       begin
            temp := false;
            for count := 1 to figure_points do
                if (Fig_array[count].GetY = e_Y) then
                begin
                        temp := true;
                        break;
                end;

            InY := temp;
       end;

       function InX (const e_X : integer; const fig_array : figure_array) : boolean; {�����頥� True, �᫨ ���� 䨣��� ��室���� �� 㪠������ y -��郞�}
       var count : integer;
           temp : boolean; //�६����� ��-��६����� ��� ��ᢠ������ �� १����� �㭪樨
       begin
            temp := false;
            for count := 1 to figure_points do
                if (Fig_array[count].GetX = e_X) then
                begin
                        temp := true;
                        break;
                end;

            InX := temp;
       end;

       function InXY (const e_X, e_Y : integer; const fig_array : figure_array) : boolean;
       var count : integer;
           temp : boolean; //�६����� ��-��६����� ��� ��ᢠ������ �� १����� �㭪樨
       begin
            temp := false;
            for count := 1 to figure_points do
                if (Fig_array[count].GetX = e_X) and (Fig_array[count].GetY = e_Y) then
                begin
                        temp := true;
                        break;
                end;

            InXY := temp;
       end;



function FigureInFloor (const fig_ar : figure_array; Floor : Els_Sps_Pointer) : boolean;  {�஢����, �� ��室���� �� "䨣�� � ����", �����頥� True, �᫨ 䨣�� � ����}
var count : integer;
    TempBool : boolean;
begin
      TempBool := false;

      while (Floor <> nil) do
      begin
          if InXY (Floor^.Fig_El.GetX, Floor^.Fig_El.GetY, Fig_ar) then
          begin
                TempBool := true;
                break;
          end;
          Floor := Floor^.Link;
      end;

      FigureInFloor := TempBool;
end;

function FigureOnFloor (const fig_ar : figure_array; Floor : Els_Sps_Pointer) : boolean;  {�஢����, �� ��室���� �� "䨣�� � ����", �����頥� True, �᫨ 䨣�� � ����}
var count : integer;
    TempBool : boolean;
begin
      TempBool := false;

      while (Floor <> nil) do
      begin
          if InXY (Floor^.Fig_El.GetX, Floor^.Fig_El.GetY-1, Fig_ar) then
          begin
                TempBool := true;
                break;
          end;
          Floor := Floor^.Link;
      end;

      FigureOnFloor := TempBool;
end;


function ToUp (const x1, x2 : integer) : integer;  {������ 業�� ����� ���� �窠��}
begin
        ToUp := (x2 - x1) div 2;
end;

function Center (const x1, x2 : integer) : integer;  {������ 業�� ����� ���� �窠��}
begin
        Center := (x2 + x1) div 2;
end;



procedure WriteSymbols (const x, y : integer; num : integer; const sym : char); {�뢮��� ��।������� ���-�� ᨬ�����}
begin
        gotoxy (x, y);
        while (num > 0) do
        begin
                Write (sym);
                dec(num);
        end;
end;

procedure WriteSpaces (const x, y : integer; probels : integer);  {�뢮��� ��।������� ���-�� �஡����}
const SPACE = ' ';
begin
       WriteSymbols (x, y, probels, SPACE);
end;

function GetSizeOfNum (const num : longint) : byte; {�㭪�� �����頥� ���-�� ��� � ���஡��� �᫥}
var counter,{�᫮ �� ���஥ �㤥� ������}
    results : longint; {��⭮�}
    SizeNum : byte;
begin
      counter := 1;
      SizeNum := 1;
      results := num div counter;

      while results >= 10 do
      begin
            counter := counter * 10;
            results := num div counter;
            inc (SizeNum);
      end;

      GetSizeOfNum := SizeNum;
end;

procedure textback (const color, background : byte);  {��⠭�������� �ࠧ� 梥� ⥪�� � 䮭�}
begin
        textcolor (color);
        textbackground (background);
end;

procedure DeleteWindow (const Coords : Coordinates_type; const background : byte); {㤠��� ���� � 㪠����묨 ���न��⠬� ��� �ᯮ�짮����� �㭪樨 window)}
var curY, curX : integer;
begin
     textbackground (background);

     for curY := Coords.Y1 to Coords.Y2 do
        for curX := Coords.X1 to Coords.X2 do
        begin
                gotoxy (curX, curY);
                Write (' ');
        end;
        gotoxy (80, 25);
end;


procedure Pause_Obj.Proc (const key : char);
var temp : char;
begin
        temp := #0;
        Pause_Obj.Draw;
      repeat
      if keypressed then
      temp := readkey;

      until UpCASE (temp) = UPcase(key);
      Pause_Obj.Delete;
end;

procedure Pause_Obj.Draw;
begin
        textback (White, Black);
        gotoxy (40, 25);
        Write ('��㧠');
        gotoxy (80, 25);
end;

procedure Pause_Obj.Delete;
begin
        textback (black, black);
        WriteSpaces (40, 25, 5);
        gotoxy (80, 25);
end;


 constructor field_Obj.Init (const e_x1, e_y1, e_x2, e_y2 : Integer); {���樠������ ��ꥪ� "����"}
        begin
                if (e_x2 > e_x1) and (e_y2 > e_y1) then
                begin
                        x1 := e_x1;
                        x2 := e_x2;
                        y1 := e_y1;
                        y2 := e_y2;
                end;
                color := 7;
                background := black;
        end;

        procedure field_Obj.Draw; {���ᮢ��� ��ꥪ� "����"}
        var count1, count2 : word; {����稪� 横���}
        begin
                textback (color, background);
                gotoxy (x1, y1);
                Write (#218);
                gotoxy (x2, y1);
                Write (#191);
                gotoxy (x1, y2);
                Write (#192);
                gotoxy (x2, y2);
                Write (#217);

                for count1 := x1 + 1 to x2 - 1 do
                begin
                        gotoxy (count1, y1);
                        write (#196);
                        gotoxy (count1, y2);
                        write (#196);
                end;

                for count2 := y1 + 1 to y2 - 1 do
                begin
                        gotoxy (x1, count2);
                        write (#179);
                        gotoxy (x2, count2);
                        write (#179)
                end;
                gotoxy (80,25);
        end;

        procedure field_Obj.Delete; {㤠���� ��ꥪ� "����"}
        var count1, count2 : word;
        begin
                textback (black, black);
                for count1 := x1 to x2 do
                begin
                        gotoxy (count1, y1);
                        write (' ');
                        gotoxy (count1, y2);
                        write (' ');
                end;


                for count2 := y1 to y2 do
                begin
                        gotoxy (x1, count2);
                        write (' ');
                        gotoxy (x2, count2);
                        write (' ')
                end
        end;

        function field_Obj.GetX1 : integer; {������ �1-���न���� ����}
        begin
              GetX1 := x1;
        end;

        function field_Obj.GetX2 : integer; {������ �2-���न���� ����}
        begin
              GetX2 := x2;
        end;

        function field_Obj.GetY1 : integer; {������ y1-���न���� ����}
        begin
              GetY1 := y1;
        end;

        function field_Obj.GetY2 : integer; {������ y2-���न���� ����}
        begin
              GetY2 := y2;
        end;

        function field_Obj.GetCoordinates : Coordinates_type;
        var temp : Coordinates_type;
        begin
                temp.x1 := x1;
                temp.x2 := x2;
                temp.y1 := y1;
                temp.y2 := y2;
                GetCoordinates := temp;
        end;


        constructor fig_el_Obj.Init (const e_X, e_Y : integer; const e_Color : byte); {���樠������ ����� 䨣���}
        begin
                X := e_X;
                Y := e_Y;
                Color := e_Color;
        end;

        procedure fig_el_Obj.Draw;  {���ᮢ��� ����� 䨣���}
        begin
                gotoxy (x, y);
                textbackground (color);
                Write (' ');
                gotoxy (80, 25);
        end;

        procedure fig_el_Obj.Delete; {㤠���� ����� 䨣���}
        begin
                gotoxy (x, y);
                textbackground (black);
                Write (' ');
                gotoxy (80, 25);
        end;

        function fig_el_Obj.GetX : integer; {������ X-���न���� ����� 䨣���}
        begin
                GetX := x
        end;

        function fig_el_Obj.GetY : integer; {������ Y-���न���� ����� 䨣���}
        begin
                GetY := y
        end;

        procedure fig_el_Obj.SetX (const e_X : integer); {��⠭����� �-���न���� ����� 䨣���}
        begin
                x := e_X
        end;

        procedure fig_el_Obj.SetY (const e_Y : integer); {������ Y-���न����� ����� 䨣���}
        begin
                y := e_Y
        end;


        constructor Figure_Obj.Init (E_color : byte); {���樠������ - ���⮩}
        begin
             Color := E_Color;
             Full := False;
        end;

        procedure Figure_Obj.Draw;   {���ᮢ��� 䨣��� - ���⮩}
        begin
        end;

        procedure Figure_Obj.Delete; {㤠���� 䨣��� - ���⮩}
        begin
        end;

        function Figure_Obj.GetFull : boolean;
        begin
                GetFull := full;
        end;

        destructor Figure_Obj.Done;
        begin
        end;


        constructor Quadro_Obj.Init (const Start_X, Start_Y : integer; const e_Color : byte);  {���樠������, ��� Start_X, Start_Y - ���न���� ���孥�� ������ �����}
        begin
              Figure_Obj.Init (E_color);
              Fig_els[1].Init(Start_X, Start_Y, Color);
              Fig_els[2].Init(Start_X + 1, Start_Y, Color);
              Fig_els[3].Init (Start_X, Start_Y + 1, Color);
              Fig_els[4].Init (Start_X + 1, Start_Y + 1, Color);
        end;


      procedure Quadro_Obj.Draw;  {���ᮢ��� ������}
      var count : integer;
      begin
           for count := 1 to Figure_points do
                Fig_els[count].Draw;
      end;


      procedure Quadro_Obj.Delete; {㤠���� ������}
      var count : integer;
      begin
           for count := 1 to Figure_points do
                Fig_els[count].Delete;
      end;

      procedure Quadro_Obj.DrawOnChange (const change_array : figure_array); {���ᮢ�� 䨣��� �� ������ ��� ��६�饭��}
      var count1, count2 : integer;
          TheSame : boolean;
      begin
                      {㤠��� � ��ன 䨣��� ������, ����� �� ���������� � �����}
           for count1 := 1 to Figure_points do
           begin
                TheSame := false;
                for count2 := 1 to Figure_points do
                        if (Fig_els[count1].GetX = Change_array[count2].GetX) and
                            (Fig_els[count1].GetY = Change_array[count2].GetY)  then
                        begin
                             TheSame := true;
                             break;
                        end;
                if not TheSame then
                        Fig_els[count1].Delete;
           end;
                   {����㥬 ������ ����� 䨣���, ����� �� ���������� � ��ன}

             for count1 := 1 to Figure_points do
           begin
                TheSame := false;
                for count2 := 1 to Figure_points do
                        if (Change_array[count1].GetX = Fig_els[count2].GetX) and
                            (Change_array[count1].GetY = Fig_els[count2].GetY)  then
                        begin
                             TheSame := true;
                             break;
                        end;
                if not TheSame then
                        change_array[count1].Draw;
           end;
      end;

       function Quadro_Obj.InY (const e_Y : integer) : boolean;
       begin
                InY := Core.InY(e_Y, Fig_els);
       end;

       function Quadro_Obj.InX (const e_X : integer) : boolean;
       begin
                InX := Core.InX(e_X, Fig_els);
       end;

       function Quadro_Obj.InXY (const e_X, e_Y : integer) : boolean;
       begin
               InXY := Core.InXY(e_X, e_Y, Fig_els);
       end;

      procedure Quadro_Obj.Move(const e_way : way_type);   {������� ������}
      var count : integer;
          temp_array : figure_array;
      begin

           temp_array := Fig_els;

            if e_way = Left then     {������� �����}
                for count := 1 to Figure_points do
                    temp_array[count].SetX(Fig_els[count].GetX-1)
            else
                if e_way = Rigth then     {������� ��ࠢ�}
                     for count := 1 to Figure_points do
                        temp_array[count].SetX(Fig_els[count].GetX+1)
                else
                    if e_way = Down then  {������� ����}
                        for count := 1 to Figure_points do
                        temp_array[count].SetY(Fig_els[count].GetY+1);

           Self.DrawOnChange (temp_array); {��뢠�� ��楤���-������ ��䥪⨢��� ���ᮢ��}
           Fig_els := temp_array;   {��ᢠ����� �६���� ���ᨢ ���ᨢ� ����⮢ ��ꥪ�}
       end;

        procedure Quadro_Obj.MoveInField (const e_way : way_type; const Coords : Coordinates_type; Box : Els_Sps_Pointer);
        var count : integer;
        temp_array : figure_array;
        FigOnFloor : boolean;
        begin
               temp_array := Fig_els;

               if e_way = Left then {������� �����}
               begin
                 if not Self.InX (Coords.X1+1) then
                   for count := 1 to Figure_points do
                      temp_array[count].SetX(Fig_els[count].GetX-1)
               end
                        else if e_way = Rigth then {������� ��ࠢ�}
                        begin
                              if not Self.InX (Coords.X2-1) then
                                  for count := 1 to Figure_points do
                                     temp_array[count].SetX(Fig_els[count].GetX+1)
                        end
                                else if e_way = Down then {������� ����}
                                begin
                                 if not Self.InY (Coords.Y2-1) then
                                    for count := 1 to Figure_points do
                                        temp_array[count].SetY(Fig_els[count].GetY+1);
                                end;
               FigOnFloor := FigureInFloor(temp_array, box);
               if not FigOnFloor then
               begin
               Self.DrawOnChange (temp_array); {��뢠�� ��楤���-������ ��䥪⨢��� ���ᮢ��}
               Fig_els := temp_array;   {��ᢠ����� �६���� ���ᨢ ���ᨢ� ����⮢ ��ꥪ�}
               end;

               if (e_way = Down) and (FigOnFloor or Self.InY (Coords.Y2-1))  then
                Self.Full := true;
        end;




       function Quadro_Obj.GetFigArray : Figure_Array;  {������� ���ᨢ � ����⠬� 䨣���}
       begin
                GetFigArray := Fig_Els;
       end;

       procedure Quadro_Obj.Round (const roundv : round_type);
       begin  end;
       procedure Quadro_Obj.RoundT (const roundv : round_type; const Coords : Coordinates_type; Box : Els_Sps_Pointer);
        begin end;
   {    procedure Quadro_Obj.RoundByClockT (Coords : Coordinates_type);
       begin end;   }
      {  procedure Quadro_Obj.RoundAgainstClockT(Coords : Coordinates_type);
        begin end; }

      constructor Tank_Obj.Init (const Start_X, Start_Y : integer; const e_Color : byte);
      begin
           Figure_obj.init (E_color);
           Fig_els[1].Init(Start_X+1, Start_Y + 1, Color); //����� 䨣���
           Fig_els[2].Init(Start_X+1, Start_Y, Color); // ������ �窠
           Fig_els[3].Init (Start_X, Start_Y + 1, Color); //����� �窠
           Fig_els[4].Init (Start_X + 2, Start_Y + 1, Color);  //�ࠢ�� �窠
      end;

      procedure Tank_Obj.RoundAlg(const roundv : round_type; const temp_array : figure_array; var tempX, tempY : integer; const count : integer);
      begin
               case roundv of
               ByClock :    {�� �ᮢ�� ��५��}
               begin
                    tempX := temp_array[1].GetX + (temp_array[1].GetY - temp_array[count].GetY);
                    tempY := temp_array[1].GetY - (temp_array[1].GetX - temp_array[count].GetX);
               end;
               Against : {��⨢ �ᮢ�� ��५��}
               begin
                    tempX := temp_array[1].GetX - (temp_array[1].GetY - temp_array[count].GetY);
                    tempY := temp_array[1].GetY + (temp_array[1].GetX - temp_array[count].GetX);
               end;

               end; {case round of}

       end;


      procedure Tank_Obj.Round (const roundv : round_type); {�����稢��� 䨣��� �� ��� ��⨢ �ᮢ�� ��५��}
      var count, tempX, tempY : integer;
          temp_array : figure_array;
      begin

        temp_array := Fig_els;

        for count := 2 to figure_points do
        begin
             Tank_Obj.RoundAlg(roundv, temp_array, tempX, tempY, count); {��뢠�� ������, ����� �㤥� �������� ���न���� ����⮢ � ����ᨬ��� �� ���ࠢ����� ��饭�� - round}
             temp_array[count].SetX(tempX);
             temp_array[count].SetY(tempY);
        end;

        Self.DrawOnChange (temp_array); {��뢠�� ��楤���-������ ��䥪⨢��� ���ᮢ��}
        Fig_els := temp_array;   {��ᢠ����� �६���� ���ᨢ ���ᨢ� ����⮢ ��ꥪ�}
      end;


        procedure Tank_Obj.RoundT (const roundv : round_type; const Coords : Coordinates_type; Box : Els_Sps_Pointer);
        var count, tempX, tempY : integer;
          temp_array : figure_array;
        begin

        temp_array := Fig_els;

        for count := 2 to figure_points do
        begin
             Tank_Obj.RoundAlg(roundv, temp_array, tempX, tempY, count); {��뢠�� ������, ����� �㤥� �������� ���न���� ����⮢ � ����ᨬ��� �� ���ࠢ����� ��饭�� - round}
             temp_array[count].SetX(tempX);
             temp_array[count].SetY(tempY);
        end;

             if CheckFIeld (Coords, temp_array) and (not FigureInFloor (temp_array, Box)) then
              begin
                 Self.DrawOnChange (temp_array); {��뢠�� ��楤���-������ ��䥪⨢��� ���ᮢ��}
                 Fig_els := temp_array;   {��ᢠ����� �६���� ���ᨢ ���ᨢ� ����⮢ ��ꥪ�}
              end;
        end;


     function Tank_Obj.CheckField (const Coords : Coordinates_type; const temp_array : Figure_array) : boolean; {�����頥� True, �᫨ 䨣�� �� ��室���� �� ����}
      begin
             CheckField := (not Core.inX(Coords.X1, temp_array)) and (not Core.inX(Coords.X2, temp_array))
                           and (not Core.InY(Coords.Y1, temp_array)) and ( not Core.InY(Coords.Y2, temp_array));
      end;



      constructor G_Normal.Init (const Start_X, Start_Y : integer; const e_Color : byte);
      begin
            Figure_Obj.Init(E_color);
           Fig_els[1].Init(Start_X+1, Start_Y + 1, Color); //����� 䨣���
           Fig_els[2].Init(Start_X + 2, Start_Y, Color); // ������ ����� �窠
           Fig_els[3].Init (Start_X + 1, Start_Y, Color); //��� 業�஬
           Fig_els[4].Init (Start_X + 1, Start_Y + 2, Color);  //��� 業�஬
      end;

      constructor G_Invalid.Init (const Start_X, Start_Y : integer; const e_Color : byte);
      begin
            Figure_Obj.Init(E_color);
           Fig_els[1].Init(Start_X+1, Start_Y + 1, Color); //����� 䨣���
           Fig_els[2].Init(Start_X, Start_Y, Color); // ������ �ࠢ�� �窠
           Fig_els[3].Init (Start_X + 1, Start_Y, Color); //��� 業�஬
           Fig_els[4].Init (Start_X + 1, Start_Y + 2, Color);  //��� 業�஬
      end;

      constructor Z_Normal.Init (const Start_X, Start_Y : integer; const e_Color : byte);
      begin
           Figure_Obj.Init(e_Color);
           Fig_els[1].Init(Start_X, Start_Y, Color);
           Fig_els[2].Init(Start_X + 1, Start_Y, Color);
           Fig_els[3].Init (Start_X + 1, Start_Y + 1, Color);
           Fig_els[4].Init (Start_X + 2, Start_Y + 1, Color);
           position := normal;
      end;




      procedure  Z_Normal.RoundToRotated(var temp_array : figure_array);   {�������� �� �ᮢ��}
      begin
                temp_array[1].SetY(Fig_els[1].GetY + 1);
                temp_array[4].SetX(Fig_els[4].GetX-2);
                temp_array[4].SetY(Fig_els[4].GetY + 1);
      end;



      procedure Z_Normal.RoundToNormal (var temp_array : figure_array);    {�������� ��⨢ �ᮢ��}
      begin
                temp_array[1].SetY(Fig_els[1].GetY - 1);
                temp_array[4].SetX(Fig_els[4].GetX+2);
                temp_array[4].SetY(Fig_els[4].GetY -1);
      end;

      procedure Z_Normal.RoundAlg(var temp_array : figure_array);  {������ ������}
      begin
             if position = normal then
                  RoundToRotated(temp_array)  {����୥� �� �ᮢ��}
              else
                   RoundtoNormal(temp_array); {����୥� ��⨢ �ᮢ��}


      end;

      procedure Z_Normal.Round (const roundv : round_type); {������ �� �ᮢ�� ��� ��⨢ �ᮢ�� ��५��}
      var temp_array : figure_array;
      begin
                temp_array := Fig_Els; {ࠡ�⠥� � ⥬���� ���ᨢ��}
                Self.RoundAlg (temp_array);  {������ ��饭��}
                Self.DrawOnChange(temp_array);  {������ ���ᮢ��}
                Fig_els := temp_array;   {��ᢠ����� ���⭮}
      end;

      procedure Z_Normal.RoundT (const roundv : round_type; const Coords : Coordinates_type; Box : Els_Sps_Pointer);
      var temp_array : figure_array;
      begin
                temp_array := Fig_Els; {ࠡ�⠥� � ⥬���� ���ᨢ��}
                Self.RoundAlg (temp_array);  {������ ��饭��}
                if CheckFIeld (Coords, temp_array) and (not FigureInFloor (temp_array, Box)) then
                begin
                      Self.DrawOnChange(temp_array);  {������ ���ᮢ��}
                      Fig_els := temp_array;   {��ᢠ����� ���⭮}
                      if position = normal then
                                position := rotated
                      else
                                position := normal;
                end;
      end;

      constructor Z_Invalid.Init (const Start_X, Start_Y : integer; const e_Color : byte);
      begin
           Figure_Obj.Init(e_Color);
           Fig_els[1].Init(Start_X+2, Start_Y, Color);
           Fig_els[2].Init(Start_X + 1, Start_Y, Color);
           Fig_els[3].Init (Start_X + 1, Start_Y + 1, Color);
           Fig_els[4].Init (Start_X, Start_Y + 1, Color);
           position := normal;
      end;



      procedure Z_Invalid.RoundToRotated(var temp_array : figure_array);  {�������� �� �ᮢ��}
      begin
                temp_array[1].SetY(Fig_els[1].GetY + 1);
                temp_array[4].SetX(Fig_els[4].GetX+2);
                temp_array[4].SetY(Fig_els[4].GetY + 1);
      end;

      procedure Z_Invalid.RoundToNormal (var temp_array : figure_array);   {�������� ��⨢ �ᮢ��}
      begin
              temp_array[1].SetY(Fig_els[1].GetY - 1);
              temp_array[4].SetX(Fig_els[4].GetX-2);
              temp_array[4].SetY(Fig_els[4].GetY-1);
      end;



      constructor Stick.Init (const Start_X, Start_Y : integer; const e_Color : byte);
      begin
           Figure_Obj.Init(e_Color);
           Fig_els[1].Init(Start_X, Start_Y, Color);
           Fig_els[2].Init(Start_X + 1, Start_Y, Color);
           Fig_els[3].Init (Start_X + 2, Start_Y, Color);
           Fig_els[4].Init (Start_X + 3, Start_Y, Color);
           position := normal;
      end;



        procedure Stick.RoundToRotated(var temp_array : figure_array);   {�������� �� �ᮢ��}
        begin
                temp_array[1].SetX(Fig_els[1].GetX+2);
                temp_array[1].SetY(Fig_els[1].GetY-2);
                temp_array[2].SetX(Fig_els[2].GetX+1);
                temp_array[2].SetY(Fig_els[2].GetY-1);
                temp_array[4].SetX(Fig_els[4].GetX-1);
                temp_array[4].SetY(Fig_els[4].GetY + 1);
        end;

        procedure Stick.RoundToNormal (var temp_array : figure_array);   {�������� ��⨢ �ᮢ��}
        begin
                temp_array[1].SetX(Fig_els[1].GetX-2);
                temp_array[1].SetY(Fig_els[1].GetY+2);
                temp_array[2].SetX(Fig_els[2].GetX-1);
                temp_array[2].SetY(Fig_els[2].GetY+1);
                temp_array[4].SetX(Fig_els[4].GetX+1);
                temp_array[4].SetY(Fig_els[4].GetY- 1);
        end;



        function Timer_Obj.Get_Convert_Time : longint;  {��४������஢��� �६� �� ��ᮢ᪮�� �ਬ�� � ������� �᫮}
        var hours, min, sec, ssec : word;
        begin
                Dos.GetTime (hours, min, sec, ssec);
                Get_Convert_TIme := hours * 360000 + min * 6000 + sec * 100 + ssec;
        end;

        constructor Timer_Obj.Init(e_Delay : longint);
        begin
                Delay_time := e_Delay;
                Start_time := -1;
        end;

        procedure Timer_Obj.Start;     {���� ⠩���}
        var hour, min, sec, ssec : word;
        begin
             Start_Time := Get_Convert_Time;
        end;

        function Timer_Obj.IsItTime : boolean;  {�஢����, �� ����㯨�� �� 㪠������ (Delay_time) �६�}
        var NowTime, Razn : longint;

        begin
              if Start_Time = -1 then
                IsItTime := false
              else
                 begin
                      NowTime := Get_Convert_Time;
                      Write(NowTime);
                      Razn := NowTime-Start_Time;
                         if Razn >= Delay_time then
                                IsItTime := true
                         else
                                IsItTime := false;
                 end;
        end;

         constructor Floor_Obj.Init (Field_Coords : Coordinates_type);    {���樠������ ����}
         begin
              Box := nil;
              Bottom := Field_Coords.Y2-1;    {��� ����}
              Top:= Field_Coords.Y1 + 1;
              Width := (Field_Coords.X2 - Field_Coords.X1) - 1;{�ਭ� ����}
              Height := (Bottom - Top) + 1;
         end;

         function Floor_Obj.GetLastEl : Els_Sps_Pointer; {�����頥� 㪠��⥫� �� ��᫥���� ����� ᯨ᪠ ��� nul, �᫨ ᯨ᮪ ����}
         var temp : Els_Sps_Pointer;
         begin
                if Box = nil then
                        GetLastEl := nil
                else
                    begin
                        temp := Box;
                        while (temp^.link <> nil) do
                                temp := temp^.link;
                        GetLastEl := temp;
                    end;
         end;


        procedure Floor_Obj.Add (const el : fig_el_obj);  {�������� ����� 䨣��� � ����}
        var temp, New_Element : Els_Sps_Pointer;
        begin
              if Box = nil then
                begin
                       New (Box);
                        Box^.Fig_el := El;
                        Box^.Link := nil;
                end
              else
                begin
                      temp := Self.GetLastEl; {����砥� 㪠��⥫� �� ��᫥���� �����}
                      New(Temp^.Link);   {ᮧ���� ���� ����� ᯨ᪠}
                      New_Element := Temp^.Link;
                      New_Element^.Fig_el := El;
                      New_Element^.Link := nil;
                end;
        end;

        procedure Floor_Obj.AddStart (const el : fig_el_obj);
        var temp : Els_Sps_Pointer;
        begin
              temp := box;
              New (Box);
              Box^.Fig_el := El;
              Box^.link := temp;
        end;



        procedure Floor_Obj.DrawBox; {���ᮢ��� �� ������ ᯨ᪠}
        var temp : Els_Sps_Pointer;
        begin
             temp := box;

             while temp <> nil do
             begin
                 temp^.Fig_El.Draw;
                 temp := temp^.link;
             end;
        end;

        procedure Floor_Obj.DeleteBox; {㤠���� �� ������ ᯨ᪠}
        var temp : Els_Sps_Pointer;
        begin
             temp := box;

             while temp <> nil do
             begin
                 temp^.Fig_El.Delete;
                 temp := temp^.link;
             end;
        end;

        function Floor_Obj.SearchEl (const e_x, e_y : integer) : Els_Sps_Pointer; {��� ����� � ������묨 ��ࠬ��ࠬ�}
        var Find : boolean;
            temp : Els_Sps_Pointer;
        begin
                if Box = nil then
                        SearchEl := nil
                else
                begin
                    temp := Box;
                    Find := false;
                    repeat
                         if (temp^.Fig_el.GetX = e_x) and (temp^.Fig_el.GetX = e_y) then
                         begin
                                Find := true;
                                break;
                         end;
                    temp := temp^.link;
                    until temp = nil;

                    if Find then
                        SearchEl := temp
                    else
                        SearchEl := nil;
                end;
        end;

        function Floor_Obj.FindPrev (Sps_El : Els_Sps_Pointer) : Els_Sps_Pointer; {��� �।��騩 ����� ��� ���������, �����頥� nil, �᫨ �� ��諮 ������� �����, ��� ������� ����� - ���� � ᯨ᪥}
        var Find : boolean;
            temp : Els_Sps_Pointer;
        begin
             if (box = nil) or (Box^.Link = nil) then
                FindPrev := nil
             else
                begin
                        temp := box;
                        Find := false;

                  while (temp^.link <> Sps_El) or (temp <> nil) do
                  begin
                        if (temp^.link = Sps_El) then
                        begin
                                Find := true;
                                break;
                        end;
                        temp := temp^.link;
                  end;

                  if Find then
                        FindPrev := temp
                  else
                        FindPrev := nil;
             end;
       end;



        procedure Floor_Obj.Delete (const e_x, e_y : integer; var Success : boolean);
        var temp, temp2 : Els_Sps_Pointer;
        begin
                temp := Self.SearchEl (e_x, e_y);

                if temp <> nil then
                begin
                     if temp = box then
                          box := box^.link
                     else
                         begin
                          temp2 := FindPrev(temp);
                          temp2^.link := temp^.link;
                         end;
                     temp^.link := nil;
                     dispose (temp);
                     Success := true;
                end

                else Success := false; {if temp = nil}
        end;

        procedure Floor_Obj.DeleteByPointer (ptr : Els_Sps_Pointer; var Success : boolean);
        var temp : els_Sps_Pointer;
        begin
             Success := false;
             if ptr <> nil then
             begin
                if ptr = Box then
                   Box := ptr^.link
                   else
                      begin
                          temp := Self.FindPrev(ptr);
                          temp^.link := ptr^.link;

                      end;

               ptr^.link := nil;
               dispose (ptr);
               Success := true;
             end;
        end;


        procedure Floor_Obj.GetElsFromFigure(const Fig_Arr : Figure_Array);
        var count : integer;
        begin
              for count := 1 to Figure_points do
                   Self.Add (Fig_Arr[count]);

        end;


        procedure Floor_Obj.CheckFullEls(var Full : Boolean; var NumOfString : byte); {�஢���� �� ������ �� �����-� ��ப�}
        var count_array : array[1..100] of byte;
            temp : Els_Sps_Pointer;
            row_num, count : byte;

        function ConvertToRowNum (const temp : Els_Sps_Pointer) : byte; {���������� y-���न���� ����� � ����� ��ப� ��� ���ᨢ�}
        begin ConvertToRowNum := (Bottom - temp^.Fig_el.GetY) + 1; end;

        function ConvertToY (const row_num : byte) : integer;  {���⭠� ���������}
        begin ConvertToY := (Bottom - row_num) + 1; end;

        begin
               temp := box;
               Full := false;
               if temp <> nil then
               begin
                     for count := 1 to 100 do
                           count_array[count] := 0;

                     while (temp <> nil) do
                     begin

                          row_num := ConvertToRowNum(temp);
                          Inc(count_array[row_num]);
                          temp := temp^.link;
                     end;

               for count := 1 to 100 do
                    if count_array[count] = width then
                    begin
                        NumOfString := ConvertToY(count);
                        Full := true;
                        break;
                    end;
               end;
        end;





        procedure Floor_Obj.DelBoxString (const NumOfString : byte); {㤠���� ��ப� �� ����}
        var temp, temp2 : Els_Sps_Pointer;
            Success : Boolean;
        begin
             temp := box;
             while (temp <> nil) do
             begin
               if temp^.Fig_El.GetY = NumOfString then   {�᫨ Y ����� ࠢ�� ����� 㤠�塞�� ��ப�, �}
               begin
                 temp2 := temp;
                 temp := temp^.link;
                 temp2^.Fig_El.Delete; {㤠�塞 ����� � �࠭�}

                     Floor_Obj.DeleteByPointer(temp2, Success); {㤠�塞 ����� � ᯨ᪠}
                {    delay (400);
                    Gotoxy (60, 7);
                    Write(Success); }
               end
               else temp := temp^.link;

             end;
          {    delay(1000);
             Floor_Obj.DeleteBox;
             delay(1000);
             Floor_Obj.DrawBox;
             delay(1000);  }

        end;

        procedure Floor_Obj.RedrawBox (const NumOfString : byte); {����ᮢ��� ��஡�� ��� �⮩ ��ப�}
        var temp, temp2 : Els_Sps_Pointer;
            Success : boolean;
            temp_el : Fig_el_Obj;
        begin
             temp := box;
             while (temp <> nil) do
             begin
                   if (temp^.Fig_El.GetY < NumOfString) then
                   begin
                        temp2 := temp;
                        temp := temp^.link;
                        temp_el := temp2^.Fig_El;
                        temp_el.SetY(temp2^.Fig_El.GetY+1);
                        temp2^.Fig_El.Delete;
                        Floor_Obj.DeleteByPointer (temp2, Success);
                        Floor_Obj.AddStart(temp_el);
                       // temp_el.Draw;
                      //  delay(100);
                   end
                   else  temp := temp^.link;
             end;

             temp := box;
             while (temp <> nil) do
             begin
             if temp^.Fig_El.GetY <= NumOfString then
             begin
                temp^.Fig_El.Draw;
            //    delay(100);
             end;
             temp := temp^.link;
             end;
        end;

        function Floor_Obj.GetHighestPoint : integer;  {������ ������ ��� ��ப�}
        var temp : Els_Sps_Pointer;
            max_y : integer;
        begin
             max_y := 0;

              temp := box;
             while (temp <> nil) do
             begin
                  if temp^.Fig_El.GetY > max_y then
                        max_y := temp^.Fig_El.GetY;
                  temp := temp^.link
             end;
             GetHighestPoint := max_y;
        end;

        function Floor_Obj.GetBoxPointer : Els_Sps_Pointer;
        begin
                GetBoxPointer := Box
        end;



        constructor Points_Obj.Init(const Coords : Coordinates_type; const xOffset : integer); {��� ��ꥪ� �㤥� ������� �� ��ꥪ� ���� � �㤥� ��室����� ᫥�� ��� �ࠢ� �� ���� � ��।������ ᤢ����}
        begin
              if xOffset > 0 then
                begin
                        x1 := Coords.X2 + xOffset;
                        x2 := x1+7;
                end
                    else if xOffset < 0 then
                    begin
                         x2 := Coords.X1 + xOffset;
                         x1 := x2 - 7;
                    end;

              y1 := ToUp (Coords.Y1, Coords.Y2) - 2;
              y2 := ToUp (Coords.Y1, Coords.Y2) + 1;

              Color := red;     {梥� ࠬ��}
              background := black;  {䮭 ࠬ��}
              Color_Pts := green;
              Background_Pts := white;
        end;



        procedure Points_Obj.Draw;    {���ᮢ��� �窨}
        begin
               Field_Obj.Draw;
               Gotoxy (x1+2, y1+1);
               textback (5, yellow);
               Write ('����');
               Gotoxy (x1+1, y1+2);
               textback (color_pts, background_pts);
               Write ('000000');

        end;
        procedure Points_Obj.Delete;
        begin
              Field_Obj.Delete;
              textback (black, black);
              WriteSpaces (x1+1, y1+1, 4);
              WriteSpaces (x1+1, y1+2, 6);

        end;


        procedure Points_Obj.DrawPoints;
        var NumSize : byte;  {����� �᫠ �窮�}
        begin
             NumSize := GetSizeOfNum (Points);
             textback (color_pts, background_pts);
             WriteSymbols(x1+1, y1+2, 6-NumSize, '0');
             Write (Points);
        end;




        procedure Points_Obj.AddPoints (num : longint);
        var added_points : longint;
        begin
               case num of
               1: added_points := 100;
               2: added_points := 500;
               3: added_points := 1500;
               4: added_points := 3000;
               else added_points := 4000;
               end;

                Points := Points + added_points;
                Self.DrawPoints;
        end;


        constructor Info_Obj.Init(const Coords : Coordinates_type; const xOffset : integer); {��� ��ꥪ� �㤥� ������� �� ��ꥪ� ���� � �㤥� ��室����� ᫥�� ��� �ࠢ� �� ���� � ��।������ ᤢ����}
        begin
              if xOffset > 0 then
                begin
                        x1 := Coords.X2 + xOffset;
                        x2 := x1+ 20;
                end
                    else if xOffset < 0 then
                    begin
                         x2 := Coords.X1 + xOffset;
                         x1 := x2 - 20;
                    end;

              y1 := Center (Coords.Y1, Coords.Y2) - 5;
              y2 := Center (Coords.Y1, Coords.Y2) + 5;
              color := 1;
              background := black;
              color_head := green;
              back_head := red;
              color_normal := 7;
              back_normal := black;
        end;

         procedure Info_Obj.WriteType (const x, y : integer; textof : string; e_color, e_background : byte);
         begin
                gotoxy (x, y);
                textback (e_color, e_background);
                Write (textof);
         end;

         procedure Info_Obj.WriteHeadEl (const x, y : integer; textof : string);
         begin
                Self.WriteType (x, y, textof, color_head, back_head);
         end;

         procedure Info_Obj.WriteNormalEl (const x, y : integer; textof : string);
         begin
              Self.WriteType (x, y, textof, color_normal, back_normal);
         end;

         procedure Info_Obj.WriteMainEl (const x, y : integer; textof : string);
         begin
              textbackground(green);
              WriteSpaces (x1+1, y1+1, x2-x1-1);
               Self.WriteType (x, y, textof, 6, green);

         end;

        procedure Info_Obj.Draw;
        begin
                Field_Obj.Draw;
                WriteMainEl (x1+6, y1+1, '��ࠢ�����');
                WriteHeadEl (x1+1, y1+2, '�����:');
                WriteHeadEl (x1+1, y1+3, '��ࠢ�:');
                WriteHeadEl (x1+1, y1+4, '����:');
                WriteHeadEl (x1+4, y1+5, '������:');
                WriteHeadEl (x1+1, y1+6, '-�� �ᮢ��:');
                WriteHeadEl (x1+1, y1+7, '-��⨢ �ᮢ��:');
                WriteHeadEl (x1+1, y1+8, '��㧠:');
                WriteNormalEl (x1+18, y1+2, 'A');
                WriteNormalEl (x1+18, y1+3, 'D');
                WriteNormalEl (x1+18, y1+4, 'S');
                WriteNormalEl (x1+18, y1+6, 'O');
                WriteNormalEl (x1+18, y1+7, 'P');
                WriteNormalEl (x1+8, y1+8, '�஡��');


        end;

        procedure Info_Obj.Delete;
        begin
           DeleteWindow (Info_Obj.GetCoordinates, black);
        end;


        constructor Header_Obj.Init;    {���樠������ ���������}

        begin
                textofhead[1] := '����� 1.0';
                textofhead[2] := '����: kornet';
                textofhead[3] := '���������: FreePascal';

        end;
        procedure Header_Obj.Draw;
        const stdX = 30;
        var count : byte;
        begin
              textback (6, black);
              gotoxy (35, 1);
              Write(textofhead[1]);
              textback (blue, black);
              gotoxy (40, 2);
              Write(textofhead[2]);
               textback (2, black);
              gotoxy (45, 3);
              Write(textofhead[3]);

        end;



        procedure Header_Obj.Delete;
        begin

        end;


       procedure Driver_Obj.Init;
       begin
                       {ᥪ�� ���樠����樨}
             clrscr;
             Head.Init;
             Timer.Init(35);   {���樠������ ⠩���}
             Field.Init(30, 4, 48, 23);       {���樠������ ����}
             Floor.Init(Field.GetCoordinates);  {���樠������ ����}
                       {ᥪ�� ���ᮢ��}
             Points_Win.Init (Field.GetCoordinates, 2);
             Info.Init(Field.GetCoordinates, -2);

              Head.Draw;
              Field.Draw;
              Points_Win.Draw;
              Info.Draw;

             Game_Over := false;
       end;

       procedure Driver_Obj.DoingOnkey(const key : char); {ॠ��� �� ������ �������}
       const LEFTK = ['a', 'A', '�', '�'];   {�����}
       const RIGTHK = ['d', 'D', '�', '�'];   {��ࠢ�}
       const DOWNK = ['s', 'S', '�', '�'];    {����}
       const RClock = ['o', 'O', '�', '�'];  {�� �ᮢ�� ��५��}
       const Ragainst = ['p', 'P', '�', '�']; {��⨢ �ᮢ�� ��५��}
       const PAUSE_key = #32;
       begin
                if key in
                LEFTK then
                        figure^.MoveinField(Left, Field.GetCoordinates, Floor.GetBoxPointer)
                else if key in RIGTHK  then
                        figure^.MoveinField(Rigth, Field.GetCoordinates, Floor.GetBoxPointer)
                else if key in DOWNK then
                        figure^.MoveinField(Down, Field.GetCoordinates, Floor.GetBoxPointer)
                else if key in RClock then
                        figure^.RoundT(ByClock, Field.GetCoordinates, Floor.GetBoxPointer)
                else if key in Ragainst then
                        figure^.RoundT(Against, Field.GetCoordinates, Floor.GetBoxPointer)
                else if key = PAUSE_key then
                        Pause.Proc(PAUSE_key)
              {  else if Upcase (key) = 'J' then
                        Info.Delete;     }


       end;



       procedure Driver_Obj.GenerateFigures;  {������� 䨣��}
       const Xoffset = 8; {�-��砫� ������ 䨣���}
       var Color : byte;
           F_Coors : Coordinates_type;

       begin
              Randomize;
              Color := random (15);
              if Color  in [0, 8] then {�᫨ 梥� ���, � ������� ���}
                Color := 1;

              F_Coors := Field.GetCoordinates;
              case random (7) of

             0 : Figure := New (pQuadro, Init (F_Coors.X1 + Xoffset, F_Coors.Y1+1, Color));
             1 : Figure := New (pTank, Init (F_Coors.X1 + Xoffset, F_Coors.Y1+1, Color));
             2 : Figure := New (pG_Normal, Init (F_Coors.X1 + Xoffset, F_Coors.Y1+1, Color));
             3 : Figure := New (pG_Invalid, Init (F_Coors.X1 + Xoffset, F_Coors.Y1+1, Color));
             4 : Figure := New (pZ_Normal, Init (F_Coors.X1 + Xoffset, F_Coors.Y1+1, Color));
             5 : Figure := New (pZ_Invalid, Init (F_Coors.X1 + Xoffset, F_Coors.Y1+1, Color));
             6 : Figure := New (pStick, Init (F_Coors.X1 + Xoffset, F_Coors.Y1+1, Color));
             end;
       end;

       procedure Driver_Obj.AddAndCheckFloor; {�������� � ���� � �஢���� ��� }
       var Full : Boolean;  {������ �� ��ப�}
           NumOfString : byte; {����� ������ ��ப�}
           NumOfDestroy : longint;
       begin
                NumOfDestroy := 0;
                Floor.GetElsFromFigure(Figure^.GetFigArray); {��� �ਭ����� ������ �� 䨣���}
                dispose(Figure, Done);  {䨣�� 㭨�⮦�����}

                repeat
                Floor.CheckFullEls(Full,NumOfString);
                if Full then
                begin
                    Floor.DelBoxString (NumOfString);
                    Floor.RedrawBox(NumOfString);
                    inc(NumOfDestroy);
                end;
                until Full = false;
                if NumOfDestroy > 0 then
                        Points_Win.AddPoints (NumOfDestroy);
       end;


       procedure Driver_Obj.MovingFigures;
       var F_Coors : Coordinates_type;
       var key : char;
           Stop : Boolean;  {��६�����, ����� �㤥� �ࠢ���� ��⠭����� 䨣���}
       begin
             F_Coors := Field.GetCoordinates; {����砥� ���न���� ����}
             key := #0;


             repeat
                  Self.GenerateFigures; {������㥬 䨣���}
             if FigureInFloor (Figure^.GetFigArray, Floor.GetBoxPointer) then
             begin
               Game_Over := true;
               figure^.Draw;
               exit;
             end;

                  figure^.Draw;
                  TImer.Start;
                  Stop := False;
                repeat
                     if keypressed then
                       begin
                            key := readkey;
                            Self.DoingOnKey(key)  {����⢨� � ��砥 ������ �������}
                        end;



                       Stop := Figure^.GetFull;


                        if Timer.IsItTime then
                     begin
                        Stop := Figure^.InY(22) or FigureOnFloor(Figure^.GetFigArray, Floor.GetBoxPointer);;
                        if not Stop then
                        begin
                        figure^.Move(down);
                        Timer.Start;
                        end;
                     end;


                 until (key = #27) or Stop;

                    Self.AddAndCheckFloor;
                until key = #27;
                if key = #27 then halt;
       end;


       procedure Driver_Obj.GameOver (game_again : boolean);
       var key : char;
       begin
               key := #0;
                textback (12, 4);
                Gotoxy (30, 24);
                Write ('�� ���������');
                textback (white, black);
                gotoxy (32, 25);
                Write ('����� �� ࠧ? Y/N');
                repeat
                if keypressed then
                        key := readkey;

                until (UpCASe(key) = 'Y') or (UpCASe(key) = 'N');

                if UPCASE (key) = 'N' then halt;

                if UPCASE (key) = 'Y' then
                        Game_again := true


       end;
 end.
