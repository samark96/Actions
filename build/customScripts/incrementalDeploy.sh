#! /bin/bash

latestCommit=$(git log -n 1 --pretty=format:"%h" | tail -n 1 2>&1)
echo ""
echo "latest commit is $latestCommit"
echo ""
echo "Last successful commit id is $fromCommitId"
echo "fromCommitId=$(echo $latestCommit | cut -c 1-6)" >> $GITHUB_ENV
echo "Last successful commit id is $fromCommitId"