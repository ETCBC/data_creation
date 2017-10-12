h54375
s 00034/00000/00000
d D 1.1 99/02/16 14:13:29 const 1 0
c date and time created 99/02/16 14:13:29 by const
e
u
U
f e 0
f m dapro/syn03/File.h
t
T
I 1
#ifndef FILE_H
#define FILE_H

(* ident "%Z%%M% %I% %G%" *)

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
E 1
