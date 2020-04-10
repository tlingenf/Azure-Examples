Import-Module Az.Accounts
Import-Module Az.Storage

Connect-AzAccount

$subscriptionId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$storageResourceGroupName = "core.shared"
$storageAccountName = "storagename"
$storageContainerName = "loadtest"

Select-AzSubscription -SubscriptionId $subscriptionId

$storageAccount = Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $storageResourceGroupName

$storageKeys = $storageAccount | Get-AzStorageAccountKey
$destinationContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageKeys[0].Value

$containerSASURI = New-AzStorageContainerSASToken -Context $destinationContext -ExpiryTime(get-date).AddSeconds(3600) -FullUri -Name $storageContainerName -Permission rwld

azcopy bench $containerSASURI --size-per-file 4541K --file-count 1 --block-size-mb 0.0000886917114257812