dnl
dnl $Id: config.m4,v 1.58.2.4.2.11.2.8 2009/04/20 15:39:48 jani Exp $
dnl

AC_DEFUN([PHP_MBSTRING_NG_ADD_SOURCES], [
  PHP_MBSTRING_NG_SOURCES="$PHP_MBSTRING_NG_SOURCES $1"
])

AC_DEFUN([PHP_MBSTRING_NG_ADD_BASE_SOURCES], [
  PHP_MBSTRING_NG_BASE_SOURCES="$PHP_MBSTRING_NG_BASE_SOURCES $1"
])

AC_DEFUN([PHP_MBSTRING_NG_ADD_BUILD_DIR], [
  PHP_MBSTRING_NG_EXTRA_BUILD_DIRS="$PHP_MBSTRING_NG_EXTRA_BUILD_DIRS $1"
])

AC_DEFUN([PHP_MBSTRING_NG_ADD_INCLUDE], [
  PHP_MBSTRING_NG_EXTRA_INCLUDES="$PHP_MBSTRING_NG_EXTRA_INCLUDES $1"
])

AC_DEFUN([PHP_MBSTRING_NG_ADD_CONFIG_HEADER], [
  PHP_MBSTRING_NG_EXTRA_CONFIG_HEADERS="$PHP_MBSTRING_NG_EXTRA_CONFIG_HEADERS $1"
])

AC_DEFUN([PHP_MBSTRING_NG_ADD_CFLAG], [
  PHP_MBSTRING_NG_CFLAGS="$PHP_MBSTRING_NG_CFLAGS $1"
])

AC_DEFUN([PHP_MBSTRING_NG_ADD_INSTALL_HEADERS], [
  PHP_MBSTRING_NG_INSTALL_HEADERS="$PHP_MBSTRING_NG_INSTALL_HEADERS $1"
])

AC_DEFUN([PHP_MBSTRING_NG_EXTENSION], [
  PHP_SETUP_ICU(MBSTRING_NG_SHARED_LIBADD)
  PHP_REQUIRE_CXX()

  PHP_NEW_EXTENSION(mbstring_ng, $PHP_MBSTRING_NG_SOURCES, $ext_shared,, $PHP_MBSTRING_NG_CFLAGS)
  PHP_SUBST(MBSTRING_NG_SHARED_LIBADD)

  for dir in $PHP_MBSTRING_NG_EXTRA_BUILD_DIRS; do
    PHP_ADD_BUILD_DIR([$ext_builddir/$dir], 1)
  done
  
  for dir in $PHP_MBSTRING_NG_EXTRA_INCLUDES; do
    PHP_ADD_INCLUDE([$ext_srcdir/$dir])
    PHP_ADD_INCLUDE([$ext_builddir/$dir])
  done

  if test "$ext_shared" = "no"; then
    PHP_ADD_SOURCES(PHP_EXT_DIR(mbstring_ng), $PHP_MBSTRING_NG_BASE_SOURCES)
    out="php_config.h"
  else
    PHP_ADD_SOURCES_X(PHP_EXT_DIR(mbstring_ng),$PHP_MBSTRING_NG_BASE_SOURCES,,shared_objects_mbstring_ng,yes)
    if test -f "$ext_builddir/config.h.in"; then
      out="$abs_builddir/config.h"
    else
      out="php_config.h"
    fi
  fi
  
  for cfg in $PHP_MBSTRING_NG_EXTRA_CONFIG_HEADERS; do
    cat > $ext_builddir/$cfg <<EOF
#include "$out"
EOF
  done
  PHP_MBSTRING_NG_ADD_INSTALL_HEADERS([mbstring.h])
  PHP_INSTALL_HEADERS([ext/mbstring], [$PHP_MBSTRING_NG_INSTALL_HEADERS])
])

