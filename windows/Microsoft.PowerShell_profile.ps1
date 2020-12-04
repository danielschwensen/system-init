Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox

Import-Module PSScriptTools
$f = (Get-Module PSScriptTools).ExportedFormatFiles | where-object {$_ -match 'filesystem-ansi'}
Update-FormatData -PrependPath $f