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
the same options as `docker build`, but runs `docker build` in two passes.
The first pass caches the base image and all layers defined by the Dockerfile.
Information about the base image is extracted from the built image, and if
there is a .git directory, information about the release is gathered. The
second pass uses this information to supplement the final image with the
following labels:
  base.id           - the base image id
  base.digest       - the base image digest
  base.tag          - the base image tag
  git.remote.origin - the url of the git remote origin (e.g. git remote repo)
  git.tag.version   - the latest version tag
  git.commit.sha1   - the sha1 of the latest commit

### versions

The `versions` script sorts version numbers and optionally selects the most
recent one, or increments a component number in a valid version string.
Versions strings are read from standard input, and strings that do not look
like versions strings are ignored. One possible use is to pipe `git tag list`
into the script to find the latest version tag.




