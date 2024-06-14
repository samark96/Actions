#! /bin/bash

echo "latest commit id is $latestCommitId"
echo "latest commit id is $fromCommitId"
echo ""
#curl -X PUT -u $bitbucketUserName:$bitbucketPassword "https://api.bitbucket.org/2.0/repositories/$BITBUCKET_WORKSPACE/$BITBUCKET_REPO_SLUG/deployments_config/environments/\{$envUUID\}/variables/\{$varUUID\}" -H 'Content-Type:application/json' -d '{"value":"'$latestCommit'","key":"fromCommit"}'