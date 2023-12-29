#define variables

$validValues = "Yes", "Y", "yes", "y", "No", "N", "n", "no"
$wingetChoiceValues = "1","2","3"
$contextValues = "S", "s", "U", "u"
$PSDefaultParameterValues['Write-Host:ForegroundColor'] = 'Green'

#Welcome message
Write-host "Welcome to the winget script building tool! More info at my github: URL HERE

Would you like to search the winget repository for applications?"

write-host "[Y] Yes  [N] No" -ForegroundColor yellow

$search = Read-Host

while (-not ($search -in $validValues)) {
    Write-host "`nYour response needs to be `"Yes`", `"Y`", `"No`" or `"N`" (case-insensitive). Please enter it again:" -ForegroundColor Magenta
    $search = read-host
    }

    if ($search -like "y*") {
        
        $wingetCheck = Get-AppPackage *Microsoft.DesktopAppInstaller* | Out-String
        
        if ($wingetCheck -match "Microsoft.DesktopAppInstaller") {
            write-host "`nCongrats! You have winget installed on your computer and can search for applications on the repository!" -foregroundcolor yellow
            
            Write-Host "`nWhat is the name of the program?" -ForegroundColor Green
            write-host "NOTE: The provided name will be for the creation of folders and files." -ForegroundColor yellow

            $name = Read-host

            Write-Host "`nSearching winget for this application.`n" -ForegroundColor Yellow

            winget search $name
            
            $wingetOutput = winget search $name | Out-String
    
            while ($wingetOutput -match "No package found") {
                write-host "`nThere is no package found with that name. Please enter the name of the program again:"
                $name = Read-host
                Write-Host "`nSearching winget for this application.`n" -ForegroundColor Yellow
                $wingetOutput = winget search $name | Out-String
                winget search $name
                }

            if (!($wingetOutput -match "No package found")) {
               }
            }

        elseif (!($wingetCheck -match "Microsoft.DesktopAppInstaller")) {
            write-host "`nYou do not have winget installed on your computer! Sorry!" -ForegroundColor Red

            Write-host "`nPlease choose from one of following options:" 

            write-host "`nType `"1`" to continue building deployment scripts without searching winget." -foregroundcolor yellow
            write-host "Type `"2`" to install winget." -foregroundcolor yellow
            write-host "Type `"3`" to give up and exit the script." -foregroundcolor yellow
            
            write-host "`nHow would you like to proceed?"
            write-host "[Y] Yes  [N] No" -ForegroundColor yellow

            $wingetChoice = read-host

            while (-not ($wingetChoice -in $wingetChoiceValues)) {
                Write-host "`nYour response needs to be `1, 2, or 3! Please enter it again:" -ForegroundColor Magenta
                $wingetChoice = read-host
                }

            if ($wingetChoice -eq "1") {
                Write-Host "`nWhat is the name of the program?"
                write-host "NOTE: The provided name will be for the creation of folders and files." -ForegroundColor yellow
                $name = Read-host
                }


            elseif ($wingetChoice -eq "2") {
                Write-Host "`nThis script will attempt to install winget.`n`nThis has only been tested on Windows Sandbox only.`n`nIt will not work on LTSC/Windows Server but should be fine with others." -foregroundcolor red
                
                write-host "`n`nThe following commands will be run:`n"

                Write-Host 'install-script winget-install -force' -foregroundcolor yellow
                Write-Host 'winget-install' -foregroundcolor yellow
                write-host "`nNOTE: You will be prompted to prompted to trust the NuGet respository to continue."
                
                Write-Host "`n`nWould you like to proceed?"
                write-host "[Y] Yes  [N] No" -ForegroundColor yellow

                $wingetInstall = Read-Host

                    while (-not ($wingetInstall -in $validValues)) {
                        Write-host "`nYour response needs to be `"Yes`", `"Y`", `"No`" or `"N`" (case-insensitive). Please enter it again:" -ForegroundColor Magenta
                        $wingetInstall = read-host
                    }

                    if ($wingetInstall -like "y*") {
                        
                        install-script winget-install -force
                        winget-install

                        write-host "`n`nWinget has installed! This script will now exit. Please rerun the script.`n`n"
                        exit
                        }

                    elseif ($wingetinstall -like "n*") {
                        write-host "`nNo worries. Exiting the script now! Feel free to run it again!`n"
                        exit
                        }
                    
            }

            elseif ($wingetChoice -eq "3") {
                write-host "`nThat's too bad. Exiting now! Have a great day!`n"
                exit
                }

            }
            
        }




    elseif ($search -like "n*") {
        Write-Host "`nWhat is the name of the program?" -ForegroundColor Green
        write-host "NOTE: The provided name will be for the creation of folders and files." -ForegroundColor yellow
        $name = Read-host
        }






