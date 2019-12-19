# cool production release pull requests

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
