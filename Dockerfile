# Windows image for 20H2 x64 Arch
# FROM mcr.microsoft.com/windows:20H2-amd64
FROM mcr.microsoft.com/windows/server:ltsc2022

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install Chocolatey package manager
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install latest version of Google Chrome
RUN choco install googlechrome --ignore-checksums -y

# Install latest version of Microsoft Edge
RUN choco install microsoft-edge -y

# Install latest version of Mozilla Firefox
RUN choco install firefox -y

# Install Python and pip
RUN choco install python3 --version=3.9.7 --params "/InstallDir:C:\Python" -y
# RUN setx /M PATH "%PATH%;C:\Python;C:\Python\Scripts"

# Install Robot Framework
RUN pip install --no-cache-dir robotframework

# Set the working directory to /tests
WORKDIR /tests

# Add missing directory for ink file
# RUN mkdir -p '"C:/Program Files (x86)/Common Files/Microsoft Shared/ink/en-US"'

# Copy your test files into the container
COPY . .

#install requirements
RUN pip install --no-cache-dir -r requirements.txt

# Set the entry point to run Robot Framework tests
ENTRYPOINT ["powershell.exe"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]

CMD [ "robot", "test_combined.robot" ]