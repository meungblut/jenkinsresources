Function Set-AzureSettings($publishsettings, $subscription, $storageaccount){
    Import-AzurePublishSettingsFile $publishsettings
 
    Set-AzureSubscription -SubscriptionName $subscription -CurrentStorageAccount $storageaccount
 
    Select-AzureSubscription $subscription
}
 
Function Upload-Package($package, $containerName){
    $blob = "$service.package.$(get-date -f yyyy_MM_dd_hh_ss).cspkg"
     
    $containerState = Get-AzureStorageContainer -Name $containerName -ea 0
    if ($containerState -eq $null)
    {
        New-AzureStorageContainer -Name $containerName | out-null
    }
     
    Set-AzureStorageBlobContent -File $package -Container $containerName -Blob $blob -Force| Out-Null
    $blobState = Get-AzureStorageBlob -blob $blob -Container $containerName
 
    $blobState.ICloudBlob.uri.AbsoluteUri
}
 
Function Create-Deployment($package_url, $service, $slot, $config){
    $opstat = New-AzureDeployment -Slot $slot -Package $package_url -Configuration $config -ServiceName $service
}
  
Function Upgrade-Deployment($package_url, $service, $slot, $config){
    $setdeployment = Set-AzureDeployment -Upgrade -Slot $slot -Package $package_url -Configuration $config -ServiceName $service -Force
}
 
Function Check-Deployment($service, $slot){
    $completeDeployment = Get-AzureDeployment -ServiceName $service -Slot $slot
    $completeDeployment.deploymentid
}
 
try{

$publishsettings = "Windows Azure MSDN - Visual Studio Ultimate-1-21-2015-credentials.publishsetting"
$storageaccount = "soaspike"
$subscription = "Windows Azure MSDN - Visual Studio Ultimate"
$service = "soaspikeservice"
$containerName = "customerordercontainer"
$config = "Tesco.SoaSpike.AzureDeployment\Tesco.SoaSpike.AzureDeployment\bin\Release\app.publish\ServiceConfiguration.Cloud.cscfg"
$package = "Tesco.SoaSpike.AzureDeployment\Tesco.SoaSpike.AzureDeployment\bin\Release\app.publish\Possum.CustomerOrder.AzureDeployment.cspkg"
$slot="Production"

    Write-Host "Running Azure Imports"
    Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"

    Write-Host "Publish Settings: $publishsettings"
    Write-Host "Storage account: $storageaccount"
    Write-Host "Subscription:  $subscription"
    Write-Host "Service: $service"
    Write-Host "Container Name: $containerName"
    Write-Host "Config: $config"
    Write-Host "Package: $package"
    Write-Host "Slot: $slot"
 
    Write-Host "Importing publish profile and setting subscription"
    Set-AzureSettings -publishsettings $publishsettings -subscription $subscription -storageaccount $storageaccount
 
    "Upload the deployment package"
    $package_url = Upload-Package -package $package -containerName $containerName
    "Package uploaded to $package_url"
 
    $deployment = Get-AzureDeployment -ServiceName $service -Slot $slot -ErrorAction silentlycontinue
 
 
    if ($deployment.Name -eq $null) {
        Write-Host "No deployment is detected. Creating a new deployment. "
        Create-Deployment -package_url $package_url -service $service -slot $slot -config $config
        Write-Host "New Deployment created"
 
    } else {
        Write-Host "Deployment exists in $service.  Upgrading deployment."
        Upgrade-Deployment -package_url $package_url -service $service -slot $slot -config $config
        Write-Host "Upgraded Deployment"
    }
 
    $deploymentid = Check-Deployment -service $service -slot $slot
    Write-Host "Deployed to $service with deployment id $deploymentid"
    exit 0
}
catch [System.Exception] {
    Write-Host $_.Exception.ToString()
    exit 1
}