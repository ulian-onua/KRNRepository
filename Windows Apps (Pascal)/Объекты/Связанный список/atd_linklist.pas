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
         constructor init;  {���樠������}
         procedure addtolink (info : usertype);  {�������� � ᯨ᮪(� ��砫�)}
         function findlast : listtype;  {��室�� ��᫥���� ����� � ᯨ᪥}
         procedure addtoend (info : usertype); {������塞 � ����� ᯨ᪠}
         function find(info : usertype; var Success : boolean) : listtype; {���� � ᯨ᪥}
         procedure delete_element (info : usertype; var Success : boolean); {㤠���� �����}
         procedure display( var Success : boolean);  {�뢥�� ᯨ᮪ �� �࠭}
         function getroot : listtype;       {������� ��砫� ᯨ᪠}
         function findprev (point : listtype) : listtype; {�����頥� 㪠��⥫�
                                                      �� �।��騩 �����, �᫨ point = root, � �����頥� 㪠��⥫� �� ��᫥���� �����}
         function findnext (point : listtype) : listtype; {�����頥� 㪠��⥫� �� ��᫥���騩 �����}
         function IsEmpty : boolean; {���� �� ᯨ᮪}
          destructor delete_list(var Success : boolean);  {㤠���� ���� ᯨ᮪}
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










