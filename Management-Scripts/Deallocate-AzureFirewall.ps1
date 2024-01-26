# Stop an existing firewall 
# This does not DELETE the FW, meaning you will still incur associated costs. A distinction with a difference!

$azfw = Get-AzFirewall -Name "FW-Cyber-Lab" -ResourceGroupName "RG-Cyber-Lab"
$azfw.Deallocate()
Set-AzFirewall -AzureFirewall $azfw