h47708
s 00000/00007/00042
d D 1.2 14/01/13 13:05:08 const 2 1
c Removed provision for weyiqtol, as it is no longer a verbal tense.
e
s 00049/00000/00000
d D 1.1 13/01/31 12:30:29 const 1 0
c date and time created 13/01/31 12:30:29 by const
e
u
U
f e 0
f m q2pro/at2ps/ps2cor.awk
t
T
I 1
# awk(1) script to correct the ps2(5) file produced by the legacy
# version of at2ps, /projects/grammar/bin/at2ps, in accordance with
# the Quest II data. Now covers both Aramaic and Hebrew. It used to
# be part of mkdescr(1) in two language-dependent versions, but is
# better taken together with at2ps(1), because post-processing its
# output is always necessary.

#ident "%W% %E%"

$1 == "*" { print; next }

{
   label  = substr($0, 1, 10)
   lexeme = substr($0, 12, 18)
   N = split(substr($0, 31), k)
}

lexeme ~ "^ *$" { next }	# Ketib wela qere after at2ps

# State of proper nouns
k[2] ==  3 && k[12] ==  0 { k[12] = 2 }

# Default gender of adjectives
k[2] == 13 && k[11] ==  0 { k[11] = 2 }

D 2
# With Aramaic stems, weyiqtol should be imperfectum
k[4] ==  5 && k[8] == 12 { k[8] = 1 }
k[4] ==  7 && k[8] == 12 { k[8] = 1 }
k[4] == 17 && k[8] == 12 { k[8] = 1 }
k[4] == 18 && k[8] == 12 { k[8] = 1 }
k[4] == 20 && k[8] == 12 { k[8] = 1 }

E 2
# Format the output
{
   printf("%-10s %-18s", label, lexeme)
   i = 1
   while (i <= 1)
      printf(" %2d", k[i++])
   printf(" ");
   while (i <= 7)
      printf(" %2d", k[i++])
   printf("  ");
   while (i <= 11)
      printf(" %2d", k[i++])
   printf("  ");
   while (i <= N)
      printf(" %3d", k[i++])
   printf("\n")
}
E 1
