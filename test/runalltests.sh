#!/bin/sh
TESTS="
  test-parse-semver.sh
  test-versions.sh
"
TESTDIR=`cd \`dirname $0\`; pwd`

nfailed=0
for t in ${TESTS} ; do
    echo "Running $t..."
    $TESTDIR/$t
    rc=$?
    if [ $rc -gt 128 ] ; then
        rc=1
    fi
    nfailed=`expr $nfailed + $rc`
    echo
done
exit $nfailed
