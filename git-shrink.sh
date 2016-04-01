#!/bin/sh

git filter-branch -f -d /dev/shm/scratch  --index-filter "git rm -rf --cached --ignore-unmatch '*.tar.xz'; \
git rm --cached -rf --ignore-unmatch '*.tar.gz'; \
git rm --cached -rf --ignore-unmatch '*.tar.bz2'; \
git rm --cached -rf --ignore-unmatch '*.zip'; \
git rm --cached -rf --ignore-unmatch '*.xz'; \
git rm --cached -rf --ignore-unmatch '*.srpm'; \
git rm --cached -rf --ignore-unmatch '*.rpm'" --prune-empty -- --all
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git fsck --full --unreachable
git repack -A -d
git gc --aggressive --prune=now
git push --force

echo "done"
