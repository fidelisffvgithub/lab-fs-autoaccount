filter timestamp {"[$(Get-Date -Format G)]: $_"} 
Write-Output "Script iniciado." | timestamp 
# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process
# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context
# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext


# File storage data
$sto = "stoffv123"
$resourceGroupName = "RG-LAB"
$fs = "fs123"

# Create snapshot
New-AzRmStorageShare -ResourceGroupName $resourceGroupName -StorageAccountName $sto -Name $fs -Snapshot