# Start of Settings
# Report Message Queues with >= x messages
$MessageQueueThreshold=50
#Ignore Queues matching this expression
$ignoreQueues="\\Shadow\\"
# End of Settings

Get-Queue | Where-Object { $_.MessageCount -ge $MessageQueueThreshold -and $_.Identity -notMatch $ignoreQueues} | Select-Object Identity, Status, DeliveryType, MessageCount, NextHopDomain

$Title = "Exchange Hub Transport Mail Queues"
$Header = "Exchange Hub Transport Mail Queues"
$Comments = "Hub Transport Mail Queues ignoring queues matching $($ignoreQueues)"
$Display = "Table"
$Author = "John Sneddon"
$PluginVersion = 1.0
$PluginCategory = "Exchange"
