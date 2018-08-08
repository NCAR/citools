# CiTools

This project contains portable scripts to assist in Continuous Integration.
Contributions to the project should be written using basic Bourne shell syntax
and use only universally available secondary tools  (e.g. sed, awk) so that
the scripts remain as portable as possible.

The current focus of the project is to make automated builds and deployments
easy and consistent.

All scripts must support "-h" and "--help" command-line flags for displaying
help, and all scripts should support a "--version" command-line flag for
displaying the version of the script.

## The Scripts

### docker-build

The `docker-build` script is a front-end to `docker build`. It supports all
the same options as `docker build`, but runs `docker build` twice. The first
time, quiet mode is disabled, the output is analyzed to identify the base
image, and the base image and new layers are cached. In the second run, which
uses the cache, labels are added to identify the base image digest and id.
These labels can be used subsequently to determine whether the base image tag
has been assigned to a new image, and/or to rebuild the target with exactly
the same base image. The second `docker build` also includes a label

### versions

The `versions` script sorts version numbers and optionally selects the most
recent one, or increments a component number in a valid version string.
Versions strings are read from standard input, and strings that do not look
like versions strings are ignored. One possible use is to pipe `git tag list`
into the script to find the latest version tag.




