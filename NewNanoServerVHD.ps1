<#
Copyright 2015 Cloudbase Solutions Srl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

Param(
    [Parameter(Mandatory=$True)]
    [string]$IsoPath,
    [Parameter(Mandatory=$True)]
    [string]$TargetPath,
    [Parameter(Mandatory=$True)]
    [Security.SecureString]$AdministratorPassword,
    [string]$NanoServerDir = "C:\NanoServer"
)

$ErrorActionPreference = "Stop"

$isoMountDrive = (Mount-DiskImage $IsoPath -PassThru | Get-Volume).DriveLetter

try
{
    pushd "${isoMountDrive}:\NanoServer"
    try
    {
        . ".\new-nanoserverimage.ps1"
        New-NanoServerImage -MediaPath "${isoMountDrive}:\" -BasePath $NanoServerDir `
        -AdministratorPassword $AdministratorPassword -TargetPath $TargetPath `
        -GuestDrivers -ReverseForwarders
    }
    finally
    {
        popd
    }
}
finally
{
    Dismount-DiskImage $IsoPath
}
