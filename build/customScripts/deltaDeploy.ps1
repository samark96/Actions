
#$latestCommit = git log -1 --pretty=oneline
$latestCommitId = git log -n 1 --pretty=format:"%h" #$latestCommit.Substring(0, $latestCommit.IndexOf(' '))
Write-Host " "
Write-Host "Latest Commit Id is : $latestCommitId"
Write-Host ""
Write-Host "Last successful commit id is $env:fromCommitId"
"latestCommitId=${latestCommitId}" >> $env:GITHUB_ENV

$fromCommit = $env:fromCommitId
Write-Host "Base Commit Id is		    : $fromCommit"

#Get changes by passing two commit Ids
$diffs = New-Object System.Collections.ArrayList
foreach ($i in $(git diff --name-only $toCommit $fromCommit)) { $diffs.add($i) > $null }

Write-Host " "
Write-Host "!!!!!!!!!!!Printing Support or deleted file changes!!!!!!!!!!!!!!!!!!"

$processedChanges = New-Object System.Collections.ArrayList

if ($diffs.Count -gt 0) {
        foreach ($k in $diffs) {
            if(($k | Select-String -Pattern 'force-app/main/default/') -and (Test-Path -LiteralPath $k)){

				$change = $k.replace('force-app/main/default/', '')
				
				If($change.Contains(".")){ $processedChanges.add($change) > $null 
				} else { Write-Host "Just a folder : $change" }
				
            } else { Write-Host "Support file or deleted file: $k" }
        }
} else { Write-Host "No file changes" }
Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
Write-Host " "

$processedChangesFilePath = ".\build\processedChanges.txt"

 if(($processedChanges.Count -gt 0) -and ($processedChanges.Where({ $_ -ne "" }))){
	$processedChanges |  Out-File $processedChangesFilePath

    Write-Host "!!!!!!!!!!! File Path in Processed Changes File !!!!!!!!!!!!!!!!!!"
    Write-Host " "
    Get-Content -Path $processedChangesFilePath
    Write-Host " "
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
 }