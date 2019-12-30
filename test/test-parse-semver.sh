#!/bin/sh
TESTDIR=`cd \`dirname $0\`; pwd`
TESTLIBDIR="${TESTDIR}/../testlib"
. ${TESTLIBDIR}/init.rc


DEFINE_TEST "when no args, error"
RUN parse-semver
if gotExpectedOutput --error --contains 'version string argument is required' ; then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when bad version string, no output, retval non-zero"
RUN parse-semver foobar
if noOutput && noOutput --error && gotExpectedOutput --retval --regex '^[^0]'
then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when good version string, no opts, no output, retval zero"
RUN parse-semver 1.0.0
if noOutput && noOutput --error && gotExpectedOutput --retval --exact '0'
then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when good version string, -i, output input string"
RUN parse-semver -i v1.0.0-alpha+test
if gotExpectedOutput --exact 'v1.0.0-alpha+test'
then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when good version string, -n, output numeric portion"
RUN parse-semver -n v1.0.0-alpha+test
if gotExpectedOutput --exact '1.0.0'
then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when good version string, -p, output prerelease"
RUN parse-semver -p v1.0.0-alpha+test
if gotExpectedOutput --exact -- '-alpha'
then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when good version string, -m, output metadata"
RUN parse-semver -m v1.0.0-alpha+test
if gotExpectedOutput --exact '+test'
then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when good version string, -v, output separate numerics"
RUN parse-semver -v v1.0.0-alpha+test
if gotExpectedOutput --exact '1.0.0 1.0 1'
then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when good version string, all opts, output multiple fields"
RUN parse-semver -inpmv v1.0.0-alpha+test
if gotExpectedOutput --exact 'v1.0.0-alpha+test 1.0.0-alpha+test 1.0.0 1.0 1'
then
    SUCCESS
else
    FAILURE
fi

DEFINE_TEST "when simple version string, all opts, output numerics"
RUN parse-semver -inpmv 1.0.0
if gotExpectedOutput --exact '1.0.0 1.0.0 1.0.0 1.0 1'
then
    SUCCESS
else
    FAILURE
fi


. cleanup.rc
