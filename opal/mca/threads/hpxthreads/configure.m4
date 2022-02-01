# -*- shell-script -*-
#
# Copyright (c) 2004-2005 The Trustees of Indiana University and Indiana
#                         University Research and Technology
#                         Corporation.  All rights reserved.
# Copyright (c) 2004-2005 The University of Tennessee and The University
#                         of Tennessee Research Foundation.  All rights
#                         reserved.
# Copyright (c) 2004-2005 High Performance Computing Center Stuttgart,
#                         University of Stuttgart.  All rights reserved.
# Copyright (c) 2004-2005 The Regents of the University of California.
#                         All rights reserved.
# Copyright (c) 2010      Cisco Systems, Inc.  All rights reserved.
# Copyright (c) 2015      Research Organization for Information Science
#                         and Technology (RIST). All rights reserved.
# Copyright (c) 2019      Triad National Security, LLC. All rights
#                         reserved.
#
# $COPYRIGHT$
#
# Additional copyrights may follow
#
# $HEADER$
#

AC_DEFUN([OPAL_CONFIG_HPXTHREADS],[

    AC_ARG_WITH([hpxthreads],
                [AS_HELP_STRING([--with-hpxthreads=DIR],
                                [Specify location of hpxthreads installation.  Error if hpxthreads support cannot be found.])])

    AC_ARG_WITH([hpxthreads-libdir],
                [AS_HELP_STRING([--with-hpxthreads-libdir=DIR],
                                [Search for hpxthreads libraries in DIR])])

    opal_check_hpxthreads_save_CPPFLAGS=$CPPFLAGS
    opal_check_hpxthreads_save_LDFLAGS=$LDFLAGS
    opal_check_hpxthreads_save_LIBS=$LIBS

    opal_hpxthreads_happy=yes
    AS_IF([test "$with_hpxthreads" = "no"],
          [opal_hpxthreads_happy=no])

    AS_IF([test $opal_hpxthreads_happy = yes],
          [AC_MSG_CHECKING([looking for hpxthreads in])
           AS_IF([test "$with_hpxthreads" != "yes"],
                 [opal_hpxthreads_dir=$with_hpxthreads
                  AC_MSG_RESULT([($opal_hpxthreads_dir)])],
                 [AC_MSG_RESULT([(default search paths)])])
           AS_IF([test ! -z "$with_hpxthreads_libdir" && \
                         test "$with_hpxthreads_libdir" != "yes"],
                 [opal_hpxthreads_libdir=$with_hpxthreads_libdir])
          ])

    AS_IF([test $opal_hpxthreads_happy = yes],
          [OPAL_CHECK_PACKAGE([opal_hpxthreads],
                              [qthread.h],
                              [qthread],
                              [qthread_initialize],
                              [],
                              [$opal_hpxthreads_dir],
                              [$opal_hpxthreads_libdir],
                              [],
                              [opal_hpxthreads_happy=no])])

    AS_IF([test $opal_hpxthreads_happy = yes && test -n "$opal_hpxthreads_dir"],
          [OPAL_HPXTHREADS_INCLUDE_PATH="$opal_hpxthreads_dir/include/"],
          [OPAL_HPXTHREADS_INCLUDE_PATH=""])

    AS_IF([test $opal_hpxthreads_happy = yes],
          [TPKG_CFLAGS="$opal_hpxthreads_CPPFLAGS"
           TPKG_FCFLAGS="$opal_hpxthreads_CPPFLAGS"
           TPKG_CXXFLAGS="$opal_hpxthreads_CPPFLAGS"
           TPKG_CPPFLAGS="$opal_hpxthreads_CPPFLAGS"
           TPKG_CXXCPPFLAGS="$opal_hpxthreads_CPPFLAGS"
           TPKG_LDFLAGS="$opal_hpxthreads_LDFLAGS"
           TPKG_LIBS="$opal_hpxthreads_LIBS"])

    AC_CONFIG_FILES([opal/mca/threads/hpxthreads/threads_hpxthreads.h])
    AC_SUBST([OPAL_HPXTHREADS_INCLUDE_PATH])
    AC_SUBST([opal_hpxthreads_CPPFLAGS])
    AC_SUBST([opal_hpxthreads_LDFLAGS])
    AC_SUBST([opal_hpxthreads_LIBS])

    CPPFLAGS=$opal_check_hpxthreads_save_CPPFLAGS
    LDFLAGS=$opal_check_hpxthreads_save_LDFLAGS
    LIBS=$opal_check_hpxthreads_save_LIBS

    AS_IF([test "$opal_hpxthreads_happy" = "yes"],
          [$1],
          [$2])
])dnl

AC_DEFUN([MCA_opal_threads_hpxthreads_PRIORITY], [30])

AC_DEFUN([MCA_opal_threads_hpxthreads_COMPILE_MODE], [
    AC_MSG_CHECKING([for MCA component $2:$3 compile mode])
    $4="static"
    AC_MSG_RESULT([$$4])
])

# If component was selected, $1 will be 1 and we should set the base header
AC_DEFUN([MCA_opal_threads_hpxthreads_POST_CONFIG],[
    AS_IF([test "$1" = "1"], 
          [opal_thread_type_found="hpxthreads"
           AC_DEFINE_UNQUOTED([MCA_threads_base_include_HEADER],
                              ["opal/mca/threads/hpxthreads/threads_hpxthreads_threads.h"],
                              [Header to include for threads implementation])
           AC_DEFINE_UNQUOTED([MCA_threads_mutex_base_include_HEADER],
                              ["opal/mca/threads/hpxthreads/threads_hpxthreads_mutex.h"],
                              [Header to include for mutex implementation])
           AC_DEFINE_UNQUOTED([MCA_threads_tsd_base_include_HEADER],
                              ["opal/mca/threads/hpxthreads/threads_hpxthreads_tsd.h"],
                              [Header to include for tsd implementation])
           THREAD_CFLAGS="$TPKG_CFLAGS"
           THREAD_FCFLAGS="$TPKG_FCFLAGS"
           THREAD_CXXFLAGS="$TPKG_CXXFLAGS"
           THREAD_CPPFLAGS="$TPKG_CPPFLAGS"
           THREAD_CXXCPPFLAGS="$TPKG_CXXCPPFLAGS"
           THREAD_LDFLAGS="$TPKG_LDFLAGS"
           THREAD_LIBS="$TPKG_LIBS"
           LIBS="$LIBS $THREAD_LIBS"
           LDFLAGS="$LDFLAGS $THREAD_LDFLAGS"
         ])
])dnl


# MCA_threads_hpxthreads_CONFIG(action-if-can-compile,
#                        [action-if-cant-compile])
# ------------------------------------------------
AC_DEFUN([MCA_opal_threads_hpxthreads_CONFIG],[
    AC_CONFIG_FILES([opal/mca/threads/hpxthreads/Makefile])

    AS_IF([test "$with_threads" = "hpxthreads"],
          [OPAL_CONFIG_HPXTHREADS([hpxthreads_works=1],[hpxthreads_works=0])],
          [hpxthreads_works=0])

    AS_IF([test "$hpxthreads_works" = "1"],
          [$1
           opal_thread_type_found="hpxthreads"],
          [$2])
])
