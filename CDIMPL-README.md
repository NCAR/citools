# The CDIMPL API

Some of the Circle-CI-related scripts in the CITools package make use of the
`CDIMPL` environment variable. This variable identifies a script with the
following usage:

   `${CDIMPL} init`
   `${CDIMPL} register-image-metadata <metadata_file>`
   `${CDIMPL} get-image-metadata <metadata_file>`
   `${CDIMPL} request-deployment-approval`
   `${CDIMPL} register-deployment`

Every such script is assumed to act as an adapter to a "Continuous Deployment"
software package. Different software packages or even different versions
of a software package can be easily deployed by implementing new adapter
scripts and pointing CDIMPL at them.

The `init` subcommand is expected to initialize the CD implementation using
only available environment variables. Any state that must be preserved between
jobs should be written to the $STATEDIR directory. Any special software should
be installed to the $LOCAL_BIN directory. Definitions for any environment
variables that should be available to "`run`" job steps can be appended to
the $INIT_RC file; in particular, `init` is expected to add at least the
following commands or their equivalents to $INIT_RC:
    TRIGGER_TYPE=*trigger_type* export TRIGGER_TYPE
    DEPLOY_ENV=*deploy_env* export DEPLOY_ENV
where *trigger_type* is `manual` or `automatic`, and *deploy_env* is the name
of the target deployment environment.

The `register-image-metadata` requires an argument: the name of an image
metadata file (presumably created by `docker-cibuild`). The script is expected
to "register" the metadata file with the CD implementation, so that subsequent
jobs that operate on the *same* git release can retrieve the image's unique
tag.

The `get-image-metadata` subcommand is expected to write to the named file
the image metadata previously associated with the current git release
using `register-image-metadata`. Note that the metadata file is expected to
contain an attribute called "IMAGE_TAG" that uniquely identifies the image in
its repository with the. See `docker-cibuild`.

The `request-deployment-approval` subcommand is expected to check whether
the current image is authorized for deployment; it should return 0 if the
deployment is approved or 1 otherwise. It should also print explanatory
messages to standard output.

The `register-deployment` subcommand is expected to inform the CD implementor
of a successful deployment, and possibly trigger follow-up actions.
