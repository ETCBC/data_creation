#ifndef FILE_H
#define FILE_H

(* ident "@(#)dapro/syn03/File.h 1.1 02/16/99" *)

#include	<String.h>

type
   FileAccessType =
      (file_read, file_write, file_append);
   FileType =
      record
	 fp: text;
	 fname: StringType;
	 line: integer
      end;


procedure File_Close(var f: FileType);
extern;

function  File_EOF(var f: FileType):boolean;
extern;

procedure File_Mode(var f: FileType; m: FileAccessType);
extern;

procedure File_Open(var f: FileType; s: StringType; create: boolean);
extern;

procedure File_ReadLine(var f: FileType);
extern;

#endif
