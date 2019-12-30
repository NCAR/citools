#!/bin/sh
TESTDIR=`cd \`dirname $0\`; pwd`
TESTLIBDIR="${TESTDIR}/../testlib"
. ${TESTLIBDIR}/init.rc

DEFINE_TEST "when no-args, error"
RUN versions
if gotExpectedOutput --error --contains " is required" ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when no mode-settingn-args, error"
RUN versions -n
if gotExpectedOutput --error --contains " is required" ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when -lc, error"
RUN versions -lc
if gotExpectedOutput --error --contains " is allowed" ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when -ci, error"
RUN versions -ci
if gotExpectedOutput --error --contains " is allowed" ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when -il, error"
RUN versions -il
if gotExpectedOutput --error --contains " is allowed" ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when -cil, error"
RUN versions -il
if gotExpectedOutput --error --contains " is allowed" ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when -i with bad -f arg, error"
RUN versions -i -fbad
if gotExpectedOutput --error --contains " must be one of" ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when -f arg without -i, error"
RUN versions -l -fmajor
if gotExpectedOutput --error --contains "is only valid with" ; then
    SUCCESS
else
    FAILURE
fi

cat <<EOF >${TMPDIR}/versions-bad.list
bad
1.0
anotherbad
EOF

DEFINE_TEST "when input contains invalid version, bad version ignored"
RUN versions -l <${TMPDIR}/versions-bad.list
if gotExpectedOutput --exact "1.0" ; then
    SUCCESS
else
    FAILURE
fi

cat <<EOF >${TMPDIR}/versions-blanks.list

1.0

EOF
DEFINE_TEST "when input contains empty lines, empty lines ignored"
RUN versions -l <${TMPDIR}/versions-blanks.list
if gotExpectedOutput --exact "1.0" ; then
    SUCCESS
else
    FAILURE
fi

cat <<EOF >${TMPDIR}/versions-leadv.list
v1.0
EOF
DEFINE_TEST "when input version starts with v, v ignored"
RUN versions -l <${TMPDIR}/versions-blanks.list
if gotExpectedOutput --exact "1.0" ; then
    SUCCESS
else
    FAILURE
fi

cat <<EOF >${TMPDIR}/versions-unsorted.list
v1.0
v1.1.0
1.1.2
2.1.1
2.1.2
2.0.0
2.1
EOF

DEFINE_TEST "when input version contains unsorted versions, output sorted"
RUN versions -l <${TMPDIR}/versions-unsorted.list
if gotExpectedOutput --exact 'v1.0
v1.1.0
1.1.2
2.0.0
2.1
2.1.1
2.1.2' ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when input version contains unsorted versions, -c returns latest"
RUN versions -c <${TMPDIR}/versions-unsorted.list
if gotExpectedOutput --exact '2.1.2' ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when input version contains versions, -i returns latest incremented"
RUN versions -i <${TMPDIR}/versions-unsorted.list
if gotExpectedOutput --exact '2.1.3' ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when -i used with -f major, first component incremented"
RUN versions -i -fma <${TMPDIR}/versions-unsorted.list
if gotExpectedOutput --exact '3.0.0' ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when -i used with -f minor, second component incremented"
RUN versions -i -fmi <${TMPDIR}/versions-unsorted.list
if gotExpectedOutput --exact '2.2.0' ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when -i used with -f patch, third component incremented"
RUN versions -i -fp <${TMPDIR}/versions-unsorted.list
if gotExpectedOutput --exact '2.1.3' ; then
    SUCCESS
else
    FAILURE
fi

cat <<EOF >${TMPDIR}/versions-prerelease.list
1.0
1.0-beta
1.0-alpha
EOF

DEFINE_TEST "Given versions with pre-release component, pre-release is handled"
RUN versions -l <${TMPDIR}/versions-prerelease.list
if gotExpectedOutput --exact '1.0-alpha
1.0-beta
1.0' ; then
    SUCCESS
else
    FAILURE
fi

cat <<EOF >${TMPDIR}/versions-full.list
1.0+2
1.0
1.0+1
1.0-beta
1.0-alpha
EOF

DEFINE_TEST "Given versions with pre-release and metadata, versions are handled"
RUN versions -l <${TMPDIR}/versions-full.list
if gotExpectedOutput --exact '1.0-alpha
1.0-beta
1.0+2
1.0
1.0+1' ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "Given versions with pre-release and metadata, versions -c include meta"
RUN versions -c <${TMPDIR}/versions-full.list
if gotExpectedOutput --exact '1.0+1' ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "Given versions with pre-release and metadata, versions -cn ignores meta"
RUN versions -cn <${TMPDIR}/versions-full.list
if gotExpectedOutput --exact '1.0' ; then
    SUCCESS
else
    FAILURE
fi

. cleanup.rc
