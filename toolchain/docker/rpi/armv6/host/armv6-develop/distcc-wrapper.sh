#!/bin/bash

# The first argument is the compiler: 
# strip the full path from it, and pass it to distcc.
# Forward all other arguments.

distcc $(basename $1) "${@:2}"