AC_DEFUN([PHP_MBSTRING_NG_SETUP_MBREGEX], [
  if test "$PHP_ONIG" = "yes" || test "$PHP_ONIG" = "no"; then
    dnl
    dnl Bundled oniguruma
    dnl
    if test "$PHP_MBREGEX_BACKTRACK" != "no"; then
      AC_DEFINE([USE_COMBINATION_EXPLOSION_CHECK],1,[whether to check multibyte regex backtrack])
    fi

    AC_CACHE_CHECK(for variable length prototypes and stdarg.h, cv_php_mbstring_stdarg, [
      AC_TRY_RUN([
#include <stdarg.h>
int foo(int x, ...) {
  va_list va;
  va_start(va, x);
  va_arg(va, int);
  va_arg(va, char *);
  va_arg(va, double);
  return 0;
}
int main() { return foo(10, "", 3.14); }
      ], [cv_php_mbstring_stdarg=yes], [cv_php_mbstring_stdarg=no], [
        dnl cross-compile needs something here
        case $host_alias in
        *netware*)
        cv_php_mbstring_stdarg=yes
        ;;
        *)
        cv_php_mbstring_stdarg=no
        ;;
        esac
      ])
    ])

    AC_CHECK_HEADERS([stdlib.h string.h strings.h unistd.h sys/time.h sys/times.h stdarg.h])
    AC_CHECK_SIZEOF(int, 4)
    AC_CHECK_SIZEOF(short, 2)
    AC_CHECK_SIZEOF(long, 4)
    AC_C_CONST
    AC_HEADER_TIME 
    AC_FUNC_ALLOCA
    AC_FUNC_MEMCMP
    AC_CHECK_HEADER([stdarg.h], [
      AC_DEFINE([HAVE_STDARG_PROTOTYPES], [1], [Define to 1 if you have the <stdarg.h> header file.])
    ], [])
    AC_DEFINE([PHP_ONIG_BUNDLED], [1], [Define to 1 if the bundled oniguruma is used])
    AC_DEFINE([HAVE_ONIG], [1], [Define to 1 if the oniguruma library is available]) 
    PHP_MBSTRING_NG_ADD_CFLAG([-DNOT_RUBY])
    PHP_MBSTRING_NG_ADD_BUILD_DIR([oniguruma])
    PHP_MBSTRING_NG_ADD_BUILD_DIR([oniguruma/enc])
    PHP_MBSTRING_NG_ADD_INCLUDE([oniguruma])
    PHP_MBSTRING_NG_ADD_CONFIG_HEADER([oniguruma/config.h])
    PHP_MBSTRING_NG_ADD_SOURCES([
      oniguruma/regcomp.c
      oniguruma/regerror.c
      oniguruma/regexec.c
      oniguruma/reggnu.c
      oniguruma/regparse.c
      oniguruma/regenc.c
      oniguruma/regext.c
      oniguruma/regsyntax.c
      oniguruma/regtrav.c
      oniguruma/regversion.c
      oniguruma/st.c
      oniguruma/enc/unicode.c
      oniguruma/enc/ascii.c
      oniguruma/enc/utf8.c
      oniguruma/enc/euc_jp.c
      oniguruma/enc/euc_tw.c
      oniguruma/enc/euc_kr.c
      oniguruma/enc/sjis.c
      oniguruma/enc/iso8859_1.c
      oniguruma/enc/iso8859_2.c
      oniguruma/enc/iso8859_3.c
      oniguruma/enc/iso8859_4.c
      oniguruma/enc/iso8859_5.c
      oniguruma/enc/iso8859_6.c
      oniguruma/enc/iso8859_7.c
      oniguruma/enc/iso8859_8.c
      oniguruma/enc/iso8859_9.c
      oniguruma/enc/iso8859_10.c
      oniguruma/enc/iso8859_11.c
      oniguruma/enc/iso8859_13.c
      oniguruma/enc/iso8859_14.c
      oniguruma/enc/iso8859_15.c
      oniguruma/enc/iso8859_16.c
      oniguruma/enc/koi8.c
      oniguruma/enc/koi8_r.c
      oniguruma/enc/big5.c
      oniguruma/enc/utf16_be.c
      oniguruma/enc/utf16_le.c
      oniguruma/enc/utf32_be.c
      oniguruma/enc/utf32_le.c
    ])
    PHP_MBSTRING_NG_ADD_INSTALL_HEADERS([oniguruma/oniguruma.h])
  else
    dnl
    dnl External oniguruma
    dnl
    if test ! -f "$PHP_ONIG/include/oniguruma.h"; then
      AC_MSG_ERROR([oniguruma.h not found in $PHP_ONIG/include])
    fi
    PHP_ADD_INCLUDE([$PHP_ONIG/include])

    PHP_CHECK_LIBRARY(onig, onig_init, [
      PHP_ADD_LIBRARY_WITH_PATH(onig, $PHP_ONIG/$PHP_LIBDIR, MBSTRING_NG_SHARED_LIBADD)
      AC_DEFINE([HAVE_ONIG], [1], [Define to 1 if the oniguruma library is available]) 
    ],[
      AC_MSG_ERROR([Problem with oniguruma. Please check config.log for more information.])
    ], [
      -L$PHP_ONIG/$PHP_LIBDIR
    ])

    save_old_LDFLAGS=$LDFLAGS
    PHP_EVAL_LIBLINE([$MBSTRING_NG_SHARED_LIBADD], LDFLAGS)
    AC_MSG_CHECKING([if oniguruma has an invalid entry for KOI8 encoding])
    AC_TRY_LINK([
#include <oniguruma.h>
    ], [
return (int)(ONIG_ENCODING_KOI8 + 1);
    ], [
      AC_MSG_RESULT([no])
    ], [
      AC_MSG_RESULT([yes])
      AC_DEFINE([PHP_ONIG_BAD_KOI8_ENTRY], [1], [define to 1 if oniguruma has an invalid entry for KOI8 encoding])
    ])
    LDFLAGS=$save_old_LDFLAGS
  fi

  PHP_MBSTRING_NG_ADD_CFLAG([-DONIG_ESCAPE_UCHAR_COLLISION=1])
  PHP_MBSTRING_NG_ADD_CFLAG([-DUChar=OnigUChar])

  AC_DEFINE([HAVE_MBREGEX], 1, [whether to have multibyte regex support])

  PHP_MBSTRING_NG_ADD_INSTALL_HEADERS([php_onig_compat.h])
])

