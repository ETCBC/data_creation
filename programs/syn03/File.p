module File;

(* ident "@(#)dapro/syn03/File.p 1.1 02/16/99" *)

#include <Error.h>
#include <File.h>


procedure File_Close(var f: FileType);
begin
   close(f.fp)
end;


function File_EOF(var f: FileType):boolean;
begin
   File_EOF := eof(f.fp)
end;


procedure File_Open(var f: FileType; s: StringType; create: boolean);
var
   error: integer32;
begin
   error := 0; (* Shuts off compiler warning *)
   with f do begin
      if create then
	 open(fp, s, 'unknown', error)
      else
	 open(fp, s, 'old', error);
      if error <> 0 then begin
	 writeln('syn03: ', s, ': cannot open');
	 Quit
      end;
      fname := s;
      line := 1
   end
end;


procedure File_Mode(var f: FileType; m: FileAccessType);
begin
   with f do
      case m of
	 file_read:
	    reset(fp);
	 file_write:
	    rewrite(fp);
	 file_append:
	    append(fp)
      end
end;


procedure File_ReadLine(var f: FileType);
begin
   with f do begin
      readln(fp);
      line := line + 1
   end
end;
