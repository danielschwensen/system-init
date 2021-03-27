# Create Temp fonts dir
$TempFontDir = "fonts"
New-Item -Path "$env:TEMP\$TempFontDir" -ItemType Directory -Force
explorer "$env:TEMP\$TempFontDir"
explorer "$env:TEMP"

#Download Font
$url = "https://raw.githubusercontent.com/danielschwensen/system-init/master/windows/font/Go-Mono.zip"

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
# Can be deleted $allFonts = dir $FontsFolder
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
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "GoMono NF (TrueType)" /t REG_SZ /d "go mono nerd font complete windows compatible.ttf" /f
explorer "C:\Windows\Fonts"
Remove-Item "$env:TEMP\Go-Mono.zip"