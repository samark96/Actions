git config --global --add safe.directory /__w/Actions/Actions
git config --global user.email "GitHub@mass.gov"
git config --global user.name "GitHub User"

$latestCommit = git log -1 --pretty=oneline
$latestCommitId = $latestCommit.Substring(0, $latestCommit.IndexOf(' '))
Write-Host " "
Write-Host "Latest Commit Id is : $latestCommitId"
Write-Host ""
Write-Host "Last successful commit id is $fromCommitId"
Write-Host "fromCommitId=${latestCommitId}" >> $GITHUB_ENV