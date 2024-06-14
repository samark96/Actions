#! /bin/bash

latestCommitId=$(git log -n 1 --pretty=format:"%h" | tail -n 1 2>&1)
echo ""
echo "latest commit id is $latestCommitId"
echo ""
echo "Last successful commit id is $fromCommitId"
echo "fromCommitId=${latestCommitId}" >> $GITHUB_ENV