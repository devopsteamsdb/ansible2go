$AllModules = Get-Content /ansible/powershell_modules.txt 
foreach ($item in $AllModules)
{
  install-module $item -AcceptLicense -Verbose  -Force
}
