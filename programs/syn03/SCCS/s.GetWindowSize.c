h44412
s 00024/00000/00000
d D 1.1 99/02/16 14:13:31 const 1 0
c date and time created 99/02/16 14:13:31 by const
e
u
U
f e 0
f m dapro/syn03/GetWindowSize.c
t
T
I 1
#pragma ident "%Z%%M% %I% %G%"

#include <errno.h>
#include <stdio.h>
#include <termios.h>
#include <unistd.h>

#include <sys/ioctl.h>	/* Linux needs this */


unsigned char
GetWindowSize(long *y, long *x)
{
   struct winsize    size;

   errno = 0;
   do
      if (ioctl(fileno(stdin), TIOCGWINSZ, &size) < 0 && errno != EINTR)
	 return 0;
   while (errno == EINTR);
   *x = size.ws_row;
   *y = size.ws_col;
   return *x != 0 && *y != 0;
}
E 1
