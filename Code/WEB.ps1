# Creat Resource Group
$rg = @{
    Name = 'RG-018'
    Location = 'Southeast asia'
}
New-AzResourceGroup @rg


# Creat Virtual Network

$vnet = @{
    Name = 'Vnet1'
    ResourceGroupName = 'RG-018'
    Location = 'Southeast asia'
    AddressPrefix = '192.168.10.0/24'
    }
$virtualNetwork = New-AzVirtualNetwork @vnet

# Creat Subnet

$subnet = @{
    Name = 'subnet1'
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '192.168.10.0/27'
    }
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet


$virtualNetwork | Set-AzVirtualNetwork

# Web Tier
# Creat App Service
New-AzWebApp `
-ResourceGroupName Default-Web-WestUS `
-Name "ContosoSite" -Location "West US" `
-AppServicePlan "ContosoServicePlan"
# Creat Application gateway


# Database Tier
# Creat SQL database
# Creat Load balancer
New-AzResourceGroup `
  -ResourceGroupName "myResourceGroupLoadBalancer" `
  -Location "EastUS"

$publicIP = New-AzPublicIpAddress `
  -ResourceGroupName "myResourceGroupLoadBalancer" `
  -Location "EastUS" `
  -AllocationMethod "Static" `
  -Name "myPublicIP"

$frontendIP = New-AzLoadBalancerFrontendIpConfig `
  -Name "myFrontEndPool" `
  -PublicIpAddress $publicIP

$backendPool = New-AzLoadBalancerBackendAddressPoolConfig `
  -Name "myBackEndPool"

$lb = New-AzLoadBalancer `
  -ResourceGroupName "myResourceGroupLoadBalancer" `
  -Name "myLoadBalancer" `
  -Location "EastUS" `
  -FrontendIpConfiguration $frontendIP `
  -BackendAddressPool $backendPool

Add-AzLoadBalancerProbeConfig `
  -Name "myHealthProbe" `
  -LoadBalancer $lb `
  -Protocol tcp `
  -Port 80 `
  -IntervalInSeconds 15 `
  -ProbeCount 2

$probe = Get-AzLoadBalancerProbeConfig -LoadBalancer $lb -Name "myHealthProbe"

Add-AzLoadBalancerRuleConfig `
  -Name "myLoadBalancerRule" `
  -LoadBalancer $lb `
  -FrontendIpConfiguration $lb.FrontendIpConfigurations[0] `
  -BackendAddressPool $lb.BackendAddressPools[0] `
  -Protocol Tcp `
  -FrontendPort 80 `
  -BackendPort 80 `
  -Probe $probe

  Set-AzLoadBalancer -LoadBalancer $lb

