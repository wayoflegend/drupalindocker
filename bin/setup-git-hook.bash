#!/bin/sh

FILE=${PWD}/drupal/.git/hooks/pre-commit
if [ -f "$FILE" ]; then
    echo "$FILE exist."
else
    echo "hook pre_commit does not exist."
    ln -s ${PWD}/scripts/pre-commit $FILE
    chmod +x ${PWD}/scripts/pre-commit
    echo "hook pre_commit created."
fi
