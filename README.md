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

### build-image-info

The `build-image-info` script reads the output from `docker build` from
standard input and extracts basic information about the built image. It
supplements this information using the output from `docker inspect` and
various `git` commands. It writes the collected metadata to a file called
"*release_tag*-*timestamp*", where *release_tag* is the numeric semantic
version tag for the release and *timestamp* is the UTC image creation
time, in the format *YYYYmmdd*.*HHMMSS*Z.

The file contains "*parameter*=*value*" definitions, one per line:

<dl>
  <dt>IMAGE_NAME</dt><dd>The *release_tag*-*timestamp* name</dd>
  <dt>RELEASE_TAG</dt><dd>The release tag</dd>
  <dt>RELEASE_SHA1</dt><dd>The full sha1 hash of the current git commit</dd>
  <dt>REPO_OWNER</dt><dd>The username of the github repo owner</dd>
  <dt>REPO_NAME</dt><dd>The name of the github repo</dd>
  <dt>IMAGE_DIGEST</dt><dd>The sha256 digest of the image (starting with "sha256:")</dd>
  <dt>IMAGE_ID</dt><dd>The first 12 characters of the imageDigest</dd>
  <dt>IMAGE_CREATED</dt><dd>The ISO8601 creation time of the image</dd>
  <dt>BASE_TAG</dt><dd>The full (pullable) "tag name" of the base image</dd>
  <dt>BASE_DIGEST</dt><dd>The full (pullable) "digest name" of the base image</dd>
  <dt>BASE_REPO_OWNER</dt><dd>The username of the github repo owner of the base image project, if known (see docker-cibuild)</dd>
  <dt>BASE_REPO_NAME</dt><dd>The name of the github repo of the base image project, if known (see docker-cibuild)</dd>
  <dt>BASE_RELEASE_TAG</dt><dd>The release tag of the base image, if known (see docker-cibuild)</dd>
</dl>

The basename of the file is written to standard output. The file is intended to
be a "release asset". The name can also be used as a docker tag to uniquely
identify an unversioned image.

### check-base-image

The `check-base-image` script uses the labels in a docker image built by
`docker-build` to help determine whether an image's base has been updated
since it was built. Specifically, it checks whether the image identified
by the `base.tag` label is still the same as the image identified by the
`base.digest` label. This can be used to automate image rebuilds.

### docker-build

The `docker-build` script is a front-end to `docker build`. It supports all
the same options as `docker build`, but runs `docker build` in two passes.
The first pass caches the base image and all layers defined by the Dockerfile.
Information about the base image is extracted from the built image, and if
there is a .git directory, information about the release is gathered. The
second pass uses this information to supplement the final image with the
following labels:
<dl>
  <dt>base.id</dt><dd>the base image id</dd>
  <dt>base.digest</dt><dd>the base image digest</dd>
  <dt>base.tag</dt><dd>the base image tag</dd>
  <dt>git.remote.origin</dt><dd>the url of the git remote origin (e.g. git remote repo)</dd>
  <dt>git.tag.version</dt><dd>the latest version tag</dd>
  <dt>git.commit.sha1</dt><dd>the sha1 of the latest commit</dd>
</dl>

Note that this script needs to parse the command-line and recognize all valid
`docker build` arguments. To avoid breaking when `docker build` is updated,
is scans `docker build --help` output to build an argument map. Unfortunately,
this ~~hokey~~ sophisticated approach cannot guarantee that future docker
updates will not cause parsing failures. If this is a concern, consider using
`docker-cibuild` and `build-image-info` instead.

### docker-cibuild

The `docker-cibuild` script is a simple front-end to `docker build`. It passes
all command-line arguments straight through, but also adds the following:

`--label git.remote.origin=`*github_repo_url*

`--label git.commit.sha1`=*git_commit_hash*

`--label git.release.tag=`*git_release_tag* (if known)

### get-github-release-id

Retrieve the ID of the GitHub release object for a given repo and tag.

### get-git-version

The `get-git-version` script attempts to determine the best semantic version
string to use when building artifacts based on a git repository.

### list-github-release-assets

This script lists the names of all "assets" of a given github "release". If the
`GH_TOKEN` environment variable is set to a personal API Token that has write
repository access, a draft release can be queried; otherwise, only published
releases can be queried.

### normalize-gihub-release

Validate the indicated GitHub "release" object and make sure it conforms to
conventions used by the CICADA pipeline.

CICADA-friendly release objects have the following attributes:
  * The release name is a semantic version tag with no pre-release or metadata
    components; (e.g.: "1.0.1", but not "1.0.1-test", or "1.0.1+meta").
  * The associated tag is a valid semantic version string.
  * The release name matches the numeric portion of the tag.
  * The release is associated with a specific commit SHA (not a branch).
  * The "prerelease" flag is false if and only if the tag has no pre-release
    component.

### trigger-deployment

This script is meant to be run in a CircleCI job that is triggered when an
image metadata file is uploaded to a branch in the "sweg-deployments"
github repo.

### upload-github-release-asset

This script uploads a file to github as a "release asset" of a given
repository. It requires that the `GH_TOKEN` environment variable be set to a
Personal API Token that has full repository access.

### versions

The `versions` script sorts version numbers and optionally selects the most
recent one, or increments a component number in a valid version string.
Versions strings are read from standard input, and strings that do not look
like versions strings are ignored. One possible use is to pipe `git tag list`
into the script to find the latest version tag.




