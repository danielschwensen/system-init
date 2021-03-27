# Create Temp fonts dir
$TempFontDir = "fonts3"
New-Item -Path "$env:TEMP\$TempFontDir" -ItemType Directory -Force 

#Download Font
$url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Go-Mono.zip"
$output = "$env:TEMP\Go-Mono.zip"
$start_time = Get-Date

Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

#Unzip and install fonts
$Source = "$env:TEMP\Go-Mono.zip"
$FontsFolder = "$env:TEMP\$TempFontDir"
Expand-Archive $Source -DestinationPath $FontsFolder -Force
$FONTS = 0x14
$CopyOptions = 4 + 16;
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace($FONTS)
$allFonts = dir $FontsFolder
foreach($font in Get-ChildItem -Path $fontsFolder -File)
{
    $dest = "C:\Windows\Fonts\$font"
    If(Test-Path -Path $dest)
    {
        echo "Font $font already installed"
    }
    Else
    {
        echo "Installing $font"
        $CopyFlag = [String]::Format("{0:x}", $CopyOptions);
        $objFolder.CopyHere($font.fullname,$CopyFlag)
    }
}