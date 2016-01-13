unit atd_linklist;

interface

    type usertype = string;

    type listtype = ^linklists;
         linklists = record
         x : usertype;
         link : listtype;
         end;

    type linklist = object
         public
         constructor init;  {инициализация}
         procedure addtolink (info : usertype);  {добавить в список(в начало)}
         function findlast : listtype;  {находим последний элемент в списке}
         procedure addtoend (info : usertype); {добавляем в конец списка}
         function find(info : usertype; var Success : boolean) : listtype; {найти в списке}
         procedure delete_element (info : usertype; var Success : boolean); {удалить элемент}
         procedure display( var Success : boolean);  {вывести список на экран}
         function getroot : listtype;       {получить начало списка}
         function findprev (point : listtype) : listtype; {возвращает указатель
                                                      на предыдущий элемент, если point = root, то возвращает указатель на последний элемент}
         function findnext (point : listtype) : listtype; {возвращает указатель на последующий элемент}
         function IsEmpty : boolean; {пуст ли список}
          destructor delete_list(var Success : boolean);  {удалить весь список}
         private
         root : listtype;
         end;


implementation

        constructor linklist.init;
        begin
                root := nil;

        end;

        procedure linklist.addtolink (info : usertype);
        var p : listtype;

        begin
              p := root;
              new (root);
              root^.x := info;
              root^.link := p;

        end;


        function linklist.findlast : listtype;
        var p : listtype;
        begin
             p := root;

             if p <> nil then
                while p^.link <> nil do
                p := p^.link;

                findlast := p;
             end;

        procedure linklist.addtoend (info : usertype);
        var last : listtype;
        begin
             last := self.findlast;
             if last = nil then
              self.addtolink (info)
              else begin
             new (last^.link);
             last := last^.link;
             last^.x := info;
             last^.link := nil;
             end
        end;


        function linklist.find (info : usertype; var Success : boolean) : listtype;
        var p : listtype;
        begin

             Success := false;

             if root <> nil then begin
             p := root;

                while (p <> nil) do begin
                 if p^.x = info then begin
                    Success := true;
                    break
                    end;

                 if not success then
                    p := p^.link;
                end;
             end;

                if success then
                     find := p
                else
                     find := nil
        end;


        procedure linklist.delete_element (info : usertype; var Success : boolean);
        var wanted, p : listtype;
        begin

               wanted := self.find (info, success);

               if success then begin
                if wanted = root then
                   root := root^.link
                else  begin
                    p := self.findprev (wanted);
                    p^.link := wanted^.link;
                end;
                wanted := nil;
                dispose (wanted);
                end;

        end;


        procedure linklist.display( var Success : boolean);
        var p : listtype;
        begin
                if root = nil then
                success := false
                else begin
                p := root;
                while p <> nil do begin
                 Writeln (p^.x);
                 p := p^.link
                end;
                Success := true
                end
        end;


        function linklist.getroot : listtype;
        begin
                getroot := root
        end;




        function linklist.findprev (point : listtype) : listtype;
        var  p : listtype;
        begin
             if point = root then
               findprev := self.findlast
             else begin
              p := root;
              while p^.link <> point do
                  p := p^.link;

             findprev := p;
             end;
        end;

        function linklist.findnext (point : listtype) : listtype;
          var  p : listtype;
        begin

             if point = self.findlast then
              findnext := root
             else
                findnext := point^.link
        end;

        function linklist.IsEmpty : boolean;
        begin
                IsEmpty := (root = nil)
        end;

        destructor linklist.delete_list(var Success : boolean);
        var p : listtype;
           begin

                if root = nil then
                 Success := false
                 else begin

                while root <> nil do begin
                     p := root;
                     root := root^.link;
                     p := nil;
                     dispose (p)
                end;
                  Success := true
                end
        end;


 end.










