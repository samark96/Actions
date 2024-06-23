
$xPath = "."
$processedChangesFilePath = "$xPath\build\processedChanges.txt"
$processedChanges = New-Object System.Collections.ArrayList

if(Test-Path -LiteralPath $processedChangesFilePath){
	$processedChanges = Get-Content -Path $processedChangesFilePath
	Write-Host "Processed Changes : $processedChanges"
} else { Write-Host "No file changes" }

if(($processedChanges.Count -gt 0) -and ($processedChanges.Where({ $_ -ne "" }))){
	
	$targetPath = "$xPath\build\target-app"
	$directory = new-item -type directory -path $targetPath -Force

	foreach($relativePath in $processedChanges) {
		Write-Host "relativePath : $relativePath"
		$path = $relativePath | Split-Path
		$folders = $path.Split('\')
		$index = $relativePath.LastIndexOf('/') + 1
		$fileName = $relativePath.Substring($index,$relativePath.Length-$index)
		foreach($folder in $folders) {   

			if(Test-Path $targetPath -PathType Container ){
				new-item -type directory -path $targetPath -name $folder -Force > $null
                Write-Host "$folder folder created"
				$targetPath = $targetPath+'\'+$folder
			}
		}

		$srcPath = $targetPath.Replace("build\target-app","force-app\main\default")
		$destinationPath = $targetPath
		$srcPath1 = $srcPath+"\"+$fileName
		$destinationPath1 = $destinationPath+"\"+$fileName
		if(Test-Path -LiteralPath $srcPath1){
			Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Force > $null
		}
		$srcPath2 = $srcPath1+"-meta.xml"
		$destinationPath2 = $destinationPath1+"-meta.xml"
		if(Test-Path -LiteralPath $srcPath2){
			Copy-Item -Path $srcPath2 -Destination $destinationPath2 -Force > $null
		}
		if($srcPath.Contains("aura")){
			if(Test-Path $srcPath -PathType Container){
				$srcPath = $srcPath+"\*"
				$destinationPath = $destinationPath 
				Copy-Item -Path $srcPath -Destination $destinationPath -Force > $null
			}
		}
		elseif($srcPath.Contains("lwc")){
			if(Test-Path $srcPath -PathType Container){
				$srcPath = $srcPath+"\*"
				$destinationPath = $destinationPath 
				Copy-Item -Path $srcPath -Destination $destinationPath -Force > $null
			}
		}
		elseif($srcPath.Contains("documents")){
			$srcPath1 = $srcPath+"\*"
			$destinationPath1 = $destinationPath
			if(Test-Path $srcPath -PathType Container){
                Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Recurse -Force > $null
            }
			$srcPath2 = $srcPath+".documentFolder-meta.xml"
			$destinationPath2 = $destinationPath+".documentFolder-meta.xml"
			if(Test-Path -LiteralPath $srcPath2){
				Copy-Item -Path $srcPath2 -Destination $destinationPath2 -Force > $null
			}
		}
		elseif($srcPath.Contains("email")){
			$srcPath1 = $srcPath+".emailFolder-meta.xml"
			$destinationPath1 = $destinationPath+".emailFolder-meta.xml"
			$srcPath = $srcPath+"\"+$fileName
			$destinationPath = $destinationPath+"\"+$fileName
			if(Test-Path -LiteralPath $srcPath1){
				Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Force > $null
			}
			elseif(Test-Path -LiteralPath $srcPath){
				Copy-Item -Path $srcPath -Destination $destinationPath -Force > $null
				Copy-Item -Path $srcPath.Replace(".email-meta.xml",".email") -Destination $destinationPath.Replace(".email-meta.xml",".email") -Force > $null
			}
		}
		elseif($srcPath.Contains("objectTranslations")){
			$index = $srcPath.LastIndexOf('\') + 1
			$folderName = $srcPath.Substring($index,$srcPath.Length-$index)
			$srcPath1 = $srcPath+"\"+$folderName+".objectTranslation-meta.xml"
			$destinationPath1 = $destinationPath+"\"+$folderName+".objectTranslation-meta.xml"
			$srcPath = $srcPath+"\"+$fileName
			$destinationPath = $destinationPath+"\"+$fileName
			if(Test-Path -LiteralPath $srcPath1){
				Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Force > $null
			}
			elseif(Test-Path -LiteralPath $srcPath){
				Copy-Item -Path $srcPath -Destination $destinationPath -Force > $null
			}
		}
		elseif($srcPath.Contains("reports")){
			$srcPath1 = $srcPath+".reportFolder-meta.xml"
			$destinationPath1 = $destinationPath+".reportFolder-meta.xml"
			$srcPath = $srcPath+"\"+$fileName
			$destinationPath = $destinationPath+"\"+$fileName
			if(Test-Path -LiteralPath $srcPath1){
				Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Force > $null
			}
			elseif(Test-Path -LiteralPath $srcPath){
				Copy-Item -Path $srcPath -Destination $destinationPath -Force > $null
			}
		}
		elseif($srcPath.Contains("staticresources")){
			$srcPath = $srcPath+"\"+$fileName
			$destinationPath = $destinationPath+"\"+$fileName
			$relativePath = $relativePath -replace 'staticresources/', ''
			try{
				$folderName = $relativePath.Substring(0,$relativePath.IndexOf("/"))
				$srcPath1 = $srcPath -replace 'staticresources.*',''
				$destinationPath1 = $destinationPath -replace 'staticresources.*',''
				$subFolder = 'staticresources\'+$folderName
				$srcPath2 = $srcPath1+$subFolder+'\*'
				$destinationPath2 = $destinationPath1+$subFolder
				Copy-Item -Path $srcPath2 -Destination $destinationPath2 -Recurse -Force > $null
				$srcPath2 = $srcPath1+$subFolder+'.resource-meta.xml'
				$destinationPath2 = $destinationPath1+$subFolder+'.resource-meta.xml'
				if(Test-Path -LiteralPath $srcPath2){
					Copy-Item -Path $srcPath2 -Destination $destinationPath2 -Force > $null
				}
			}
			catch{
				$srcPath = $srcPath.Substring(0,$srcPath.IndexOf("."))
				$destinationPath = $destinationPath.Substring(0,$destinationPath.IndexOf("."))
				if(Test-Path $srcPath -PathType Container){
                	Copy-Item -Path $srcPath -Destination $destinationPath -Recurse -Force > $null
                }
				$srcPath1 = $srcPath+'.resource-meta.xml'
				$destinationPath1 = $destinationPath+'.resource-meta.xml'
				if(Test-Path -LiteralPath $srcPath1){
					Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Force > $null
				}            
			}
		}
		$targetPath = "$xPath\build\target-app"
	}
}else{ Write-Host "No value found in processedChanges" }

#!!!!!!!!!!!!!!!! DELETE EMPTY DIRECTORY & SUBDIRECTORY START !!!!!!!!!!!!!!!!!
$targetPath = "$xPath\build\target-app"
Write-Host "Target path before deleting empty directories :$targetPath"
do {
  $dirs = Get-ChildItem $targetPath -directory -recurse | Where-Object { (Get-ChildItem $_.fullName -Force).count -eq 0 } | Select-Object -expandproperty FullName
  $dirs | ForEach-Object { Remove-Item $_ }
} while ($dirs.count -gt 0)
Write-Host "Target path after deleting empty directories :$targetPath"
#!!!!!!!!!!!!!!!! DELETE EMPTY DIRECTORY & SUBDIRECTORY END !!!!!!!!!!!!!!!!!!!

$targetPath = "$xPath\build\target-app"
Write-Host "!!!!!!!!!!!Printing copied folder and files present in target path.!!!!!!!!!!!!!!!!!!"
Write-Host "Target Path : $targetPath"
Write-Host " "
Get-ChildItem -Path $targetPath -Recurse -Force
Write-Host " "
Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"