dnl
dnl Main config
dnl

PHP_ARG_ENABLE(mbstring_ng, whether to enable multibyte string support,
[  --enable-mbstring-ng     Enable multibyte string support])

PHP_ARG_ENABLE([mbregex_backtrack], [whether to check multibyte regex backtrack],
[  --disable-mbregex-backtrack
                             MBSTRING: Disable multibyte regex backtrack check], yes, no)

PHP_ARG_WITH(libmbfl, [for external libmbfl],
[  --with-libmbfl[=DIR]      MBSTRING: Use external libmbfl.  DIR is the libmbfl base
                            install directory [BUNDLED]], no, no)

PHP_ARG_WITH(onig, [for external oniguruma],
[  --with-onig[=DIR]         MBSTRING: Use external oniguruma. DIR is the oniguruma install prefix.
                            If DIR is not set, the bundled oniguruma will be used], no, no)

if test "$PHP_MBSTRING" != "no"; then  
  AC_DEFINE([HAVE_MBSTRING_NG],1,[whether to have multibyte string support])

  PHP_MBSTRING_NG_ADD_BASE_SOURCES([mbstring.c])
  PHP_MBSTRING_NG_ADD_INSTALL_HEADERS([php_mbstring.h])

  PHP_MBSTRING_NG_SETUP_MBREGEX

  PHP_MBSTRING_NG_EXTENSION
fi

# vim600: sts=2 sw=2 et
