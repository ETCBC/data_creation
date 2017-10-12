h34590
s 00026/00000/00000
d D 1.1 98/01/21 13:43:46 const 1 0
c date and time created 98/01/21 13:43:46 by const
e
u
U
f e 0
f m dapro/syn03/ps2phd.sh
t
T
I 1
#!/usr/xpg4/bin/awk -f

#ident "%Z%%M% %I% %G%"

BEGIN {
   need_label = 1
}

$1 == "*" {
   print "  999"
   need_label = 1
}

NF >= 17 {
   split(substr($0, 31), x)

   if (need_label == 1) {
      printf("%-10s ", substr($0, 1, 10))
      need_label = 0
   }
   printf(" %2d %2d", x[12], x[13])
   if (x[14] != 0)
      printf(" : %2d %2d", x[14], x[15])
   else
      printf(" ,")
}
E 1
