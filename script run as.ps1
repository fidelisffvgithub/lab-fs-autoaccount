filter timestamp {"[$(Get-Date -Format G)]: $_"} 
Write-Output "Script iniciado." | timestamp 

# File storage data
$resourceGroupName = "RG-LAB"
$sto = "stoffv123"
$fs = "fs123"

# Connect using Run As
$conn = Get-AutomationConnection -Name "AzureRunAsConnection" 
Connect-AzAccount -ServicePrincipal -Tenant $conn.TenantID -ApplicationId $conn.ApplicationID -CertificateThumbprint $conn.CertificateThumbprint | out-null

# Create snapshot
New-AzRmStorageShare -ResourceGroupName $resourceGroupName -StorageAccountName $sto -Name $fs -Snapshot