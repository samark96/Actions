#! /bin/bash
git config --global --add safe.directory /__w/Actions/Actions
git config --global user.email "GitHub@mass.gov"
git config --global user.name "GitHub User"
latestCommitId=$(git log -n 1 --pretty=format:"%h" | tail -n 1 2>&1)
echo ""
echo "latest commit id is $latestCommitId"
echo ""
echo "Last successful commit id is $fromCommitId"

sfdx plugins --core 
echo ""
sfdx sgd:source:delta --to ${latestCommitId} --from ${fromCommitId} --output "."
echo ""
echo ""
echo "--- package.xml generated with added and modified metadata ---"
echo "--- Validate changes in the following package.xml thats deployed ---"
echo ""
echo ""
cat package/package.xml
echo ""
echo ""
echo ""
echo ""
mkdir ./changed-sources
sfdx sgd:source:delta --to ${latestCommitId} --from ${fromCommitId} --output changed-sources/ --generate-delta
echo "fromCommitId=${latestCommitId}" >> $GITHUB_ENV