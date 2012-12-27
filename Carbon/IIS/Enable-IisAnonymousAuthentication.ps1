# Copyright 2012 Aaron Jensen
# 
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

function Enable-IisAnonymousAuthentication
{
    <#
    .SYNOPSIS
    Enables anonymous authentication for all or part of a website.

    .DESCRIPTION
    By default, enables anonymous authentication on an entire website.  You can enable anonymous authentication at a specific path under a website by passing the virtual path (*not* the physical path) to that directory as the value of the `Path` parameter.

    .LINK
    Disable-IisAnonymousAuthentication
    
    .EXAMPLE
    Enable-IisAnonymousAuthentication -SiteName Peanuts

    Turns on anonymous authentication for the `Peanuts` website.

    .EXAMPLE
    Enable-IisAnonymouseAuthentication -SiteName Peanuts Snoopy/DogHouse

    Turns on anonymous authentication for the `Snoopy/DogHouse` directory under the `Peanuts` website.

    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        # The site where anonymous authentication should be set.
        $SiteName,
        
        [string]
        # The optional path where anonymous authentication should be set.
        $Path = ''
    )
    
    $authSettings = Get-IisSecurityAuthentication -SiteName $SiteName -Path $Path -Anonymous
    $authSettings.SetAttributeValue('enabled', 'true')
    if( $pscmdlet.ShouldProcess( "$SiteName/$Path", "enable anonymous authentication" ) )
    {
        $authSettings.CommitChanges()
    }
}

