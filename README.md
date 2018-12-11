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
not empty. See the `vecho` script.

You can see a list of all current scripts and their help documentation on the
[wiki](https://github.com/NCAR/citools/wiki).

## Tips for Script Writers

Refer to the `script-template` file to see how scripts should start. If
a script sources `citool-basics.rc`, consistent -h|--help/--verbose behavior
is greatly simplified, and PATH is modified to include the script's own
directory.
