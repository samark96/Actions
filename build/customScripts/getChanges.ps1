
#$latestCommit = git log -1 --pretty=oneline
$latestCommitId = git log -n 1 --pretty=format:"%h" #$latestCommit.Substring(0, $latestCommit.IndexOf(' '))
Write-Host " "
Write-Host "Latest Commit Id is : $latestCommitId"
Write-Host ""
Write-Host "Last successful commit id is $env:fromCommitId"
Write-Host ""

"latestCommitId=${latestCommitId}" >> $env:GITHUB_ENV

$diffs = New-Object System.Collections.ArrayList
foreach ($i in $(git diff --name-only $latestCommitId $env:fromCommitId)) { $diffs.add($i) > $null }
 
Write-Host "!!!!!!!Printing Support file changes / deletions!!!!!!!!!!!!!!!!!!!!!!"
$processedChanges = New-Object System.Collections.ArrayList
if ($diffs.Count -gt 0) {
        foreach ($k in $diffs) {
            if(($k | Select-String -Pattern 'force-app/main/default/') -and (Test-Path -LiteralPath $k)){
 
                $change = $k.replace('force-app/main/default/', '')
               
                If($change.Contains(".")){ $processedChanges.add($change) > $null
                } else { Write-Host "Just a folder : $change" }
               
            } else { Write-Host "Support file : $k" }
        }
} else { Write-Host "No file changes" }
Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
 
$processedChangesFilePath = "$HOME\build\processedChanges.txt"
if(($processedChanges.Count -gt 0) -and ($processedChanges.Where({ $_ -ne "" }))){
    $processedChanges |  Out-File $processedChangesFilePath
 
    Write-Host "!!!!!!!!!!! File Path in Processed Changes File !!!!!!!!!!!!!!!!!!"
    Get-Content -Path $processedChangesFilePath
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}
 
#Extract Specified Test Classes
$xPath = $HOME
$path = "$xPath\force-app\main\default"
$testClasses = New-Object System.Collections.ArrayList
if(($processedChanges.Count -gt 0) -and ($processedChanges.Where({ $_ -ne "" }))){
    foreach($relativePath in $processedChanges)
    {    
        if($relativePath.StartsWith('classes'))
        {
            $fileName = $relativePath.Replace("classes/","")
            $indexOfChar = $fileName.IndexOf(".")
            $fileExtension = $fileName.Substring($indexOfChar,$fileName.Length-$indexOfChar)
            if($fileName.EndsWith('.cls') -or ($fileName.EndsWith('.cls-meta.xml')))
            {
                $baseName = $fileName.Replace('.cls-meta.xml','').Replace('.cls','')
                $filePath = $path+"\classes\"+$baseName+$fileExtension
                if(Test-Path $filePath)
                {
                    if($baseName -notin $testClasses)
                    {          
                        $testClasses.Add($baseName) > $null
                    }
                }
            }
        }
        elseif($relativePath.StartsWith('triggers'))
        {
            $fileName = $relativePath.Replace("triggers/","")
            $indexOfChar = $fileName.IndexOf(".")
            $fileExtension = $fileName.Substring($indexOfChar,$fileName.Length-$indexOfChar)
            if($fileName.EndsWith('.trigger') -or ($fileName.EndsWith('.trigger-meta.xml')))
            {
                $baseName = $fileName.Replace('.trigger-meta.xml','').Replace('.trigger','')
                $filePath = $path+"\triggers\"+$baseName+$fileExtension
                if(Test-Path $filePath)
                {
                    if($baseName -notin $testClasses)
                    {           
                        $testClasses.Add($baseName) > $null
                    }
                }
            }
        }
        else {
            #Write-Host "No Classes / Triggers found in the processed changes."
        }
    }
 
    $specifiedClass = New-Object System.Collections.ArrayList
    $specifiedClasses = New-Object System.Collections.ArrayList
    if(($testClasses.Count -gt 0) -and ($testClasses.Where({ $_ -ne "" }))){
        $getClassMap = Get-Content "$xPath\utils\testClassMapping.json" -Raw | ConvertFrom-Json
        $appName = "force-app"
 
        #Validate test class mapping json
        Write-Host "Validating test class mapping json started."
        foreach ($component in $getClassMap.$appName.PSObject.Properties) {
            $n = $component.Name
            $classCheck = "$path\classes\$n.cls"
            $triggerCheck = "$path\triggers\$n.trigger"
            if (Test-Path -LiteralPath $classCheck) {
                #write-host "valid class : $classCheck"
            }
            elseif (Test-Path -LiteralPath $triggerCheck){
                #write-host "valid trigger : $triggerCheck"
            }
            else {
                write-host " Invalid class / trigger. No Test class file found or Correct $n in testClassMapping.json"
                EXIT 1
            }
 
            $v = $component.value
            foreach ($val in ($v -split "," | Select-Object -Unique)){
                if($val -ne "skip" -and $val -ne "?" -and $val -ne ""){
                    $testClassCheck = "$path\classes\$val.cls"
                    $trigCheck = "$path\triggers\$val.trigger"
                    if (Test-Path -LiteralPath $testClassCheck) {
                        #write-host "valid class : $testClassCheck"
                    }
                    elseif (Test-Path -LiteralPath $trigCheck){
                        #write-host "valid trigger : $trigCheck"
                    }
                   else {
                        write-host " Invalid test class. No Test class file found or Correct $val in testClassMapping.json"
                        EXIT 1
                    }
                }
            }
        }
        Write-Host "Validating test class mapping json complete."
 
        $testClassList = New-Object System.Collections.ArrayList
        foreach ($class in $testClasses) { 
            
            foreach ($className in $getClassMap.$appName.PSObject.Properties) {
 
                if ($className.value -ne "" -or $className -ne "skip"){
 
                    if ($class -eq $($className.Name)) {
                            $testClassList = $($className.value)
                            $specifiedClass.Add($testClassList) > $null
                    }
                }
            }
        }
        $items = $specifiedClass -join ',' | ForEach-Object { $_.Split(',')}
        $uniqueItems = $items | Select-Object -Unique
        $specifiedClasses = $uniqueItems -join ','
    }
    $testClassFilePath = "$HOME\build\specifyTestClasses.txt"
    if(($specifiedClasses.Count -gt 0) -and ($specifiedClasses.Where({ $_ -ne "" }))){
        $specifiedClasses |  Out-File $testClassFilePath -Encoding UTF8
    } else {
        "skip" | Set-Content -Path $testClassFilePath -Encoding UTF8
    }
    Write-Host "!!!!!!!!!!! Specified Test Classes !!!!!!!!!!!!!!!!!!"
    Get-Content -Path $testClassFilePath
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}