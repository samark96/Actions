
#$latestCommit = git log -1 --pretty=oneline
$latestCommitId = git log -n 1 --pretty=format:"%h" #$latestCommit.Substring(0, $latestCommit.IndexOf(' '))
Write-Host " "
Write-Host "Latest Commit Id is : $latestCommitId"
Write-Host ""
Write-Host "Last successful commit id is $env:fromCommitId"
Write-Host "latestCommitId=${latestCommitId}" >> $GITHUB_ENV