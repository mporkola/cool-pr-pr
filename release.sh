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

git checkout -b "production-update-$date"

cat "$tmpfile"

rm "$tmpfile"