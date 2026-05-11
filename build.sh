#!/usr/bin/env sh

sbcl --non-interactive \
    --eval '(asdf:load-system :cheth)' \
    --eval '(sb-ext:save-lisp-and-die "cheth"
              :toplevel #'"'"'cheth::run-noninteractive
              :executable t
              :compression t)'
