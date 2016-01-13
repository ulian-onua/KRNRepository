unit DOSWIN;

interface

        type  doswinconverter = object
        public
        procedure decode_char (var ch : char);
        procedure decode_string (var s : string);
        procedure uncode_char (var ch : char);
        procedure uncode_string (var s : string);
        end;


implementation

        procedure doswinconverter.decode_char (var ch : char);
        begin
          if ord (ch) in [192..239] then
                ch := chr (ord (ch) - 64)
          else if ord (ch) in [240..255] then
                ch := chr (ord (ch) - 16)
          else if ord (ch) = 189 then
                ch := chr (ord (241))
          else if ord (ch) = 168 then
                ch := chr (ord (240))
        end;

        procedure doswinconverter.decode_string (var s : string);
         var i : byte;
         begin
              for i := 1 to Length (s) do
               decode_char (s[i])
         end;

        procedure doswinconverter.Uncode_char (var ch : char);
        begin
          if ord (ch) in [128..175] then
                ch := chr (ord (ch) + 64)
          else if ord (ch) in [224..239] then
                ch := chr (ord (ch) + 16)
          else if ord (ch) = 241 then
                ch := chr (ord (189))
          else if ord (ch) = 240 then
                ch := chr (ord (168))
        end;


         procedure doswinconverter.uncode_string (var s : string);
         var i : byte;
         begin
              for i := 1 to Length (s) do
               uncode_char (s[i])
         end;
end.

