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

AC_DEFUN([OPAL_CONFIG_HPXCTHREADS],[

    AC_ARG_WITH([hpxcthreads],
                [AS_HELP_STRING([--with-hpxcthreads=DIR],
                                [Specify location of hpxcthreads installation.  Error if hpxcthreads support cannot be found.])])

    AC_ARG_WITH([hpxcthreads-libdir],
                [AS_HELP_STRING([--with-hpxcthreads-libdir=DIR],
                                [Search for hpxcthreads libraries in DIR])])

    opal_check_hpxcthreads_save_CPPFLAGS=$CPPFLAGS
    opal_check_hpxcthreads_save_LDFLAGS=$LDFLAGS
    opal_check_hpxcthreads_save_LIBS=$LIBS

    opal_hpxcthreads_happy=yes
    AS_IF([test "$with_hpxcthreads" = "no"],
          [opal_hpxcthreads_happy=no])

    AS_IF([test $opal_hpxcthreads_happy = yes],
          [AC_MSG_CHECKING([looking for hpxcthreads in])
           AS_IF([test "$with_hpxcthreads" != "yes"],
                 [opal_hpxcthreads_dir=$with_hpxcthreads
                  AC_MSG_RESULT([($opal_hpxcthreads_dir)])],
                 [AC_MSG_RESULT([(default search paths)])])
           AS_IF([test ! -z "$with_hpxcthreads_libdir" && \
                         test "$with_hpxcthreads_libdir" != "yes"],
                 [opal_hpxcthreads_libdir=$with_hpxcthreads_libdir])
          ])

    AS_IF([test $opal_hpxcthreads_happy = yes],
          [OPAL_CHECK_PACKAGE([opal_hpxcthreads],
                              [hpxc/threads.h],
                              [hpxcd],
                              [hpxc_thread_create],
                              [-lhpx -lhpx_core],
                              [$opal_hpxcthreads_dir],
                              [$opal_hpxcthreads_libdir],
                              [],
                              [opal_hpxcthreads_happy=no])])

    AS_IF([test $opal_hpxcthreads_happy = yes && test -n "$opal_hpxcthreads_dir"],
          [OPAL_HPXCTHREADS_INCLUDE_PATH="$opal_hpxcthreads_dir/include/"],
          [OPAL_HPXCTHREADS_INCLUDE_PATH=""])

    AS_IF([test $opal_hpxcthreads_happy = yes],
          [TPKG_CFLAGS="$opal_hpxcthreads_CPPFLAGS"
           TPKG_FCFLAGS="$opal_hpxcthreads_CPPFLAGS"
           TPKG_CXXFLAGS="$opal_hpxcthreads_CPPFLAGS"
           TPKG_CPPFLAGS="$opal_hpxcthreads_CPPFLAGS"
           TPKG_CXXCPPFLAGS="$opal_hpxcthreads_CPPFLAGS"
           TPKG_LDFLAGS="$opal_hpxcthreads_LDFLAGS"
           TPKG_LIBS="$opal_hpxcthreads_LIBS"])

    AC_CONFIG_FILES([opal/mca/threads/hpxcthreads/threads_hpxcthreads.h])
    AC_SUBST([OPAL_HPXCTHREADS_INCLUDE_PATH])
    AC_SUBST([opal_hpxcthreads_CPPFLAGS])
    AC_SUBST([opal_hpxcthreads_LDFLAGS])
    AC_SUBST([opal_hpxcthreads_LIBS])

    CPPFLAGS=$opal_check_hpxcthreads_save_CPPFLAGS
    LDFLAGS=$opal_check_hpxcthreads_save_LDFLAGS
    LIBS=$opal_check_hpxcthreads_save_LIBS

    AS_IF([test "$opal_hpxcthreads_happy" = "yes"],
          [$1],
          [$2])
])dnl

AC_DEFUN([MCA_opal_threads_hpxcthreads_PRIORITY], [30])

AC_DEFUN([MCA_opal_threads_hpxcthreads_COMPILE_MODE], [
    AC_MSG_CHECKING([for MCA component $2:$3 compile mode])
    $4="static"
    AC_MSG_RESULT([$$4])
])

# If component was selected, $1 will be 1 and we should set the base header
AC_DEFUN([MCA_opal_threads_hpxcthreads_POST_CONFIG],[
    AS_IF([test "$1" = "1"], 
          [opal_thread_type_found="hpxcthreads"
           AC_DEFINE_UNQUOTED([MCA_threads_base_include_HEADER],
                              ["opal/mca/threads/hpxcthreads/threads_hpxcthreads_threads.h"],
                              [Header to include for threads implementation])
           AC_DEFINE_UNQUOTED([MCA_threads_mutex_base_include_HEADER],
                              ["opal/mca/threads/hpxcthreads/threads_hpxcthreads_mutex.h"],
                              [Header to include for mutex implementation])
           AC_DEFINE_UNQUOTED([MCA_threads_tsd_base_include_HEADER],
                              ["opal/mca/threads/hpxcthreads/threads_hpxcthreads_tsd.h"],
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


# MCA_threads_hpxcthreads_CONFIG(action-if-can-compile,
#                        [action-if-cant-compile])
# ------------------------------------------------
AC_DEFUN([MCA_opal_threads_hpxcthreads_CONFIG],[
    AC_CONFIG_FILES([opal/mca/threads/hpxcthreads/Makefile])

    AS_IF([test "$with_threads" = "hpxcthreads"],
          [OPAL_CONFIG_HPXCTHREADS([hpxcthreads_works=1],[hpxcthreads_works=0])],
          [hpxcthreads_works=0])

    AS_IF([test "$hpxcthreads_works" = "1"],
          [$1
           opal_thread_type_found="hpxcthreads"],
          [$2])
])
