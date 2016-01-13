program testinit;

uses atd_linklist;

var list : linklist;
    s : string;
    success : boolean;
    pp : listtype;
begin
        list.init;

        repeat
            readln (s);
            if s <> 'exit' then
            list.addtoend (s);
            until s = 'exit';

        Write ('What find :');
        READLN (S);

        pp := list.find (s, success);
        if pp = nil then
                Writeln ('Not find')
        else
           Writeln (pp^.x, ' find!');

        list.delete_element (s, success);

         list.delete_list (success);
        list.display (success);


readln
end.
