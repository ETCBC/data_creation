h54305
s 00024/00000/00000
d D 1.1 00/09/19 12:20:20 const 1 0
c Version of Sep 12 1995
e
u
U
f e 0
f m q2pro/at2ps/backpatch.h
t
T
I 1
#ifndef BACKPATCH_H
#define BACKPATCH_H

#pragma ident "%Z%what/%M% %I% %G%"

typedef struct bplist bplist_t;


#if __STDC__
extern bplist_t *bplist_create(quad_t *quad);
extern bplist_t *bplist_merge(bplist_t *list1, bplist_t *list2);
extern void     bplist_patch(bplist_t *list, quad_t *quad);
extern void     bplist_delete(bplist_t *list);

#else				/* __STDC__ */

extern bplist_t *bplist_create();
extern bplist_t *bplist_merge();
extern void     bplist_patch();
extern void     bplist_delete();

#endif				/* __STDC__ */

#endif				/* BACKPATCH_H */
E 1
