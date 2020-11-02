# Config files
$scriptVRFile = Get-Content ".\script_files\VR.txt"
$scriptDMZFile = Get-Content ".\script_files\DMZ.txt"
$scriptFWFile = Get-Content ".\script_files\FW.txt"
$scriptMCFile = Get-Content ".\script_files\MC.txt"

# Building the path
$driveLetter = Get-Volume | select -expand driveletter
$user = $env:USERNAME

# Pathes
$pathToVRFile = $driveLetter + ":\Users\" + $user + "\Documents\Virtual Machines\PA-VM-9.0-PanOS-VR\PA-VM-9.0-PanOS-VR.vmx"
$pathToDMZFile = $driveLetter + ":\Users\" + $user + "\Documents\Virtual Machines\PA-VM-9.0-PanOS-DMZ\PA-VM-9.0-PanOS-DMZ.vmx"
$pathToFWFile = $driveLetter + ":\Users\" + $user + "\Documents\Virtual Machines\PA-VM-9.0-PANOS-FW-OVA\PA-VM-9.0-PANOS-FW-OVA.vmx"
$pathToMCFile = $driveLetter + ":\Users\" + $user + "\Documents\Virtual Machines\PAN8_210_Master_Client\PAN8_210_Master_Client.vmx"


# File contents
$VRFileContent = Get-Content $pathToVRFile
$DMZFileContent = Get-Content $pathToDMZFile
$FWFileContent = Get-Content $pathToFWFile
$MCFileContent = Get-Content $pathToMCFile

# File locations check
$isVRFileThere = Test-Path $pathToVRFile
$isDMZFileThere = Test-Path $pathToDMZFile
$isFWFileThere = Test-Path $pathToFWFile
$isMCFileThere = Test-Path $pathToMCFile


function FindFile {
    param( $isFileThere )
    if ($isFileThere -eq $true) {
        Write-Output("FILE FOUND!")
        Write-Host("")
    }
    else {
        Write-Output("FILE NOT FOUND!")
        Start-Sleep 1
        exit
    }
}

Write-Host -NoNewline "VR" (FindFile $isVRFileThere) 
Write-Host -NoNewline "DMZ" (FindFile $isDMZFileThere)
Write-Host -NoNewline "FIREWALL" (FindFile $isFWFileThere)
Write-Host -NoNewline "MASTER CLIENT" (FindFile $isMCFileThere)
Write-Host""
Write-Host""


function checkFile {
    param( $FileContent, $scriptFile, $pathToFile )
    if ($FileContent -NotLike "#SCRIPT MADE BY TARMO") {
        (type $pathToFile) -notmatch "^ethernet" | Out-File $pathToFile
        Add-Content -Path $pathToFile -Value $scriptFile
        Write-Output ("CONFIG ADDED!")
    }
}

Write-Host "VR" (checkFile $VRFileContent $scriptVRFile $pathToVRFile) 
Write-Host "DMZ" (checkFile $DMZFileContent $scriptDMZFile $pathToDMZFile)
Write-Host "FIREWALL" (checkFile $FWFileContent $scriptFWFile $pathToFWFile)
Write-Host "MASTER CLIENT" (checkFile $MCFileContent $scriptMCFile $pathToMCFile)