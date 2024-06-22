
Write-Host "latest commit id is $Env:fromCommitId"
Write-Host ""
#
#
# /repos/{owner}/{repo}/environments/{environment_name}/variables/{name}
#gh api \
#  --method PATCH \
#  -H "Accept: application/vnd.github+json" \
#  -H "Authorization: Bearer $personalToken" \
#  -H "X-GitHub-Api-Version: 2022-11-28" \
#  /repos/samark96/Actions/environments/prod/variables/fromCommitId \
#  -d '{"name":"fromCommitId","value":"'$fromCommitId'"}'