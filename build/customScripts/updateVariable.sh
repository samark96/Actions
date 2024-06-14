#! /bin/bash

echo "latest commit id is $fromCommitId"
echo ""
#
#
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $personalToken" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/samark96/Actions/environments/prod/variables/fromCommitId \
  -d '{"name":"fromCommitId","value":"'$fromCommitId'"}'