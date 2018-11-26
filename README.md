# CiTools

This project contains portable scripts to assist in Continuous Integration.
Contributions to the project should be written using basic Bourne shell
syntax and use only universally available secondary tools  (e.g. sed, awk)
so that the scripts remain as portable as possible.

The current focus of the project is to make automated builds and deployments
easy and consistent.

All scripts must support "-h" and "--help" command-line flags for displaying
help, and all scripts should support a "--version" command-line flag for
displaying the version of the script. Scripts which support a "verbose"
mode should enable it if the CITOOLS_VERBOSE environment variable is set and
not empty.

## The Scripts

### check-base-image

The `check-base-image` script uses the labels in a docker image built by
`docker-build` to help determine whether an image's base has been updated
since it was built. Specifically, it checks whether the image identified
by the `base.tag` label is still the same as the image identified by the
`base.digest` label. This can be used to automate image rebuilds.

### cicada-*command*

Scripts supporting the CICADA deployment framework, which combines featires of
GitHub and CircleCI to automate building and deploying docker continers. Refer
to the CICADA GitHub repo for more information.

The following scripts are meant to be run from the CircleCI configuration of
a managed project:
<dl>
  <dt>cicada-init</dt>
  <dd>
    Initialize the CircleCI workspace for CICADA.
  </dd>
  <dt>cicada-build-push</dt>
  <dd>
    Ensure that a docker image for the current git release exists in a target
    registry; build and push the image if it does not.
  </dd>
  <dt>cicada-verify-approval</dt>
  <dd>
    Verify that the target docker image has been authorized for deployment to
    the indicated environment.
  </dd>
  <dt>cicada-deploy</dt>
  <dd>
    Pull, tag, and push the target docker image to the indicated environment.
  </dd>
</dl>

The following scripts are lower-level support scripts:
<dl>
  <dt>cicada-image-tag</dt>
  <dd>
    Handle uploading and listing GitHub "release assets", which map release
    tags to images.
  </dd>
  <dt>cicada-log</dt>
  <dd>
    Read/write CICADA logs on the CICADA master branch.
  </dd>
</dl>
#### 

#### cicada-build-push

#### cicada-trigger-deployment
Ensure that a docker image for the current git release exists in a target
registry; build and push the image if it does not.

### circle-docker-login-init

Retrieve and cache a `docker login` command for either dockerhub or AWS ECR.
This is meant to be used in CircleCI jobs.

### circle-env

Either write environment variable definitions to a given file for various
CircleCI/citools variables, or verify that the same variables are defined in
the environment. In write mode, the script is used to initialize a workspace
"rc" file for use by subsequent job steps. In verification mode, the script
is used in other scripts to ensure the environment is initialized. The
environment variables written/verified are: `DEFAULT_ENVIRONMENT`,
`DEPLOYMENT_FRAMEWORK `, `WORKSPACE`, `INIT_RC`, `LOCAL_BIN`,
`PRERELEASE_ENVIRONMENTS`, `PRODUCTION_ENVIRONMENT`, `SEMVER`, and `STATEDIR`.

### circle-install-tools

Install miscellaneous tools that might be needed in CircleCI job steps.

### circle-post

Submit a POST request to CircleCI using its API.

### circle-printenv

Dump out all environment variables, but try to hide sensitive values.

### circle-workspace-init

Initializes the "workspace" at the start of a CircleCI workflow. This calls
`circle-env`, `circle-install-tools`, and `circle-docker-login-init`.

### deployment-env

Return information about deployment environment names. The script
defines default deployment environment names, but these can be
overridden via environment variables.

### docker-build

The `docker-build` script is a front-end to `docker build`. It supports all
the same options as `docker build`, but runs `docker build` in two passes.
The first pass runs via `docker-cibuild`, which collects metadata about the
image. The second pass uses this metadata to supplement the final image with
the following labels:
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
`docker-cibuild` instead.

### docker-cibuild

The `docker-cibuild` script is a front-end to `docker build` that collects
and prints out metadata about the build image. It passes all command-line
arguments straight through to docker-build, except for `--metadata=`*file*,
which specifies the name of the metadata file. In addition, it adds the
following labels to the image:

`--label git.remote.origin=`*github_repo_url*

`--label git.revision.sha1`=*git_commit_hash*

`--label version=`*git_release_tag* (if known)

Note that this script requires that the `-q` / `--quiet` option **not** be
passed as an argument.

### docker-tag-push

Easily apply multiple tags to a docker image and push the image to a remote
registry.

### get-git-version

The `get-git-version` script attempts to determine the best semantic version
string to use when building artifacts based on a git repository.

### github-get

Submit a GET request to GitHub using its API.

### github-patch

Submit a PATCH request to GitHub using its API.

### parse-semver

This script parses a given supposed semantic version string and writes
one or more of the components to standard output.

### sw-manifest

Print a list of installed software on a linux host.

### versions

The `versions` script sorts version numbers and optionally selects the most
recent one, or increments a component number in a valid version string.
Versions strings are read from standard input, and strings that do not look
like versions strings are ignored. One possible use is to pipe `git tag list`
into the script to find the latest version tag.

## Tips for Script Writers

Refer to the `script-template` file to see how scripts should start.