# Asks the user for resource ID
Write-Host "`nWhat is the resource ID for the winget package you are looking to build?"
Write-Host "NOTE: This is case-sensitive!" -ForegroundColor Red

# Read the user input and store it in a variable
$resourceID = Read-Host

# ask if it is in the system context

Write-Host "`nWill this package install in the system or user context?"
Write-Host "[S] System [U] User" -ForegroundColor Yellow

$systemContext = Read-Host

while (-not ($systemContext -in $contextValues)) {
    Write-host "`nYour response needs to be `"S`" or `"U`" (case-insensitive). Please enter it again:" -ForegroundColor Magenta
    $systemContext = read-host
    }

    if ($systemContext -like "s*") {
        $sysConType = "System"
        }

    elseif ($systemContext -like "u*") {
        $sysConType = "User"
        }


# prompt for where to save the file.

write-host "`nWhere do you want to save the files?"

$saveDir = Read-Host


# Check if the last character is a \
if ($saveDir -match "\\$") {
    # Remove the last character using -replace
    $saveDir = $saveDir -replace "\\$"
}

# Display the modified string
Write-Host "The string is: $saveDir"

#define file creation paths for install, uninstall, and detections script files

$installSave = "$saveDir\$name(winget)\install$name.ps1"
$uninstallSave = "$saveDir\$name(winget)\uninstall$name.ps1"
$detectSave = "$saveDir\$name(winget)\detect$name.ps1"
$saveFolder = "$saveDir\$name(winget)"

# Displays the values for the variables for the users to confirm


Write-host "`n`n==============================================`n" -ForegroundColor Yellow

Write-host "Software name: $name 
Resource ID: $resourceID
Installation Context: $sysConType`n" -ForegroundColor cyan

Write-Host "NOTE: This script create scripts for the installation, detection, and uninstall of your $name package." -ForegroundColor Yellow

Write-host "`nYour files will be saved at the locations listed below:`n"

Write-host "Install script: $installSave 
Detection script: $detectSave
Uninstall script: $uninstallSave`n" -ForegroundColor cyan

Write-host "==============================================`n" -ForegroundColor Yellow

Write-host "Is the information above correct and are you ready to proceed?" -ForegroundColor Green
write-host "[Y] Yes  [N] No" -ForegroundColor yellow

$continue = Read-Host

#exits the script if the information is not correct as specified by the user

while (-not ($continue -in $validValues)) {
    Write-host "`nYour response needs to be `"Yes`", `"Y`", `"No`" or `"N`" (case-insensitive). Please enter it again:" -ForegroundColor Magenta
    $continue = read-host
    }

    if ($continue -like "n*") {
        Write-Host "`n`nI'm sorry that you're not ready to proceed. Please re-run the script.

        Exiting now..."
        exit
        }




# =====================================================================================
#
# Creates the install script file. It will add the content to the file
# dependent on whether the sure specified it is in the system context
# or not. NOTE: Install will fail if scope arg is wrong. If so, you will
# see the error in the IME logs. Also includes error handling that will 
# be present in the IME logs if winget is not installed on the machine.
#
# Source: https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-program-template
#
# =====================================================================================

New-Item -ItemType file -Force -Path "$installSave" | Out-Null

## Sets the variable for programName to resource. DO NOT DELETE. Script creation will not work properly without this

$ProgramName = '$ProgramName'


Set-Content -path $installSave -value "$ProgramName = `"$resourceID`""

## format like this https://stackoverflow.com/questions/76881152/powershell-add-set-content-doesnt-add-variables

if ($sysConType -eq "system") {

    Add-Content -path "$installSave" -Value '
    $Path_local = "$Env:Programfiles\_MEM"
    Start-Transcript -Path "$Path_local\Log\$ProgramName-install.log" -Force -Append

    # resolve winget_exe
    $winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
    if ($winget_exe.count -gt 1){
            $winget_exe = $winget_exe[-1].Path
    }

    if (!$winget_exe){Write-Error "Winget not installed"}

    & $winget_exe install --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --scope=machine

    Stop-Transcript
    '
    }

elseif ($sysConType -eq "user") {
    
    Add-Content -path "$installSave" -Value '
    $Path_local = "$Env:Programfiles\_MEM"
    Start-Transcript -Path "$Path_local\Log\$ProgramName-install.log" -Force -Append

    # resolve winget_exe
    $winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
    if ($winget_exe.count -gt 1){
            $winget_exe = $winget_exe[-1].Path
    }

    if (!$winget_exe){Write-Error "Winget not installed"}

    & $winget_exe install --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --scope=user

    Stop-Transcript
    '
    }



# =========================================================================
#
# Creates the UNINSTALL script file.
#
# Source: https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-program-template
#
# =========================================================================


Set-Content -path $uninstallSave -value "$ProgramName = `"$resourceID`""

## format like this https://stackoverflow.com/questions/76881152/powershell-add-set-content-doesnt-add-variables


Add-Content -path "$uninstallSave" -Value '

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\uninstall\$ProgramName-uninstall.log" -Force -Append

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

& $winget_exe uninstall --exact --id $ProgramName --silent --accept-source-agreements

Stop-Transcript

'

# =========================================================================
#
# Creates the DETECTS script file. Includes error handling for if winget
# is not present on the device, which can be found in the IME logs.
#
# Source: https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-program-template
#
# =========================================================================


Set-Content -path $detectSave -value "$ProgramName = `"$resourceID`""

## format like this https://stackoverflow.com/questions/76881152/powershell-add-set-content-doesnt-add-variables


Add-Content -path "$detectSave" -Value '

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){
    Write-Error "Winget not installed"
}else{
    $wingetPrg_Existing = & $winget_exe list --id $ProgramName --exact --accept-source-agreements
        if ($wingetPrg_Existing -like "*$ProgramName*"){
        Write-Host "Found it!"
    }
}

