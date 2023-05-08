# prerequisites 
# Docker EE required Windows Server 2016 and higher
# powershell version 5
<powershell>
set-executionpolicy -scope CurrentUser -executionPolicy Bypass -Force
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install Docker Provider
Install-Package -Name DockerMsftProvider -Force

# Install Docker from Docker Provider
Install-Package -Name docker -ProviderName DockerMsftProvider -Force

# Checking Status of Docker
docker version

# Install SSM Agent
Write-Host "Downloading SSM Agent installer"
Invoke-WebRequest "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe" -OutFile "C:\AmazonSSMAgentSetup.exe"
Write-Host "Installing SSM Agent"
Start-Process -FilePath "C:\AmazonSSMAgentSetup.exe" -ArgumentList @("/install", "/quiet") -Wait

# # Configure SSM Agent to allow connections
# Write-Host "Configuring SSM Agent to allow connections"
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Amazon\SSM" -Name "AllowRunCommand" -Value "true"
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Amazon\SSM" -Name "AllowSessionManager" -Value "true"

# Start SSM Agent service
Write-Host "Starting SSM Agent service"
Start-Service -Name "AmazonSSMAgent"
Set-Service -Name "AmazonSSMAgent" -StartupType Automatic

# Checking SSM Agent status
Restart-Service AmazonSSMAgent
Get-Service AmazonSSMAgent

Restart-Computer -Force
</powershell>