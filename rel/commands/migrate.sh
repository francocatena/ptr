#!/bin/sh

release_ctl eval --mfa "Ptr.Tasks.Release.migrate/1" --argv -- "$@"
