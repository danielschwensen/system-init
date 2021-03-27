Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme agnoster

Import-Module PSScriptTools
$f = (Get-Module PSScriptTools).ExportedFormatFiles | where-object {$_ -match 'filesystem-ansi'}
Update-FormatData -PrependPath $f