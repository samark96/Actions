param(
    [string]$commitId
)
Write-Host "latest commit id is $commitId"

gh variable set fromCommitId=$commitId --env prod
#gh api \
#  -H "Accept: application/vnd.github+json" \
#  -H "Authorization: Bearer $personalToken" \
#  -H "X-GitHub-Api-Version: 2022-11-28" \
#  -d '{"name":"fromCommitId","value":"'$commitId'"}'