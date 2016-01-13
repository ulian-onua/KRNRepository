program test_core;

uses core, crt;

var field : field_obj;
var zmeika : zmeika_obj;
    apple : apple_obj;
var i : byte;
var driver : driver_obj;
var exit_game : boolean;
begin

      repeat
      driver.game;
      driver.done (exit_game);
      until not exit_game;
end.
