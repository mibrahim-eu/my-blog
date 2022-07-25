$vCenterIP = "Your VC FQDN"
Connect-VIServer $vCenterIP -User $vCenterUser -Password $vCenterPass



$portGroups = Get-VirtualPortGroup
$vlans = @()
$j=0


foreach($portGroup in $portGroups)
{


#Get-VirtualPortGroup -Name $portGroup.name | Get-VM  | select name,PowerState, GuestID, MemoryGB, NumCpu,  @{N="UsedSpaceGB";E={[math]::round($_.UsedSpaceGB, 0)}} | Export-Csv C:\Users\mahmoud.ibrahim\Documents\classical.csv -Append



$VMs = Get-VirtualPortGroup -Name $portGroup.name | Get-VM


for($i = 0; $i -lt $VMs.length; $i++)
{

$VMs = Get-VirtualPortGroup -Name $portGroup.name | Get-VM 

$tempVM = get-vm -name $VMs.name

$clusterName = Get-Cluster -vm $tempVM[$i]

$usedspace = get-vm $tempVM[$i] | select UsedSpaceGB

$usedspace = [math]::round($usedspace.UsedSpaceGB, 0)

$Guest = $tempVM[$i].Guest
$OS = $Guest.OSFullName
$IP = $Guest.IPAddress
$IPSting = $IP | out-string
$NICs = (Get-NetworkAdapter -VM $tempVM[$i]).count  


$vlans += [pscustomobject]@{vlan = $portGroup.name ; VMsNumber = $VMs.length ; VMs = $VMs[$i].name ; Power = $tempVM[$i].PowerState ; MemoryGB = $tempVM[$i].MemoryGB ; NumCpu = $tempVM[$i].NumCpu ; Cluster = $clusterName.name ;UsedSpaceGB = $usedspace ; OS = $OS ; NICs =$NICs  ;  IP = $IPSting }

$vlans[$j]

$j = $j + 1

}

}








