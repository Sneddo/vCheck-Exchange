$Title = "Exchange Disconnected Mailboxes"
$Header =  "Exchange Disconnected Mailboxes"
$Comments = "Exchange Disconnected Mailboxes"
$Display = "Table"
$Author = "John Sneddon"
$PluginVersion = 1.1
$PluginCategory = "Exchange2010"

# Start of Settings
# Include mailboxes disconneced in past x days
$LastDays=1
# End of Settings

$MBStats | Where { $_.DisconnectDate -ne $null -and ($_.DisconnectDate -gt (Get-Date).AddDays(-$LastDays)) } | `
   Select DisplayName, DatabaseName, DisconnectReason, DisconnectDate, MailboxGUID | Sort DisplayName

# ChangeLog
# ---------
# 1.0 - Initial release
# 1.1 - Add $LastDays setting