'


write-host "`n`nYour files have been created! They can be found at the directory specified above and as seen below."

get-childitem "$saveDir\$name(winget)" 

Write-Host "`nWould you like run win32 content prep tool to package this app?"

Write-host "`nNOTE: The script will look for the Win32 Content Prep tool 
named at its default IntuneWinAppUtil.exe file name and saved in the 
same directory as this script. You will be able to specify a different 
directory if not found.

[Y] Continue [N] Exit" -ForegroundColor Yellow

$continuePrep = Read-Host

# $saveFolder = '$saveFolder'
# $installSave = '$installSave'
# $saveDir = '$saveDir'


while (-not ($continuePrep -in $validValues)) {
    Write-host "`nYour response needs to be `"Yes`", `"Y`", `"No`" or `"N`" (case-insensitive). Please enter it again:" -ForegroundColor Magenta
    $continuePrep = read-host
    }

    if ($continuePrep -like "n*") {
        Write-Host "`n`nHave a wonderful day and thank you for running this script!`n`nExiting now..."
        exit
        }

    elseif (!(Test-Path -Path "$PSScriptRoot\IntuneWinAppUtil.exe")) {
        Write-Host "`nIntuneWinAppUtil.exe does not exist in the same directory as this script.`n" -ForegroundColor Red
        write-Host "Please specify the directory where the program is found:"
        $intuneWinDir = Read-Host

        if ($intuneWinDir -match "\\$") {
            # Remove the last character using -replace
            $intuneWinDir = $intuneWinDir -replace "\\$"
        }

        while (!(Test-Path -Path "$intuneWinDir\IntuneWinAppUtil.exe")) {
            Write-Host "`nIntuneWinAppUtil.exe does not exist in the specified directory.`n" -ForegroundColor Red
            write-Host "Please specify the directory where the program is found:"
            $intuneWinDir = Read-Host

            if ($intuneWinDir -match "\\$") {
                # Remove the last character using -replace
                $intuneWinDir = $intuneWinDir -replace "\\$"
            }
        }

        Start-Process -FilePath "$intuneWinDir\IntuneWinAppUtil.exe" -ArgumentList "-c `"$saveFolder`" -s `"$installSave`" -o `"$saveDir`" -q"
        write-Host "`nYour intunewin file (install$name.intunewin) has been created!`n`nYou can find it at `"$saveDir`"`n"

    }

    else {
        Start-Process -FilePath "$PSScriptRoot\IntuneWinAppUtil.exe" -ArgumentList "-c `"$saveFolder`" -s `"$installSave`" -o `"$saveDir`" -q"
        write-Host "`nYour intunewin file (install$name.intunewin) has been created!`n`nYou can find it at `"$saveDir`"`n"
    }


