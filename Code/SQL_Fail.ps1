$subscriptionId = "<SubscriptionID>"
$resourceGroupName = "<Resource-Group-Name>"
$location = "<Region>"
$adminLogin = "<Admin-Login>"
$password = "<Complex-Password>"
$serverName = "<Primary-Server-Name>"
$databaseName = "<Database-Name>"
$drLocation = "<DR-Region>"
$drServerName = "<Secondary-Server-Name>"
$failoverGroupName = "<Failover-Group-Name>"

# Create a secondary server in the failover region
Write-host "Creating a secondary server in the failover region..."
$drServer = New-AzSqlServer -ResourceGroupName $resourceGroupName `
   -ServerName $drServerName `
   -Location $drLocation `
   -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential `
      -ArgumentList $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))
$drServer

# Create a failover group between the servers
$failovergroup = Write-host "Creating a failover group between the primary and secondary server..."
New-AzSqlDatabaseFailoverGroup `
   ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -PartnerServerName $drServerName  `
   FailoverGroupName $failoverGroupName `
   FailoverPolicy Automatic `
   -GracePeriodWithDataLossHours 2
$failovergroup

# Add the database to the failover group
Write-host "Adding the database to the failover group..."
Get-AzSqlDatabase `
   -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -DatabaseName $databaseName | `
Add-AzSqlDatabaseToFailoverGroup `
   -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -FailoverGroupName $failoverGroupName
Write-host "Successfully added the database to the failover group..."


# Set variables
$resourceGroupName = "<Resource-Group-Name>"
$serverName = "<Primary-Server-Name>"
$failoverGroupName = "<Failover-Group-Name>"

# Check role of secondary replica
Write-host "Confirming the secondary replica is secondary...."
(Get-AzSqlDatabaseFailoverGroup `
   -FailoverGroupName $failoverGroupName `
   -ResourceGroupName $resourceGroupName `
   -ServerName $drServerName).ReplicationRole

# Set variables
$resourceGroupName = "<Resource-Group-Name>"
$serverName = "<Primary-Server-Name>"
$failoverGroupName = "<Failover-Group-Name>"

# Failover to secondary server
Write-host "Failing over failover group to the secondary..."
Switch-AzSqlDatabaseFailoverGroup `
   -ResourceGroupName $resourceGroupName `
   -ServerName $drServerName `
   -FailoverGroupName $failoverGroupName
Write-host "Failed failover group to successfully to" $drServerName

# Set variables
$resourceGroupName = "<Resource-Group-Name>"
$serverName = "<Primary-Server-Name>"
$failoverGroupName = "<Failover-Group-Name>"

# Revert failover to primary server
Write-host "Failing over failover group to the primary...."
Switch-AzSqlDatabaseFailoverGroup `
   -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -FailoverGroupName $failoverGroupName
Write-host "Failed failover group successfully to back to" $serverName