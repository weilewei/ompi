/* -*- Mode: C; c-basic-offset:4 ; indent-tabs-mode:nil -*- */
/*
 * Copyright (c) 2004-2005 The Trustees of Indiana University and Indiana
 *                         University Research and Technology
 *                         Corporation.  All rights reserved.
 * Copyright (c) 2004-2006 The University of Tennessee and The University
 *                         of Tennessee Research Foundation.  All rights
 *                         reserved.
 * Copyright (c) 2004-2005 High Performance Computing Center Stuttgart,
 *                         University of Stuttgart.  All rights reserved.
 * Copyright (c) 2004-2005 The Regents of the University of California.
 *                         All rights reserved.
 * Copyright (c) 2007-2018 Los Alamos National Security, LLC.  All rights
 *                         reserved.
 * Copyright (c) 2015-2016 Research Organization for Information Science
 *                         and Technology (RIST). All rights reserved.
 * Copyright (c) 2019      Sandia National Laboratories.  All rights reserved.
 * Copyright (c) 2020      Triad National Security, LLC. All rights
 *                         reserved.
 *
 * Copyright (c) 2020      Cisco Systems, Inc.  All rights reserved.
 * Copyright (c) 2021      Argonne National Laboratory.  All rights reserved.
 * $COPYRIGHT$
 *
 * Additional copyrights may follow
 *
 * $HEADER$
 */

#ifndef OPAL_MCA_THREADS_HPXCTHREADS_THREADS_HPXCTHREADS_MUTEX_H
#define OPAL_MCA_THREADS_HPXCTHREADS_THREADS_HPXCTHREADS_MUTEX_H 1

#include "opal_config.h"

#include <stdio.h>

#include "opal/class/opal_object.h"
#include "opal/constants.h"
#include "opal/mca/threads/hpxcthreads/threads_hpxcthreads.h"
#include "opal/sys/atomic.h"
#include "opal/util/output.h"

BEGIN_C_DECLS

typedef hpxc_mutex_t opal_thread_internal_mutex_t;

#define OPAL_THREAD_INTERNAL_MUTEX_INITIALIZER           {NULL, 0x4321}
#define OPAL_THREAD_INTERNAL_RECURSIVE_MUTEX_INITIALIZER {NULL, 0x4321}

static inline int opal_thread_internal_mutex_init(opal_thread_internal_mutex_t *p_mutex,
                                                  bool recursive)
{
//    printf("opal_thread_internal_mutex_init: %p, recursive: %d\n", p_mutex, recursive);
    hpxc_mutex_init(p_mutex, NULL);
    return OPAL_SUCCESS;
}

static inline void opal_thread_internal_mutex_lock(opal_thread_internal_mutex_t *p_mutex)
{
//    printf("opal_thread_internal_mutex_lock: %p\n", p_mutex);
    if(p_mutex->handle==NULL && p_mutex->magic==0x4321)
        hpxc_mutex_init(p_mutex, NULL);

#if OPAL_ENABLE_DEBUG
    int ret = hpxc_mutex_lock(p_mutex);
    if (EDEADLK == ret) {
        opal_output(0, "opal_thread_internal_mutex_lock() %d", ret);
    }
    // assert(0 == ret);
#else
    hpxc_mutex_lock(p_mutex);
#endif
}

static inline int opal_thread_internal_mutex_trylock(opal_thread_internal_mutex_t *p_mutex)
{
//    printf("opal_thread_internal_mutex_trylock\n");
    if(p_mutex->handle==NULL && p_mutex->magic==0x4321)
        hpxc_mutex_init(p_mutex, NULL);

    int ret = hpxc_mutex_trylock(p_mutex);
    return 0 == ret ? 0 : 1;
}

static inline void opal_thread_internal_mutex_unlock(opal_thread_internal_mutex_t *p_mutex)
{
//    printf("opal_thread_internal_mutex_unlock: %p\n", p_mutex);

    hpxc_mutex_unlock(p_mutex);
}

static inline void opal_thread_internal_mutex_destroy(opal_thread_internal_mutex_t *p_mutex)
{
//    printf("opal_thread_internal_mutex_destroy\n");
    hpxc_mutex_destroy(p_mutex);
}

typedef hpxc_cond_t opal_thread_internal_cond_t;

#define OPAL_THREAD_INTERNAL_COND_INITIALIZER                                          \
    {                                                                                  \
        .m_lock = OPAL_ATOMIC_LOCK_INIT, .m_waiter_head = NULL, .m_waiter_tail = NULL, \
    }

static inline int opal_thread_internal_cond_init(opal_thread_internal_cond_t *p_cond)
{
//    printf("opal_thread_internal_cond_init\n");
    hpxc_cond_init(p_cond, 0);
    return OPAL_SUCCESS;
}

static inline void opal_thread_internal_cond_wait(opal_thread_internal_cond_t *p_cond,
                                                  opal_thread_internal_mutex_t *p_mutex)
{
//    printf("opal_thread_internal_cond_wait\n");
    hpxc_cond_wait(p_cond, p_mutex);
}

static inline void opal_thread_internal_cond_broadcast(opal_thread_internal_cond_t *p_cond)
{
//    printf("opal_thread_internal_cond_broadcast\n");
    hpxc_cond_broadcast(p_cond);
}

static inline void opal_thread_internal_cond_signal(opal_thread_internal_cond_t *p_cond)
{
//    printf("opal_thread_internal_cond_signal\n");
    hpxc_cond_signal(p_cond);
}

static inline void opal_thread_internal_cond_destroy(opal_thread_internal_cond_t *p_cond)
{
//    printf("opal_thread_internal_cond_destroy\n");
    hpxc_cond_destroy(p_cond);
}

END_C_DECLS

#endif /* OPAL_MCA_THREADS_HPXCTHREADS_THREADS_HPXCTHREADS_MUTEX_H */
