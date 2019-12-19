#!/usr/bin/env bash

set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT

hub --version | grep hub >/dev/null 2>&1 || { echo >&2 "Pls install Github CLI from https://hub.github.com/. Aborting."; exit 1; }

hub fetch

release_msg=$(git log --first-parent origin/production..origin/master --pretty=format:"% -%C(yellow)%d%Creset %C(green)% %s %Creset% %b %C(bold blue)(%cr by %an) %Creset" | perl -pe 's/Merge pull request (#\S+) from \S+/PR $1/g')
# matches the branch descriptors to remove: ^- (\(origin.*?\))

tmpfile=$(mktemp /tmp/release-script.XXXXXX)
echo "$release_msg" >> "$tmpfile"

$EDITOR "$tmpfile"

edited_msg=$(<$tmpfile)

# cat $PWD/CHANGELOG.md

# echo "making changes to changelog"
# echo "###########################\n"

# # use sponge? https://linux.die.net/man/1/sponge
# perl -pe "s/\n## Production/\n$edited_msg\n\n## Production/g" < "$PWD/CHANGELOG.md"

# https://hub.github.com/

date=$(date '+%Y-%m-%d')

suffix=$date
branch_name="production-update-$suffix"
remote_matches=$(git branch | grep "$branch_name" | wc -l)
ordinal=0

until [ $remote_matches -eq 0 ]
do
  let ordinal=ordinal+1
  suffix="$date-$ordinal"
  branch_name="production-update-$suffix"
  remote_matches=$(git branch | grep "$branch_name" | wc -l)
done

git checkout -b "$branch_name"

git push --set-upstream origin "$branch_name"

pr_message="Production update ${suffix}

${edited_msg}"

hub pull-request -m "$pr_message" -b production
