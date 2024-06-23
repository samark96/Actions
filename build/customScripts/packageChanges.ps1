
#project directory path
$xPath = "."

$processedChangesFilePath = "$xPath\build\processedChanges.txt"
$processedChanges = New-Object System.Collections.ArrayList

if(Test-Path -LiteralPath $processedChangesFilePath){
	$processedChanges = Get-Content -Path $processedChangesFilePath
	Write-Host "Processed Changes : $processedChanges"
} else { Write-Host "No file changes" }

#checking processedChanges is not empty and has value in it
if(($processedChanges.Count -gt 0) -and ($processedChanges.Where({ $_ -ne "" }))){
	
	#provide a path where you want to create target folder
	$targetPath = "$xPath\build\target-app"

	#creating folder structure by providing target path
	$directory = new-item -type directory -path $targetPath -Force

	#iterating each file path from processedChanges array
	foreach($relativePath in $processedChanges) {
		Write-Host "relativePath : $relativePath"
		#split-path ignores file name(which has extension) and stores remianing path or string
		$path = $relativePath | Split-Path
        #spliting path and storing folder names into '$folders' variable
		$folders = $path.Split('\')
		#need last index count of '/' to get a substring from ''$relativePath
		$index = $relativePath.LastIndexOf('/') + 1
        #Using index retrieving file name
		$fileName = $relativePath.Substring($index,$relativePath.Length-$index)
        #iterating folder from folders
		foreach($folder in $folders) {   
			#checking if folders exist or not
			if(Test-Path $targetPath -PathType Container ){
				new-item -type directory -path $targetPath -name $folder -Force > $null
                Write-Host "$folder folder created"
				$targetPath = $targetPath+'\'+$folder
			}
		}
		#source path to validate file or folder before adding
		$srcPath = $targetPath.Replace("build\target-app","force-app\main\default")
        #path to copy file
		$destinationPath = $targetPath
        #appending file name
		$srcPath1 = $srcPath+"\"+$fileName
        #appending file name
		$destinationPath1 = $destinationPath+"\"+$fileName
		#checking file path exist or not 
		if(Test-Path -LiteralPath $srcPath1){
			#after appending copying file from srcPath1 to destinationPath1
			Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Force > $null
		}
		#appending "-meta.xml" to srcPath1 to get "-meta.xml"
		$srcPath2 = $srcPath1+"-meta.xml"
		$destinationPath2 = $destinationPath1+"-meta.xml"
		#checking file path exist or not 
		if(Test-Path -LiteralPath $srcPath2){
            #copying '-meta.xml' file from srcPath2 to destinationPath2
			Copy-Item -Path $srcPath2 -Destination $destinationPath2 -Force > $null
		}
        #condition to check path contains 'aura'
		if($srcPath.Contains("aura")){
			if(Test-Path $srcPath -PathType Container){
        		#appending '*' to copy entire aura bundle
				$srcPath = $srcPath+"\*"
				$destinationPath = $destinationPath 
            	#copying aura bundle from srcPath to destinationPath
				Copy-Item -Path $srcPath -Destination $destinationPath -Force > $null
			}
		}
		elseif($srcPath.Contains("lwc")){
			if(Test-Path $srcPath -PathType Container){
        		#appending '*' to copy entire lwc bundle
				$srcPath = $srcPath+"\*"
				$destinationPath = $destinationPath 
            	#copying lwc bundle from srcPath to destinationPath
				Copy-Item -Path $srcPath -Destination $destinationPath -Force > $null
			}
		}
		elseif($srcPath.Contains("documents")){
			#appending '*' to copy entire sub folder
			$srcPath1 = $srcPath+"\*"
			$destinationPath1 = $destinationPath
			if(Test-Path $srcPath -PathType Container){
                Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Recurse -Force > $null
            }
			#appending folder name and extension to srcPath2 to copy ".documentFolder-meta.xml" file into documents folder 
			$srcPath2 = $srcPath+".documentFolder-meta.xml"
			$destinationPath2 = $destinationPath+".documentFolder-meta.xml"
			#checking file path exist or not 
			if(Test-Path -LiteralPath $srcPath2){
				Copy-Item -Path $srcPath2 -Destination $destinationPath2 -Force > $null
			}
		}
		elseif($srcPath.Contains("email")){
			#appending folder name and extension to srcPath1 to copy ".emailFolder-meta.xml" file into email folder
			$srcPath1 = $srcPath+".emailFolder-meta.xml"
			$destinationPath1 = $destinationPath+".emailFolder-meta.xml"
			#src and destination paths to copy files
			$srcPath = $srcPath+"\"+$fileName
			$destinationPath = $destinationPath+"\"+$fileName
			#checking file path exist or not 
			if(Test-Path -LiteralPath $srcPath1){
				Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Force > $null
			}
			elseif(Test-Path -LiteralPath $srcPath){
				Copy-Item -Path $srcPath -Destination $destinationPath -Force > $null
				Copy-Item -Path $srcPath.Replace(".email-meta.xml",".email") -Destination $destinationPath.Replace(".email-meta.xml",".email") -Force > $null
			}
		}
		elseif($srcPath.Contains("objectTranslations")){
			#getting the folder name from the srcPath
			$index = $srcPath.LastIndexOf('\') + 1
			$folderName = $srcPath.Substring($index,$srcPath.Length-$index)
			#appending folder name and extension to srcPath1 to copy ".objectTranslation-meta.xml" file into folder
			$srcPath1 = $srcPath+"\"+$folderName+".objectTranslation-meta.xml"
			$destinationPath1 = $destinationPath+"\"+$folderName+".objectTranslation-meta.xml"
			#
			$srcPath = $srcPath+"\"+$fileName
			$destinationPath = $destinationPath+"\"+$fileName
			#checking file path exist or not 
			if(Test-Path -LiteralPath $srcPath1){
				Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Force > $null
			}
			elseif(Test-Path -LiteralPath $srcPath){
				Copy-Item -Path $srcPath -Destination $destinationPath -Force > $null
			}
		}
		elseif($srcPath.Contains("reports")){
			#appending folder name and extension to srcPath1 to copy ".reportFolder-meta.xml" file into reports folder
			$srcPath1 = $srcPath+".reportFolder-meta.xml"
			$destinationPath1 = $destinationPath+".reportFolder-meta.xml"
			#src and destination paths to copy files
			$srcPath = $srcPath+"\"+$fileName
			$destinationPath = $destinationPath+"\"+$fileName
			#checking file path exist or not 
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
			#replacing 'staticresources/' with empty string in relativePath
			$relativePath = $relativePath -replace 'staticresources/', ''
			try{
				#copying complete subfolder
				$folderName = $relativePath.Substring(0,$relativePath.IndexOf("/"))
				$srcPath1 = $srcPath -replace 'staticresources.*',''
				$destinationPath1 = $destinationPath -replace 'staticresources.*',''
				#concatinating subfolder with 'staticresources' main folder
				$subFolder = 'staticresources\'+$folderName
				$srcPath2 = $srcPath1+$subFolder+'\*'
				$destinationPath2 = $destinationPath1+$subFolder
				Copy-Item -Path $srcPath2 -Destination $destinationPath2 -Recurse -Force > $null
				#to copy meta xml file
				$srcPath2 = $srcPath1+$subFolder+'.resource-meta.xml'
				$destinationPath2 = $destinationPath1+$subFolder+'.resource-meta.xml'
				#checking if file exist or not 
				if(Test-Path -LiteralPath $srcPath2){
					Copy-Item -Path $srcPath2 -Destination $destinationPath2 -Force > $null
				}
			}
			catch{
				#copying only file and respective '.resource-meta.xml'
				$srcPath = $srcPath.Substring(0,$srcPath.IndexOf("."))
				$destinationPath = $destinationPath.Substring(0,$destinationPath.IndexOf("."))
				#checking folder exist or not
				if(Test-Path $srcPath -PathType Container){
					#copying entire sub folders
                	Copy-Item -Path $srcPath -Destination $destinationPath -Recurse -Force > $null
                }
				$srcPath1 = $srcPath+'.resource-meta.xml'
				$destinationPath1 = $destinationPath+'.resource-meta.xml'
				if(Test-Path -LiteralPath $srcPath1){
					Copy-Item -Path $srcPath1 -Destination $destinationPath1 -Force > $null
				}            
			}
		}
		#reseting target path to root folder
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