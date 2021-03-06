$Title = 'Exchange Load Snapin'$Header ='Exchange Load Snapin'
$Comments = 'Exchange 20xx Load Snapin'
$Display = 'None'
$Author = 'John Sneddon'
$PluginVersion = 1.0
$PluginCategory = 'Exchange'

# Based on ideas in http://www.stevieg.org/2011/06/exchange-environment-report/#  and http://www.powershellneedfulthings.com/?page_id=281

# Start of Settings# End of Settings

if (!(Get-PSSnapin -name Microsoft.Exchange.Management.PowerShell.SnapIn -ErrorAction SilentlyContinue) -and    (Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.SnapIn -ErrorAction SilentlyContinue -Registered).Count -gt 0){    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn}
Write-CustomOut 'Fetching Exchange Servers'$ExServers = Get-ExchangeServer -status | Where-Object {$_.IsE14OrLater } | Sort-Object Name

Write-CustomOut 'Fetching DAG Information'$DAGs = Get-DatabaseAvailabilityGroup -Status | Sort-Object Name

Write-CustomOut 'Fetching Database Information'$Databases = Get-MailboxDatabase -Status | Sort-Object Name

Write-CustomOut 'Fetching Mailbox Information'$MBs = Get-Mailbox -ResultSize Unlimited

Write-CustomOut 'Fetching Mailbox Statistics'$MBStats = $Databases | Where-Object {$_.Mounted} | ForEach-Object{ Get-MailboxStatistics -Database $_.Name }

Write-CustomOut 'Fetching ActiveSync Information'$MobileDevices = Get-MobileDevice

Write-CustomOut 'Fetching ActiveSync Device Access Rules'$EASAccessRules = Get-ActiveSyncDeviceAccessRule

# Changelog# ---------
# 1.0 Initial release
# 1.1 Added ActiveSync Devices
# 1.2 Add Mailbox Stats
# 1.3 Add EAS Access Rules
