unit com_proc_atd;

    interface

    uses onefile_atd, DOS, crt;

type com_proc = object
      public
      procedure enterkey (files : onefile);
      private

      end;

implementation

      uses  filelist_atd;
      procedure com_proc.enterkey (files : onefile);
      var ourlist : filelist;
      begin
                if files.GetFileType  = executable then begin
                clrscr;
                exec (files.GetFilename, ' ')
                end;

             {   if files.GetFileType  = down_dir then begin
                ChDir ( files.GetFileName);
                ourlist.init;
                ourlist.all_driver;
                end;    }


            {    if files.GetFileType  = up_dir then
                ChDir (files.GetFilename);
                all_driver; }
     end;
end.
