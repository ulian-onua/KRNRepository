unit stackatd;  {Абстрактный тип - стек}

interface

     type usertype = string;

     type stacktype = ^stacks;
     stacks = record
     x : usertype;
     link : stacktype
     end;

     type stack = object
     public
     constructor init;    {инициализация}
     procedure addstack (info : usertype); {добавить в стек}
     procedure popstack (var info : usertype; var Success : boolean);  {взять из стека}
     procedure changestack(var Success : boolean); {меняет стек наоборот}
     destructor deletestack;    {очистить стек}
     private
        top : stacktype;
     end;

implementation

       constructor stack.init;
       begin
            top := nil
       end;

       procedure stack.addstack (info : usertype);
       var p : stacktype;
       begin
             p := top;
             new (top);
             top^.x := info;
             top^.link := p
       end;

       procedure stack.popstack (var info : usertype; var Success : boolean);
        var p : stacktype;
        begin
             if top = nil then
                Success := false
             else begin
                info := top^.x;
                p := top;
                top := top^.link;
                dispose (p);
                Success := true
             end
        end;


        procedure stack.changestack (var Success : boolean);
        var x : string;
            temp : stack;
        begin
             temp.init;

        if top = nil then
              Success := false
        else begin
             While top <> nil do begin
                  popstack (x, success);
                  temp.addstack (x);
                  Success := true
             end;
             while success do begin
                temp.popstack (x, success);
                if success then
                addstack (x)
             end;
             Success := true;
             temp.deletestack
        end

        end;

        destructor stack.deletestack;
         var p : stacktype;
         begin
               while top <> nil do begin
                p := top;
                top := top^.link;
                dispose (p)
                end
         end;
        end.


