$rg = @{
    Name = 'RG-018'
    Location = 'Southeast asia'
}
New-AzResourceGroup @rg


######################################################################


$vnet = @{
Name = 'Vnet'
ResourceGroupName = 'RG-018'
Location = 'Southeast asia'
AddressPrefix = '192.168.10.0/24'
}
$virtualNetwork = New-AzVirtualNetwork @vnet


######################################################################


$subnet = @{
Name = 'subnet1'
VirtualNetwork = $virtualNetwork
AddressPrefix = '192.168.10.0/26'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet


$virtualNetwork | Set-AzVirtualNetwork


######################################################################


$subnet = @{
Name = 'subnet2'
VirtualNetwork = $virtualNetwork
AddressPrefix = '192.168.10.64/26'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet


$virtualNetwork | Set-AzVirtualNetwork


######################################################################


$subnet = @{
Name = 'Azurefirewallsubnet'
VirtualNetwork = $virtualNetwork
AddressPrefix = '192.168.10.128/27'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet


$virtualNetwork | Set-AzVirtualNetwork


######################################################################


New-AzVm `
-ResourceGroupName "RG-018" `
-Name "VM1" `
-Location "Southeast asia" `
-VirtualNetworkName "Vnet" `
-SubnetName "subnet1" `
-SecurityGroupName "VM1NSG" `
-PublicIpAddressName "VM1PubIP" `
-OpenPorts 80,443,3389


######################################################################


New-AzVm `
-ResourceGroupName "RG-018" `
-Name "VM2" `
-Location "Southeast asia" `
-VirtualNetworkName "Vnet" `
-SubnetName "subnet2" `
-SecurityGroupName "VM2NSG" `
-PublicIpAddressName "VM2PubIP" `
-OpenPorts 80,443,3389


######################################################################
