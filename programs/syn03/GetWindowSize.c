#pragma ident "@(#)dapro/syn03/GetWindowSize.c 1.1 02/16/99"

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
