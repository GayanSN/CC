$rg = @{
    Name = 'RG018'
    Location = 'Southeast asia'
}
New-AzResourceGroup @rg


New-AzVm `
-ResourceGroupName "RG018" `
-Name "VM1" `
-Location "Southeast asia" `
-SecurityGroupName "VM1NSG" `
-PublicIpAddressName "VM1PubIP" `
-OpenPorts 80,443,3389 `
-Image "Win2012R2Datacenter" `
-Size "Standard_DS1_v2"


$connectTestResult = Test-NetConnection -ComputerName milanm101.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
# Save the password so the drive will persist on reboot
cmd.exe /C "cmdkey /add:`"milanm101.file.core.windows.net`" /user:`"localhost\milanm101`" /pass:`"OCUwtqFkyKf63u54vbXbSKwBQ+1u4CZIMjMFv2BXsGKbjdyGwXcie801xNXcocAxllSsaa5bY/6VrggVTcUkuw==`""
# Mount the drive
New-PSDrive -Name U -PSProvider FileSystem -Root "\\milanm101.file.core.windows.net\mmst101" -Persist
} else {
Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}


$connectTestResult = Test-NetConnection -ComputerName michaelm.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"michaelm.file.core.windows.net`" /user:`"localhost\michaelm`" /pass:`"sDpm76wZHdSA08quLdReBKe55/S0gV95juNTYVdL1YIEIJMKL86hC3hM/VbA/4qil1SRnEm/dogVBeS1hT/82g==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\michaelm.file.core.windows.net\michaelm-fs" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}