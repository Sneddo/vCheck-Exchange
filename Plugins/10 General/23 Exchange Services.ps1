$Title = "Exchange Services"
$Header = "Exchange Services"
$Comments = "Exchange Services for Exchange 2010 and above"
$Display = "Table"
$Author = "John Sneddon"
$PluginVersion = 1.0
$PluginCategory = "Exchange"

# Based on code in http://www.powershellneedfulthings.com/?page_id=281

# Start of Settings
# Exchange Services - Only report on those in an unexpected state
$ReportUnexpectedOnly=$true
# End of Settings

$Services = @()

ForEach ($Server in ($ExServers | Where-Object { $_.IsExchange2007OrLater })) 
{   
   $Target = $Server.Name

   $ListOfServices = (Get-WMIObject -computer $Target -query "select * from win32_service where Name like 'MSExchange%' or Name like 'IIS%' or Name like 'SMTP%' or Name like 'POP%' or Name like 'W3SVC%'")

   Foreach ($Service in $ListOfServices)
   {
      $Details = "" | Select-Object Server, Name,Account,"Start Mode",State,"Expected State"

      $Details.Server = $Server.Name
      $Details.Name = $Service.Caption
      $Details.Account = $Service.Startname
      $Details."Start Mode" = $Service.StartMode
      $Details.State = $Service.State
      $Details."Expected State" = "OK"

      If ($Service.StartMode -eq "Auto" -and $Service.State -ne "Running") 
      {
         $Details."Expected State" = "Unexpected"
      }
      ElseIf ($Service.StartMode -eq "Disabled" -and $Service.State -eq "Running") 
      {
         $Details."Expected State" = "Unexpected"
      }

      If (!$ReportUnexpectedOnly -or $Details."Expected State" -ne "OK") 
      {
         $Services += $Details
      }
   }

   If ($Services -ne $null) 
   {
      $Header = "Exchange Services on $Target"

      If ($ReportUnexpectedOnly) 
      {
         $Header += " which are not in their expected state"
      }
   }
}

$Services
