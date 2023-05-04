# prerequisites 
# Docker EE required Windows Server 2016 and higher
# Windows server STD 2016 - 10.0.14393 N/A Build 14393
# powershell version 5
set-executionpolicy -scope CurrentUser -executionPolicy Bypass -Force
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Install Docker Provider
Install-Package -Name DockerMsftProvider -Force
#Install Docker from Docker Provider
Install-Package -Name docker -ProviderName DockerMsftProvider -Force
Restart-Computer -Confirm