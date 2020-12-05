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
        Write-Host "Installing $ModuleName"
        #Install-Module -Name $ModuleName -Scope CurrentUser -Confirm $true
        Install-Module -Name $ModuleName -Confirm
        #Import-Module $ModuleName -Confirm
        Import-Module $ModuleName

        Invoke-Command -ScriptBlock $PostInstall
    } else {
        Write-Host "$ModuleName was already installed, skipping"
    }
}

#Install-Chocolatey
#Install-FromChocolatey 'vscode'
#Install-FromChocolatey 'microsoft-windows-terminal'
#Install-FromChocolatey 'firefox'
#Install-FromChocolatey 'googlechrome'
#Install-FromChocolatey 'powershell-preview'

if (!(Get-PackageProvider -Name Nuget -ErrorAction SilentlyContinue)) {

    Write-Host "Installing Nuget"
    #Install-PackageProvider -Name NuGet -Force -Confirm
    Find-PackageProvider -Name 'Nuget' -ForceBootstrap -IncludeDependencies
    Set-PSRepository PSGallery -InstallationPolicy Trusted
} else {

    Write-Host "Nuget was already installed, skipping"
}

#Install-PowerShellModule 'Posh-Git' { Add-PoshGitToProfile -AllHosts }
Install-PowerShellModule 'Posh-Git' { }
Install-PowerShellModule 'oh-my-posh' { }
Install-PowerShellModule 'PSScriptTools' { }


Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/danielschwensen/system-init/master/windows/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
