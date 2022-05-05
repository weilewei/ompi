/* -*- Mode: C; c-basic-offset:4 ; indent-tabs-mode:nil -*- */
/*
 * Copyright (c) 2004-2005 The Trustees of Indiana University and Indiana
 *                         University Research and Technology
 *                         Corporation.  All rights reserved.
 * Copyright (c) 2004-2005 The University of Tennessee and The University
 *                         of Tennessee Research Foundation.  All rights
 *                         reserved.
 * Copyright (c) 2004-2005 High Performance Computing Center Stuttgart,
 *                         University of Stuttgart.  All rights reserved.
 * Copyright (c) 2004-2005 The Regents of the University of California.
 *                         All rights reserved.
 * Copyright (c) 2007-2016 Los Alamos National Security, LLC.  All rights
 *                         reserved.
 * Copyright (c) 2015      Research Organization for Information Science
 *                         and Technology (RIST). All rights reserved.
 * Copyright (c) 2019      Sandia National Laboratories.  All rights reserved.
 *
 * $COPYRIGHT$
 *
 * Additional copyrights may follow
 *
 * $HEADER$
 */

#ifndef OPAL_MCA_THREADS_HPXCTHREADS_THREADS_HPXCTHREADS_TSD_H
#define OPAL_MCA_THREADS_HPXCTHREADS_THREADS_HPXCTHREADS_TSD_H 1

#include "opal/mca/threads/hpxcthreads/threads_hpxcthreads.h"
#include <stdio.h>

typedef hpxc_key_t opal_tsd_key_t;

static inline int opal_tsd_key_delete(opal_tsd_key_t key)
{
    printf("opal_tsd_key_delete\n");
    int ret = hpxc_key_delete(key);
    return 0 == ret ? OPAL_SUCCESS : OPAL_ERR_IN_ERRNO;
}

static inline int opal_tsd_set(opal_tsd_key_t key, void *value)
{
    printf("opal_tsd_set\n");
    int ret = hpxc_setspecific(key, value);
    return 0 == ret ? OPAL_SUCCESS : OPAL_ERR_IN_ERRNO;
}

static inline int opal_tsd_get(opal_tsd_key_t key, void **valuep)
{
    printf("opal_tsd_get\n");
    *valuep = hpxc_getspecific(key);
    return OPAL_SUCCESS;
}

#endif /* OPAL_MCA_THREADS_HPXCTHREADS_THREADS_HPXCTHREADS_TSD_H */
