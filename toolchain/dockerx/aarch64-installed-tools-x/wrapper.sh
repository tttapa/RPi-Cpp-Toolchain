#!/bin/bash

distcc $(basename $1) "${@:2}"