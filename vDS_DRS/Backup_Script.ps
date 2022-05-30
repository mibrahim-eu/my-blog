# Step 1 - Retrieve password and create backup directory by the date of the day
$path=New-Item -ItemType Directory -Path "C:\DRS_VDS_BKP\$((Get-Date).ToString('yyyy-MM-dd'))"
$keyFile = 'C:\Temp\aes.key'
$pswdFile = 'C:\Temp\pswd.txt'
$user = 'administrator@vsphere.local'
$encryptedPswd = Get-Content -Path $pswdFile | ConvertTo-SecureString -Key (Get-Content -Path $keyFile)
$cred = New-Object System.Management.Automation.PSCredential($user,$encryptedPswd)




# Step 2 - Use credential and connect to the vCenter
Connect-VIServer -Server "vCenter_FQDN" -Credential $cred



# Get the DRS rules and groups and VMHost Rules on the vCenter
Get-DrsClusterGroup -Cluster "CLUSTER_NAME" | select Name, Cluster, GroupType, @{Name="Member:"; Expression={[string]::Join(";", $_.Member)}}  | Export-Excel -workSheetName "groups" -path "$path\drs.xlsx"
Get-DrsRule -Cluster  "CLUSTER_NAME" | Select Name, Enabled, Type, @{Name="VM"; Expression={ $iTemp = @(); $_.VMIds | % { $iTemp += (Get-VM -Id $_).Name }; [string]::Join(";", $iTemp) }} | Export-Excel -workSheetName "rules" -path "$path\drs.xlsx"
Get-DrsVMHostRule | select Cluster,Name,Type,VMGroup,VMHostGroup,Enabled  | Export-Excel -workSheetName "vmhostrules" -path "$path\drs.xlsx"



# Backup the 2 vDS on the vCenter
Get-VDSwitch -Name "vDS1_Name" | Export-VDSwitch -Description "vCenter_Name-vds-BKP " -Destination "$path\vCenter_Name-vds.zip"
Get-VDSwitch -Name "vDS2_Name"  | Export-VDSwitch -Description "vCenter_Name-vds2-BKP " -Destination "$path\vCenter_Name-vds2.zip"


#Get-VDSwitch -Name "vDS1_Name" | Get-VDPortgroup | Get-VDUplinkTeamingPolicy | select VDPortgroup,LoadBalancingPolicy,ActiveUplinkPort | Format-Table -AutoSize | out-file "$path\vDS1-uplinks.txt"
Get-VDSwitch -Name "vDS1_Name" | Get-VDPortgroup | Get-VDUplinkTeamingPolicy | Select-Object VDPortgroup,LoadBalancingPolicy,ActiveUplinkPort,NotifySwitches,EnableFailback | Format-Table -Wrap -AutoSize | Out-String -Width 4096 | Out-File "$path\vDS1-uplinks.txt"
Get-VDSwitch -Name "vDS2_Name" | Get-VDPortgroup | Select-Object Name,VlanConfiguration,Key,PortBinding,NumPorts | Format-Table -Wrap -AutoSize | Out-String -Width 4096 | out-file "$path\vDS1-vlans.txt"

#Get-VDSwitch -Name "vDS2_Name" | Get-VDPortgroup | Get-VDUplinkTeamingPolicy | select VDPortgroup,LoadBalancingPolicy,ActiveUplinkPort | Format-Table -AutoSize | out-file "$path\vDS2-uplinks.txt"
Get-VDSwitch -Name "vDS2_Name" | Get-VDPortgroup | Get-VDUplinkTeamingPolicy | Select-Object VDPortgroup,LoadBalancingPolicy,ActiveUplinkPort,NotifySwitches,EnableFailback | Format-Table -Wrap -AutoSize | Out-String -Width 4096 | Out-File "$path\vDS2-uplinks.txt"
Get-VDSwitch -Name "vDS2_Name" | Get-VDPortgroup | Select-Object Name,VlanConfiguration,Key,PortBinding,NumPorts | Format-Table -Wrap -AutoSize | Out-String -Width 4096 | out-file "$path\vDS2-vlans.txt"


# Diconnect from the vCenter without confirmation
Disconnect-VIServer  -Server "vCenter_Name" -Confirm:$false
