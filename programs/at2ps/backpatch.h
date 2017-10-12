#ifndef BACKPATCH_H
#define BACKPATCH_H

#pragma ident "@(#)what/q2pro/at2ps/backpatch.h 1.1 09/19/00"

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
