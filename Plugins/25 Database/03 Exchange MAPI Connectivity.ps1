# Start of Settings
# Report on MAPI Latency >= x milliseconds
$MinLatency=50
# End of Settings

ForEach ($server in ($exServers | Where-Object {$_.IsMailboxServer})) 
{
   Test-MAPIConnectivity -Server $Server -ErrorAction SilentlyContinue |
      Where-Object { $_.Result.Value -ne "Success" -or ([Math]::Round(([TimeSpan] $_.Latency).TotalMilliSeconds)) -ge $MinLatency } |
      Sort-Object Server,Database |
      Select-Object Server,Database, Result, @{Name="Latency (mS)";expression={[Math]::Round(([TimeSpan] $_.Latency).TotalMilliSeconds)}}, Error
}

$TableFormat = @{"Result" = @(@{ "-eq '*FAILURE*'"     = "cell,class|criticalText" })}

$Title = "Exchange MAPI Connectivity"
$Header =  "Exchange MAPI Connectivity"
$Comments = "Exchange MAPI Connectivity where Latency >= $($MinLatency)ms or Result not 'Success'"
$Display = "Table"
$Author = "John Sneddon"
$PluginVersion = 1.0
$PluginCategory = "Exchange2010"
