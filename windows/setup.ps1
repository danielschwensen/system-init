function Install-Fonts {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/danielschwensen/system-init/master/windows/Download_install_fonts.ps1'))
}
function Install-Chocolatey {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function Install-FromChocolatey {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $PackageName
    )

    choco install $PackageName --yes
}

function Install-PowerShellModule {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $ModuleName,

        [ScriptBlock]
        [Parameter(Mandatory = $true)]
        $PostInstall = {}
    )

    if (!(Get-Command -Name $ModuleName -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force;
        Write-Host "Installing $ModuleName"
        Install-Module -Name $ModuleName
        Import-Module $ModuleName

        Invoke-Command -ScriptBlock $PostInstall
    } else {
        Write-Host "$ModuleName was already installed, skipping"
    }
}

Set-ExecutionPolicy RemoteSigned -Force
Install-Fonts
Install-Chocolatey
Install-FromChocolatey 'vscode'
Install-FromChocolatey 'microsoft-windows-terminal'
Install-FromChocolatey 'firefox'
Install-FromChocolatey 'googlechrome'
Install-FromChocolatey 'powershell-preview'


Write-Host "Installing Nuget"
Find-PackageProvider -Name 'Nuget' -ForceBootstrap -IncludeDependencies
Set-PSRepository PSGallery -InstallationPolicy Trusted

#Install-PowerShellModule 'Posh-Git' { Add-PoshGitToProfile -AllHosts }
Install-PowerShellModule 'Posh-Git' { }
Install-PowerShellModule 'oh-my-posh' { }
Install-PowerShellModule 'PSScriptTools' { }


Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/danielschwensen/system-init/master/windows/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE

# Delete Windows Terminal settings
$settings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if(Test-Path $settings){
    Remove-Item $settings -Force
}

#Download Windows Terminal Settings
$url = "https://raw.githubusercontent.com/danielschwensen/system-init/master/windows/wt-settings/settings.json"
$output = $settings
Invoke-WebRequest -Uri $url -OutFile $output
explorer "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"