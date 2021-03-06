$Title = "Exchange Drive Details"
$Header = "Exchange Drive Details"
$Comments = "Exchange Drive Details"
$Display = "Table"
$Author = "John Sneddon"
$PluginVersion = 1.0
$PluginCategory = "Exchange"

# Start of Settings
# Report Details only for drives with <= x% free space
$ReportPercent =15
# End of Settings

$LogicalDrives = @()

Foreach ($s in ($ExServers | Where-Object { $_.IsExchange2007OrLater } ))
{
   $Target = $s.Name
   $Disks = Get-WmiObject -ComputerName $Target Win32_Volume | Sort-Object Name

   Foreach ($LDrive in ($Disks | Where-Object {$_.DriveType -eq 3 -and $_.Label -ne "System Reserved"})) 
   {
      $Details = "" | Select-Object "Server", "Name", Label, "File System", "Capacity (GB)", "Free Space", "% Free Space"
      $FreePercent = [Math]::Round(($LDrive.FreeSpace / 1GB) / ($LDrive.Capacity / 1GB) * 100)

      $Details."Server" = $s.Name
      $Details."Name" = $LDrive.Name
      $Details.Label = $LDrive.Label
      $Details."File System" = $LDrive.FileSystem
      $Details."Capacity (GB)" = ([math]::round(($LDrive.Capacity / 1GB))).toString()
      $Details."Free Space" = ([math]::round(($LDrive.FreeSpace / 1GB))).toString()
      $Details."% Free Space" = $FreePercent.toString()

      If ($FreePercent -le $ReportPercent) 
      {
         $LogicalDrives += $Details
      }
   }
}

If ($LogicalDrives.Count -gt 0) 
{   
   $Comments = "Drives on Exchange Server $Target"

   If ($ReportPercent -lt 100) 
   {
      $Comments += " with less than $($ReportPercent)% free space"
   }

   $Header = $Comments
}

$LogicalDrives

$TableFormat = @{"% Free Space" = @(@{ "-le 10"     = "Row,class|critical" };
                                    @{ "-le 15"     = "Row,class|warning"; });
              }
