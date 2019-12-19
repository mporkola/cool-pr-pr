# cool production release pull requests

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

Simple script to facilitate production releases.

What it does:
 - Creates a pretty list of merged PR:s and ninja-commits to master
 - Creates a production release branch named `production-release-DATE-[RUNNING-INDEX]` and pushes it
 - Creates a PR from the production release branch to `production`, with the aforementioned list as description

What it doesn't do yet:
 - Prepend the PR description to CHANGELOG.md (there's an ugly 0.0.1 of that commented out in code)
 - Customization

Assumptions:
 - Production lives in branch called `production`
 - You want the current local `master` to go to production
 - Prerequisites: [GitHub CLI](https://hub.github.com/)

How to use:
 - have this repo cloned somewhere (yes it's not very polished), in this example it's in `/codez/cool-pr-pr`
 - be in your own repo
 - make sure your local `master` is the thing you want to release
 - run `/codez/cool-pr-pr/release.sh`
 - edit the proposed PR description to your liking
 - done! the link to your brand new PR PR is printed for you, have fun
