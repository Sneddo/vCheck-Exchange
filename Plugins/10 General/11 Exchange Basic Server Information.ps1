$Title = "Exchange Basic Server Information"
$Header ="Exchange Basic Server Information"
$Comments = "Exchange Basic Server Information"
$Display = "Table"
$Author = "John Sneddon"
$PluginVersion = 1.0
$PluginCategory = "Exchange"

# Start of Settings
# End of Settings

Foreach ($exServer in ($exServers | Where-Object { $_.IsExchange2007OrLater } | Sort-Object Name))
{
   $OperatingSystems = Get-WmiObject -computername  $exServer.Name Win32_OperatingSystem

   if ($exServer.AdminDisplayVersion -match "Version 8") 
   {
      $rollUpKey = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer\\UserData\\S-1-5-18\\Products\\461C2B4266EDEF444B864AD6D9E5B613\\Patches" 
   }
   ElseIf ($exServer.AdminDisplayVersion -match "Version 14") 
   {
      $rollUpKey = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer\\UserData\\S-1-5-18\\Products\\AE1D439464EB1B8488741FFA028E291C\\Patches" 
   } 
   ElseIf ($exServer.AdminDisplayVersion -match "Version 15") 
   {
      $rollUpKey = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer\\UserData\\S-1-5-18\\Products\\AE1D439464EB1B8488741FFA028E291C\\Patches" 
   }

   $registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',  $exServer.Name)

   if ($Registry)
   {
      $installedRollUps = $registry.OpenSubKey($rollUpKey).GetSubKeyNames()
      $ru = @()
      foreach ($rollUp in $installedRollUps) 
      {
         $thisRollUp = "$rollUpKey\\$rollUp"
         $ru += New-Object PSObject -Property @{
            Date = $thisRollUp | ForEach-Object{$registry.OpenSubKey($_).getvalue('Installed')}
            Name = $thisRollUp | ForEach-Object{$registry.OpenSubKey($_).getvalue('DisplayName')}
         }
      }
      $Rollups = ($ru | Sort-Object Date | Select-Object -ExpandProperty Name) -join "<br />"
      $InstDates = ($ru | Sort-Object Date | Select-Object -ExpandProperty Date) -join "<br />"
   }

   $LBTime=$OperatingSystems.ConvertToDateTime($OperatingSystems.Lastbootuptime)

   New-Object PSObject -Property @{
      "Computer Name" = $exServer.Name
      "Operating System" = $OperatingSystems.Caption
      "Service Pack" = $OperatingSystems.CSDVersion
      "Exchange Version" = $exServer.AdminDisplayVersion
      "Rollups" = $Rollups -replace '(.*), $','$1'
      "Rollup Install Dates" = $InstDates -replace '(.*), $','$1'
      "Exchange Edition" = $exServer.Edition
      "Exchange Role(s)" = $exServer.ServerRole
   } | Select-Object "Computer Name","Operating System", "Service Pack", "Exchange Version", "Rollups", "Rollup Install Dates", "Exchange Edition", "Exchange Role(s)"
}

