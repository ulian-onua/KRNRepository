 program freespace;
 uses dos, crt;

 const maxdisk = 20;

 type disks = record
      named : char;
      freespc, size, notfreespc : comp;
      Isit : boolean;
      end;

  type diskarray = array [1..maxdisk + 1] of disks;

 var disk : diskarray;
     alldisk : byte;


procedure init (var disk : diskarray);
var i : byte;
    diskname : char;
begin
        diskname := 'A';

        for i := 1 to maxdisk  do begin
             disk[i].named := diskname;
             disk[i].IsIt := false;
             inc (diskname);
        end;
end;

function convert (x, b : comp) : comp;
begin
      convert := x / b;
end;

procedure aboutdisk (var disk : diskarray; var alldisk : byte);

var i : byte;


begin
        alldisk := 0;
        for i := 1 to maxdisk do begin
           disk[i].size := disksize (i);

           if disk[i].size <> -1 then begin
              disk[i].size := convert (disk[i].size, sqr (1024));
              disk[i].IsIt := true;
              disk[i].freespc := convert (diskfree (i), sqr (1024));
              disk[i].notfreespc := disk[i].size - disk[i].freespc;
              inc (alldisk)
           end;
        end;
end;

procedure writedisk (x : disks);
begin
        with x do
     Writeln ('���: ', named, '. �ᥣ�: ',
     size: 0 :0, ' ��. �����: ',
     notfreespc :0:0, ' ��. ��������: ', freespc : 0:0, ' ��.');
end;

procedure displaythis ( var disk : diskarray);
var i : byte;
begin
        Writeln ('������� ', alldisk, ' ��᪮�');
      for i := 1 to maxdisk do
       if disk[i].IsIt = true then
        writedisk (disk[i])
       end;

 begin
        clrscr;
        init (disk);
         aboutdisk (disk, alldisk);
         displaythis (disk);
         readkey
 end.


