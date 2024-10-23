#!/bin/bash
# this script automates git add, commit, push and tag for bn.sh
# Benjamin Bloomfield, McMaster University, October 22, 2024.

git add bn.sh

# checks if at least one argument (commit message) is provided
if [[ $# -ge 1 ]]
then
        # commit using the argument as the message, and push the commit
        git commit -m "$1"
        git push origin main

        # checks to see if two arguments (commit message and tag) are provided
        if [[ $# -eq 2 ]]
        then
                # tag, and push the tag
                git tag $2
                git push origin $2
        fi
else
        echo "After calling the script, please enter <commit message (with quotes)> <tag name>"
        exit 1
