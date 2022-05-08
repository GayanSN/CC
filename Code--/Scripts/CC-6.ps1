$vnet = @{
Name = 'Vnet'
ResourceGroupName = 'RGmilan'
Location = 'Southeast asia'
AddressPrefix = '192.168.10.0/24'
}
$virtualNetwork = New-AzVirtualNetwork @vnet




$subnet = @{
Name = 'subnet1'
VirtualNetwork = $virtualNetwork
AddressPrefix = '192.168.10.0/27'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet


$virtualNetwork | Set-AzVirtualNetwork



$vnet = @{
Name = 'Vnet'
ResourceGroupName = 'RGmilan'
Location = 'Southeast asia'
AddressPrefix = '192.168.10.0/24'
}
$virtualNetwork = New-AzVirtualNetwork @vnet




$subnet = @{
Name = 'subnet1'
VirtualNetwork = $virtualNetwork
AddressPrefix = '192.168.10.0/27'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet


$virtualNetwork | Set-AzVirtualNetwork



New-AzVm `
-ResourceGroupName "RGmilan" `
-Name "VM1" `
-Location "Southeast asia" `
-VirtualNetworkName "Vnet" `
-SubnetName "subnet1" `
-SecurityGroupName "VM1NSG" `
-PublicIpAddressName "VM1PubIP" `
-OpenPorts 80,443,3389
-Size DSv2

