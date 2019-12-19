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

tmpfile=$(mktemp /tmp/turbo-release.XXXXXX)
echo "$tmpfile"
# exec 3<>"$tmpfile"
# rm "$tmpfile"
echo "$release_msg" >> "$tmpfile"

$EDITOR "$tmpfile"

# echo "this is the edited thing"
# echo "########################"
# cat "$tmpfile"

edited_msg=$(<$tmpfile)

# cat $PWD/CHANGELOG.md

# echo "making changes to changelog"
# echo "###########################\n"

# # use sponge? https://linux.die.net/man/1/sponge
# perl -pe "s/\n## Production/\n$edited_msg\n\n## Production/g" < "$PWD/CHANGELOG.md"

# https://hub.github.com/

date=$(date '+%Y-%m-%d')

branch_name_orig="production-update-$date"
branch_name=$branch_name_orig
remote_matches=$(git branch | grep "$branch_name" | wc -l)
ordinal=0

until [ $remote_matches -eq 0 ]
do
  let ordinal=ordinal+1
  branch_name="$branch_name_orig-$ordinal"
  remote_matches=$(git branch | grep "$branch_name" | wc -l)
done

git checkout -b "$branch_name"

git push --set-upstream origin "$branch_name"

cat "$tmpfile"

rm "$tmpfile"