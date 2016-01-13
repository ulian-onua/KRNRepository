
program teststackatd; {программа тестирует stackatd}

uses stackatd;

var s : string;
    Success : boolean;
    newstack : stack;


begin
          Writeln (test8087);
          newstack.init;
          repeat
            readln (s);
            if s <> 'exit' then
            newstack.addstack (s);
            until s = 'exit';

            newstack.changestack (success);

           repeat
           newstack.popstack (s, success);
           if success then
            Writeln (s)
           until not success;
           newstack.deletestack;
           readln;

 end.
