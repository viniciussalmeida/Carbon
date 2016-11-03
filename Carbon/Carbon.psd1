# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Module manifest for module 'Carbon'
#
# Generated by: Aaron Jensen
#
# Generated on: 8/30/2011
#

#Requires -Version 4

@{

    # Script module or binary module file associated with this manifest
    RootModule = 'Carbon.psm1'

    # Version number of this module.
    ModuleVersion = '2.4.0'

    # ID used to uniquely identify this module
    GUID = '075d9444-c01b-48c3-889a-0b3490716fa2'

    # Author of this module
    Author = 'Aaron Jensen'

    # Company or vendor of this module
    CompanyName = ''

    # Copyright statement for this module
    Copyright = 'Copyright 2011 - 2016 Aaron Jensen.'
    
    # Description of the functionality provided by this module
    Description = @'
Carbon is a PowerShell module for automating the configuration Windows 7, 8, 2008, and 2012 and automation the installation and configuration of Windows applications, websites, and services. It can configure and manage:

 * Local users and groups
 * IIS websites, virtual directories, and applications
 * File system, registry, and certificate permissions
 * Certificates
 * Privileges
 * Services
 * Encryption
 * Junctions
 * Hosts file
 * INI files
 * Performance counters
 * Shares
 * .NET connection strings and app settings
 * And much more!

All functions are idempotent: when run multiple times with the same arguments, your system will be in the same state without failing or producing errors.
'@

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '4.0'

    # Name of the Windows PowerShell host required by this module
    PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    PowerShellHostVersion = ''

    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion = ''

    # Processor architecture (None, X86, Amd64, IA64) required by this module
    ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @( 'bin\Carbon.dll' )

    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess = 'Carbon.types.ps1xml'

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @( 'Carbon.format.ps1xml', 'Formats\Carbon.Security.HttpUrlAcl.format.ps1xml' )

    # Modules to import as nested modules of the module specified in ModuleToProcess
    NestedModules = @()

    # Functions to export from this module
    FunctionsToExport = @(
                            'Add-GroupMember',
                            'Add-IisDefaultDocument',
                            'Add-TrustedHost',
                            'Assert-AdminPrivilege',
                            'Assert-FirewallConfigurable',
                            'Assert-Service',
                            'Clear-DscLocalResourceCache',
                            'Clear-MofAuthoringMetadata',
                            'Clear-TrustedHost',
                            'Complete-Job',
                            'Compress-Item',
                            'ConvertFrom-Base64',
                            'Convert-SecureStringToString',
                            'ConvertTo-Base64',
                            'ConvertTo-ContainerInheritanceFlags',
                            'ConvertTo-InheritanceFlag',
                            'ConvertTo-PropagationFlag',
                            'ConvertTo-SecurityIdentifier',
                            'Convert-XmlFile',
                            'Copy-DscResource',
                            'Disable-FirewallStatefulFtp',
                            'Disable-IEEnhancedSecurityConfiguration',
                            'Disable-IisSecurityAuthentication',
                            'Disable-NtfsCompression',
                            'Enable-AclInheritance',
                            'Enable-FirewallStatefulFtp',
                            'Enable-IEActivationPermission',
                            'Enable-IisDirectoryBrowsing',
                            'Enable-IisSecurityAuthentication',
                            'Enable-IisSsl',
                            'Enable-NtfsCompression',
                            'Expand-Item',
                            'Find-ADUser',
                            'Format-ADSearchFilterValue',
                            'Get-ADDomainController',
                            'Get-Certificate',
                            'Get-CertificateStore',
                            'Get-ComPermission',
                            'Get-ComSecurityDescriptor',
                            'Get-DscError',
                            'Get-DscWinEvent',
                            'Get-FileShare',
                            'Get-FileSharePermission',
                            'Get-FirewallRule',
                            'Get-Group',
                            'Get-HttpUrlAcl',
                            'Get-IisApplication',
                            'Get-IisAppPool',
                            'Get-IisConfigurationSection',
                            'Get-IisHttpHeader',
                            'Get-IisHttpRedirect',
                            'Get-IisMimeMap',
                            'Get-IisSecurityAuthentication',
                            'Get-IisVersion',
                            'Get-IisWebsite',
                            'Get-IPAddress',
                            'Get-Msi',
                            'Get-MsmqMessageQueue',
                            'Get-MsmqMessageQueuePath',
                            'Get-PathProvider',
                            'Get-PathToHostsFile',
                            'Get-PerformanceCounter',
                            'Get-Permission',
                            'Get-PowerShellModuleInstallPath',
                            'Get-PowershellPath',
                            'Get-Privilege',
                            'Get-ProgramInstallInfo',
                            'Get-RegistryKeyValue',
                            'Get-ScheduledTask',
                            'Get-ServiceAcl',
                            'Get-ServiceConfiguration',
                            'Get-ServicePermission',
                            'Get-ServiceSecurityDescriptor',
                            'Get-SslCertificateBinding',
                            'Get-TrustedHost',
                            'Get-User',
                            'Get-WindowsFeature',
                            'Get-WmiLocalUserAccount',
                            'Grant-ComPermission',
                            'Grant-HttpUrlPermission',
                            'Grant-MsmqMessageQueuePermission',
                            'Grant-Permission',
                            'Grant-Privilege',
                            'Grant-ServiceControlPermission',
                            'Grant-ServicePermission',
                            'Initialize-Lcm',
                            'Install-Certificate',
                            'Install-Directory',
                            'Install-FileShare',
                            'Install-Group',
                            'Install-IisApplication',
                            'Install-IisAppPool',
                            'Install-IisVirtualDirectory',
                            'Install-IisWebsite',
                            'Install-Junction',
                            'Install-Msi',
                            'Install-Msmq',
                            'Install-MsmqMessageQueue',
                            'Install-PerformanceCounter',
                            'Install-RegistryKey',
                            'Install-ScheduledTask',
                            'Install-Service',
                            'Install-User',
                            'Install-WindowsFeature',
                            'Invoke-AppCmd',
                            'Invoke-PowerShell',
                            'Join-IisVirtualPath',
                            'Lock-IisConfigurationSection',
                            'New-Credential',
                            'New-Junction',
                            'New-RsaKeyPair',
                            'New-TempDirectory',
                            'Protect-Acl',
                            'Protect-String',
                            'Read-File',
                            'Remove-DotNetAppSetting',
                            'Remove-EnvironmentVariable',
                            'Remove-GroupMember',
                            'Remove-HostsEntry',
                            'Remove-IisMimeMap',
                            'Remove-IniEntry',
                            'Remove-Junction',
                            'Remove-RegistryKeyValue',
                            'Remove-SslCertificateBinding',
                            'Reset-HostsFile',
                            'Reset-MsmqQueueManagerID',
                            'Resolve-FullPath',
                            'Resolve-Identity',
                            'Resolve-IdentityName',
                            'Resolve-NetPath',
                            'Resolve-PathCase',
                            'Resolve-RelativePath',
                            'Restart-RemoteService',
                            'Revoke-ComPermission',
                            'Revoke-HttpUrlPermission',
                            'Revoke-Permission',
                            'Revoke-Privilege',
                            'Revoke-ServicePermission',
                            'Set-DotNetAppSetting',
                            'Set-DotNetConnectionString',
                            'Set-EnvironmentVariable',
                            'Set-HostsEntry',
                            'Set-IisHttpHeader',
                            'Set-IisHttpRedirect',
                            'Set-IisMimeMap',
                            'Set-IisWebsiteID',
                            'Set-IisWebsiteSslCertificate',
                            'Set-IisWindowsAuthentication',
                            'Set-IniEntry',
                            'Set-RegistryKeyValue',
                            'Set-ServiceAcl',
                            'Set-SslCertificateBinding',
                            'Set-TrustedHost',
                            'Split-Ini',
                            'Start-DscPullConfiguration',
                            'Test-AdminPrivilege',
                            'Test-DotNet',
                            'Test-DscTargetResource',
                            'Test-FileShare',
                            'Test-FirewallStatefulFtp',
                            'Test-Group',
                            'Test-GroupMember',
                            'Test-Identity',
                            'Test-IisAppPool',
                            'Test-IisConfigurationSection',
                            'Test-IisSecurityAuthentication',
                            'Test-IisWebsite',
                            'Test-IPAddress',
                            'Test-MsmqMessageQueue',
                            'Test-NtfsCompression',
                            'Test-OSIs32Bit',
                            'Test-OSIs64Bit',
                            'Test-PathIsJunction',
                            'Test-PerformanceCounter',
                            'Test-PerformanceCounterCategory',
                            'Test-Permission',
                            'Test-PowerShellIs32Bit',
                            'Test-PowerShellIs64Bit',
                            'Test-Privilege',
                            'Test-RegistryKeyValue',
                            'Test-ScheduledTask',
                            'Test-Service',
                            'Test-SslCertificateBinding',
                            'Test-TypeDataMember',
                            'Test-UncPath',
                            'Test-User',
                            'Test-WindowsFeature',
                            'Test-ZipFile',
                            'Uninstall-Certificate',
                            'Uninstall-Directory',
                            'Uninstall-FileShare',
                            'Uninstall-Group',
                            'Uninstall-IisAppPool',
                            'Uninstall-IisWebsite',
                            'Uninstall-Junction',
                            'Uninstall-MsmqMessageQueue',
                            'Uninstall-PerformanceCounterCategory',
                            'Uninstall-ScheduledTask',
                            'Uninstall-Service',
                            'Uninstall-User',
                            'Uninstall-WindowsFeature',
                            'Unlock-IisConfigurationSection',
                            'Unprotect-String',
                            'Write-DscError',
                            'Write-File'
                        )

    # Cmdlets to export from this module
    CmdletsToExport = ''

    # Variables to export from this module
    VariablesToExport = ''

    # Aliases to export from this module
    AliasesToExport = '*'

    # List of all modules packaged with this module
    ModuleList = @()

    # List of all files packaged with this module
    FileList = @()

    # Private data to pass to the module specified in ModuleToProcess
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('.net','acl','active-directory','certificates','com','compression','computer','credential','cryptography','directory','dsc','dsc-resources','encryption','environment','file-system','firewall','groups','hosts-file','http','identity','iis','ini','installers','internet-explorer','ip','junctions','msi','msmq','netsh','networking','ntfs','operating-system','os','path','performance-counters','powershell','principal','privileges','programs','registry','rsa','scheduled-tasks','security','service','shares','sid','smb','ssl','text','trusted-host','users','wcf','windows','windows-features','xml','zip','PSModule','DscResources','setup','automation','admin')

            # A URL to the license for this module.
            LicenseUri = 'http://www.apache.org/licenses/LICENSE-2.0'

            # A URL to the main website for this project.
            ProjectUri = 'http://get-carbon.org/'

            # ReleaseNotes of this module
            ReleaseNotes = @'
## Enhancements

 * `Protect-String` can now encrypt with a key, password, or passphrase (i.e. it can now encrypt with symmetric encryption).
 * `Unprotect-String` can now decrypt with a key, password, or passphrase (i.e. it can now decrypt using symmetric encryption).
 * `Set-HostsEntry` now supports IPv6 addresses ([fixes issue](https://bitbucket.org/splatteredbits/carbon/issues/181/community-set-hostsentry-add-support-for)).
 * `Grant-Permission` now supports creating `Deny` access rules. Use the new `Type` parameter. [Fixes issue #152.](https://bitbucket.org/splatteredbits/carbon/issues/152)
 * `Set-EnvironmentVariable`: 
   * Added `-Force` switch to make all variable modifications immediately visible in the current PowerShell process's `env:` drive. Restarts are no longer required.
   * You can now set an environment variable for other users. Use the `Credential` parameter to specify the user's credentials. [Fixes issue #151.](https://bitbucket.org/splatteredbits/carbon/issues/151)
 * `Remove-EnvironmentVariable`: 
   * Added `-Force` switch to make all variable removals immediately visible in the current PowerShell process's `env:` drive. Restarts are no longer required.
   * You can now remove variables from multiple targets/scopes at once.
   * You can now remove an environment variable for other users. Use the `Credential` parameter to specify the user's credentials.
 * `Invoke-PowerShell`:
   * It now runs PowerShell commands. Pass a string of PowerShell code with the `Command` parameter. 
   * It now runs encoded PowerShell commands. Pass the string of PowerShell code with the `Command` parameter and use the `-Encode` switch.
   * It now runs scripts and commands as another user. Use the `Credential` parameter to pass the user's credentials along with the `FilePath` and `Command` parameters to run scripts and commands, respectively.
   
## Bug Fixes

 * Fixed: `Set-RegistryKeyValue` fails when `-String` parameter's value is `$null` or empty ([fixes issue #211](https://bitbucket.org/splatteredbits/carbon/issues/211/set-registrykeyvalue-null-string-invalid)).
 * Fixed: Can't import Carbon in a 32-bit PowerShell 4 session on a 64-bit operating system ([fixes issue #199](https://bitbucket.org/splatteredbits/carbon/issues/199/community-issue-importing-carbon-on-x64)).
 * Fixed: Documentation for the `Install-ScheduledTask` function's `HighestAvailableRunLevel` is lying ([fixes issue #205](https://bitbucket.org/splatteredbits/carbon/issues/205/documentation-install-scheduledtask-typo)).
 * Fixed: `Carbon_FirewallRule` fails when `Profile` property set to multiple values ([fixes issue #209](https://bitbucket.org/splatteredbits/carbon/issues/209/dsc-carbon_firewallrule-does-not-accept)).
 * Fixed: `Install-IisAppPool` can't set .NET framework version to `No Managed Code` ([fixes issue #210](https://bitbucket.org/splatteredbits/carbon/issues/210/install-iisapppool-need-to-be-able-to-set)).
 * Fixed: `Get-SslCertificateBinding` fails if the operating system's culture is not `en-US` ([fixes issue #171](https://bitbucket.org/splatteredbits/carbon/issues/171/get-sslcertificatebinding-fails-when-os)).
 * Fixed: `Install-ScheduledTask` fails when creating a task that runs during a specific week of the month on Sundays. (You're going to love this: the underlying int value for `[DayOfWeek]::Sunday` is `0`, so when testing if a `DayOfWeek` typed variable set to `Sunday` has a value, it returns `$false`. This made `Install-ScheduledTask` add the `/D` parameter without a value.
'@
        } # End of PSData hashtable
    
    } # End of PrivateData hashtable
}
