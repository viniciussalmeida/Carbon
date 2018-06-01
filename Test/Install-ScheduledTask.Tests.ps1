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

#Requires -Version 4
Set-StrictMode -Version 'Latest'

$taskName = $null
$credential = $null
$AllMonths = @( 'January','February','March','April','May','June','July','August','September','October','November','December' )
$today = Get-Date
$today = New-Object 'DateTime' $today.Year,$today.Month,$today.Day

& (Join-Path -Path $PSScriptRoot -ChildPath 'Import-CarbonForTest.ps1' -Resolve)
$credential = New-Credential -User 'CarbonInstallSchedul' -Password 'a1b2c34d!'
Install-User -Credential $credential -Description 'Test user for running scheduled tasks.'

function Assert-TaskScheduled
{
    [CmdletBinding()]
    param(
        [hashtable]
        $InstallArguments,
    
        [hashtable]
        $AssertArguments
    )
    
    Set-StrictMode -Version Latest
    
    $InstallArguments['Name'] = $taskName
    $InstallArguments['TaskToRun'] = 'notepad'
    
    $AssertArguments['Name'] = $taskName
    $AssertArguments['TaskToRun'] = 'notepad'
    
    # Install to run as SYSTEM
    $task = Install-ScheduledTask -Principal System @InstallArguments
    $Global:Error.Count | Should Be 0
    $task | Should Not BeNullOrEmpty
    $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
    Assert-ScheduledTask -Principal 'System' @AssertArguments
    
    $preTask = Get-ScheduledTask -Name $taskName
    (Install-ScheduledTask -Principal System @InstallArguments) | Should BeNullOrEmpty
    $Global:Error.Count | Should Be 0
    $postTask = Get-ScheduledTask -Name $taskName
    $postTask.CreateDate | Should Be $preTask.CreateDate
    
    $InstallArguments['TaskCredential'] = $credential
    $InstallArguments['Force'] = $true
    $AssertArguments['TaskCredential'] = $credential
    
    $task = Install-ScheduledTask @InstallArguments
    $Global:Error.Count | Should Be 0
    $task | Should Not BeNullOrEmpty
    $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
    Assert-ScheduledTask @AssertArguments 
    
    # Install to start tomorrow
    # Check interval parameter
    $intervalSchedules = @( 'Daily', 'Weekly', 'Monthly', 'Month', 'LastDayOfMonth', 'WeekOfMonth' )
    foreach( $intervalSchedule in $intervalSchedules )
    {
        if( $InstallArguments.ContainsKey( $intervalSchedule ) )
        {
            $task = Install-ScheduledTask @InstallArguments -Interval 37 
            $task | Should Not BeNullOrEmpty
            $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
            Assert-ScheduledTask @AssertArguments -Interval 37 
            break
        }
    }
    
    if( -not $InstallArguments.ContainsKey('StartTime') )
    {
        $startTimeSchedules = @( 'Daily', 'Weekly', 'Monthly', 'Month', 'LastDayOfMonth', 'WeekOfMonth', 'Once' )
        foreach( $startTimeSchedule in $startTimeSchedules )
        {
            if( $InstallArguments.ContainsKey( $startTimeSchedule ) )
            {
                $task = Install-ScheduledTask @InstallArguments -StartTime '23:06'
                $Global:Error.Count | Should Be 0
                $task | Should Not BeNullOrEmpty
                $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
                Assert-ScheduledTask @AssertArguments -StartTime '23:06'
                break
            }
        }
    }
    
    $startDateSchedules =  @( 'Minute','Daily', 'Weekly', 'Monthly', 'Month', 'LastDayOfMonth', 'WeekOfMonth', 'Once' )
    foreach( $startDateSchedule in $startDateSchedules )
    {
        if( $InstallArguments.ContainsKey( $startDateSchedule ) )
        {
            $task = Install-ScheduledTask @InstallArguments -StartDate $today.AddDays(1)
            $Global:Error.Count | Should Be 0
            $task | Should Not BeNullOrEmpty
            $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
            Assert-ScheduledTask @AssertArguments -StartDate $today.AddDays(1)
        }
    }
    
    $durationSchedules = @( 'Minute', 'Daily', 'Weekly', 'Monthly', 'LastDayOfMonth', 'WeekOfMonth' )
    foreach( $durationSchedule in $durationSchedules )
    {
        if( $InstallArguments.ContainsKey( $durationSchedule ) )
        {
            $task = Install-ScheduledTask @InstallArguments -Duration '5:30'  # Using fractional hours to ensure it gets converted properly.
            $Global:Error.Count | Should Be 0
            $task | Should Not BeNullOrEmpty
            $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
            Assert-ScheduledTask @AssertArguments -Duration '5:30' 
            break
        }
    }
    
    $endDateSchedules = @( 'Daily', 'Weekly', 'Monthly', 'LastDayOfMonth', 'WeekOfMonth' )
    foreach( $endDateSchedule in $endDateSchedules )
    {
        if( $InstallArguments.ContainsKey( $endDateSchedule ) )
        {
            $task = Install-ScheduledTask @InstallArguments -EndDate $today.AddYears(1)
            $Global:Error.Count | Should Be 0
            $task | Should Not BeNullOrEmpty
            $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
            Assert-ScheduledTask @AssertArguments -EndDate $today.AddYears(1)
            break
        }
    }
    
    $endTimeSchedules = @( 'Minute', 'Hourly', 'Daily', 'Weekly', 'Monthly', 'LastDayOfMonth', 'WeekOfMonth' )
    $endTime = (Get-Date).AddHours(7)
    foreach( $endTimeSchedule in $endTimeSchedules )
    {
        if( $InstallArguments.ContainsKey( $endTimeSchedule ) )
        {
            $endTimeParams = @{
                                    EndDate = $endTime.ToString('MM/dd/yyyy')
                                    EndTime = $endTime.ToString('HH:mm');
                                }
            $task = Install-ScheduledTask @InstallArguments @endTimeParams
            $Global:Error.Count | Should Be 0
            $task | Should Not BeNullOrEmpty
            $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
            Assert-ScheduledTask @AssertArguments @endTimeParams
            break
        }
    }
    
    # Install as interactive
    $task = Install-ScheduledTask @InstallArguments -Interactive
    $Global:Error.Count | Should Be 0
    $task | Should Not BeNullOrEmpty
    $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
    Assert-ScheduledTask @AssertArguments -Interactive
    
    # Install as no password
    $task = Install-ScheduledTask @InstallArguments -NoPassword
    $Global:Error.Count | Should Be 0
    $task | Should Not BeNullOrEmpty
    $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
    Assert-ScheduledTask @AssertArguments -NoPassword
    
    # Install as highest run level
    $task = Install-ScheduledTask @InstallArguments -HighestAvailableRunLevel
    $Global:Error.Count | Should Be 0
    $task | Should Not BeNullOrEmpty
    $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
    Assert-ScheduledTask @AssertArguments -HighestAvailableRunLevel
    
    $delaySchedules = @( 'OnStart', 'OnLogon', 'OnEvent' )
    foreach( $delaySchedule in $delaySchedules )
    {
        if( $InstallArguments.ContainsKey( $delaySchedule ) )
        {
            $task = Install-ScheduledTask @InstallArguments -Delay '6.22:39:59'
            $Global:Error.Count | Should Be 0
            $task | Should Not BeNullOrEmpty
            $task | Should BeOfType ([Carbon.TaskScheduler.TaskInfo])
            Assert-ScheduledTask @AssertArguments -Delay '6.22:39:59'
            break
        }
    }
    
    
}
    
function Assert-ScheduledTask
{
    [CmdletBinding()]
    param(
        $Name,
        $TaskToRun,
        $TaskCredential,
        $Principal,
        $TaskXmlPath,
        $ScheduleType,
        $Modifier,
        [int[]]
        $DayOfMonth,
        [DayOfWeek[]]
        $DayOfWeek,
        [Carbon.TaskScheduler.Month[]]
        $Months,
        [int]
        $IdleTime,
        [TimeSpan]
        $StartTime,
        $Interval,
        [TimeSpan]
        $EndTime,
        [TimeSpan]
        $Duration,
        [Switch]
        $StopAtEnd,
        [DateTime]
        $StartDate,
        [DateTime]
        $EndDate,
        $EventChannelName,
        [Switch]
        $Interactive,
        [Switch]
        $NoPassword,
        [Switch]
        $HighestAvailableRunLevel,
        [timespan]
        $Delay
    )
    
    Set-StrictMode -Version 'Latest'
    
    (Test-ScheduledTask -Name $Name) | Should Be $true
    
    $task = Get-ScheduledTask -Name $Name
    $task | Format-List | Out-String | Write-Verbose
    $schedule = $task.Schedules[0]
    $schedule | Format-List | Out-String | Write-Verbose
    
    $task | Should Not BeNullOrEmpty
    schtasks /query /fo list /v /tn $task.FullName | Write-Verbose
    schtasks /query /xml /tn $task.FullName | Where-Object { $_ } | Write-Verbose
    $task.TaskToRun.Trim() | Should Be $TaskToRun
    
    if( $PSBoundParameters.ContainsKey('TaskCredential') )
    {
        $task.RunAsUser | Should Be $TaskCredential.Username
    }
    elseif( $PSBoundParameters.ContainsKey('Principal') )
    {
        $task.RunAsUser | Should Be $Principal
    }
    else
    {
        $task.RunAsUser | Should Be 'SYSTEM'
    }
    
    if( $HighestAvailableRunLevel )
    {
        $task.HighestAvailableRunLevel | Should Be $true
    }
    else
    {
        $task.HighestAvailableRunLevel | Should Be $false
    }
    
    if( $Interactive )
    {
        $task.Interactive | Should Be $true
    }
    else
    {
        $task.Interactive | Should Be $false
    }
    
    if( $NoPassword )
    {
        $task.NoPassword | Should Be $true
    }
    else
    {
        $task.NoPassword | Should Be $false
    }
    
    if( $PSBoundParameters.ContainsKey('ScheduleType') )
    {
        $schedule.ScheduleType | Should Be $ScheduleType
    }
    
    if( $PSBoundParameters.ContainsKey( 'Modifier' ) )
    {
        $schedule.Modifier | Should Be $Modifier
    }
    else
    {
        $schedule.Modifier | Should Be ''
    }
    
    if( $PSBoundParameters.ContainsKey('DayOfMonth') )
    {
        ($schedule.Days -join ',') | Should Be ($DayOfMonth -join ',')
    }
    else
    {
        $schedule.Days | Should BeNullOrEmpty
    }
    
    if( $PSBoundParameters.ContainsKey('DayOfWeek') )
    {
        ($schedule.DaysOfWeek -join ',') | Should Be ($DayOfWeek -join ',')
    }
    else
    {
        $schedule.DaysOfWeek | Should BeNullOrEmpty
    }
    
    if( $PSBoundParameters.ContainsKey('Months') )
    {
        ($schedule.Months -join ', ') | Should Be ($Months -join ', ')
    }
    else
    {
        $schedule.Months | Should BeNullOrEmpty
    }
    
    if( $PSBoundParameters.ContainsKey('StartDate') )
    {
        $schedule.StartDate | Should Be $StartDate
    }
    else
    {
        if( @('OnLogon', 'OnStart', 'OnIdle', 'OnEvent') -contains $ScheduleType )
        {
            $schedule.StartDate | Should Be ([DateTime]::MinValue)
        }
        else
        {
            $Schedule.StartDate | Should Be (New-Object 'DateTime' $today.Year,$today.Month,$today.Day)
        }
    }
    
    if( $PSBoundParameters.ContainsKey('Duration') )
    {
        $schedule.RepeatUntilDuration | Should Be $Duration
    }
    
    if( $StopAtEnd )
    {
        $schedule.StopAtEnd | Should Be $true
    }
    else
    {
        $schedule.StopAtEnd | Should Be $false
    }
    
    if( $PSBoundParameters.ContainsKey('Interval') )
    {
        $schedule.Interval | Should Be $Interval
    }
    else
    {
        if( (@('Daily','Weekly','Monthly','Once') -contains $schedule.ScheduleType) -and ($PSBoundParameters.ContainsKey('EndTime') -or $PSBoundParameters.ContainsKey('Duration')) )
        {
            $schedule.Interval | Should Be 10
        }
        else
        {
            $schedule.Interval | Should Be 0
        }
    }
    
    if( $PSBoundParameters.ContainsKey('StartTime') )
    {
        $schedule.StartTime | Should Be $StartTime
    }
    else
    {
        if( @('OnLogon', 'OnStart', 'OnIdle', 'OnEvent') -contains $ScheduleType )
        {
            $schedule.StartTime | Should Be ([TimeSpan]::Zero)
        }
        else
        {
            $schedule.StartTime | Should Be (New-Object 'TimeSpan' $task.CreateDate.Hour,$task.CreateDate.Minute,0)
        }
    }
    
    if( $PSBoundParameters.ContainsKey('EndTime') )
    {
        $schedule.EndTime | Should Be $EndTime
    }
    else
    {
        $schedule.EndTime | Should Be ([TimeSpan]::Zero)
    }
    
    if( $PSBoundParameters.ContainsKey('EndDate') )
    {
        $schedule.EndDate | Should Be $EndDate
    }
    else
    {
        $schedule.EndDate | Should Be ([datetime]::MaxValue)
    }
    
    if( $PSBoundParameters.ContainsKey('Delay') )
    {
        $schedule.Delay | Should Be $Delay
    }
    else
    {
        $schedule.Delay | Should Be ([TimeSpan]::Zero)
    }
    
    if( $PSBoundParameters.ContainsKey('IdleTime') )
    {
        $schedule.IdleTime | Should Be $IdleTime
    }
    else
    {
        $schedule.IdleTime | Should Be 0
    }
    
    if( $PSBoundParameters.ContainsKey('EventChannelName') )
    {
        $schedule.EventChannelName | Should Be $EventChannelName
    }
    else
    {
        $schedule.EventChannelName | Should BeNullOrEmpty
    }
}

Describe 'Install-ScheduledTask' {
    BeforeEach {
        $Global:Error.Clear()
        $script:taskName = 'CarbonInstallScheduledTask{0}' -f [Guid]::NewGuid()
        Uninstall-ScheduledTask -Name $taskName
        $Global:Error.Count | Should Be 0
    }
    
    AfterEach {
        $Global:Error.Clear()
        Get-ScheduledTask -Name '*CarbonInstallScheduledTask*' |
            ForEach-Object { Uninstall-ScheduledTask -Name $_.TaskName }
        $Global:Error.Count | Should Be 0
    }
    <#
    It 'should create scheduled task with path' {
        $fullName = 'PARENT\{0}' -f $taskName
        $result = Install-ScheduledTask -Name $fullName -TaskToRun 'notepad' -Monthly -Force
        try
        {
            $result | Should Not BeNullOrEmpty
            $result.TaskPath | Should Be '\PARENT\'
            $result.TaskName | Should Be $taskName
            $result.FullName | Should Be ('\{0}' -f $fullName)
        }
        finally
        {
            Uninstall-ScheduledTask -Name $fullName
        }
    }
    
    It 'should schedule per minute tasks' {
        Assert-TaskScheduled -InstallArguments @{ Minute = 5 } -AssertArguments @{ ScheduleType = 'Minute'; Modifier = 5 }
    }
    
    It 'should schedule hourly tasks' {
        Assert-TaskScheduled -InstallArguments @{ Hourly = 23 } -AssertArguments @{ ScheduleType = 'Hourly'; Modifier = 23 }
    }
    
    It 'should schedule daily tasks' {
        Assert-TaskScheduled -InstallArguments @{ Daily = 29 } -AssertArguments @{ ScheduleType = 'Daily'; Modifier = 29;  }
    }
    
    It 'should schedule weekly tasks' {
        Assert-TaskScheduled -InstallArguments @{ Weekly = 39 } -AssertArguments @{ ScheduleType = 'Weekly'; Modifier = 39; DayOfWeek = $today.DayOfWeek; }
    }
    
    It 'should schedule weekly tasks on specific day' {
        Assert-TaskScheduled -InstallArguments @{ Weekly = 39; DayOfWeek = 'Sunday'; } -AssertArguments @{ ScheduleType = 'Weekly'; Modifier = 39; DayOfWeek = 'Sunday'; }
    }
    
    It 'should schedule weekly tasks on multiple days' {
        Assert-TaskScheduled -InstallArguments @{ Weekly = 39; DayOfWeek = @('Monday','Tuesday','Wednesday'); } -AssertArguments @{ ScheduleType = 'Weekly'; Modifier = 39; DayOfWeek = @('Monday','Tuesday','Wednesday'); }
    }
    
    It 'should schedule monthly tasks' {
        Assert-TaskScheduled -InstallArguments @{ Monthly = $true; } -AssertArguments @{ ScheduleType = 'Monthly'; Modifier = 1; DayOfMonth = 1; Month = $AllMonths }
    }
    
    It 'should schedule monthly tasks on specific day' {
        Assert-TaskScheduled -InstallArguments @{ Monthly = $true; DayOfMonth = 13; } -AssertArguments @{ ScheduleType = 'Monthly'; Modifier = 1; DayOfMonth = 13; Month = $AllMonths }
    }
    
    It 'should schedule last day of the month task' {
        Assert-TaskScheduled -InstallArguments @{ LastDayOfMonth = $true; } -AssertArguments @{ ScheduleType = 'Monthly'; Modifier = 'LastDay'; Month = $AllMonths; }
    }
    
    It 'should schedule last day of the month task in specific month' {
        Assert-TaskScheduled -InstallArguments @{ LastDayOfMonth = $true; Month = @( 'January' ); } -AssertArguments @{ ScheduleType = 'Monthly'; Modifier = 'LastDay'; Month = @( 'January' ); }
    }
    
    It 'should schedule last day of the month task in specific months' {
        Assert-TaskScheduled -InstallArguments @{ LastDayOfMonth = $true; Month = @( 'January','June' ); } -AssertArguments @{ ScheduleType = 'Monthly'; Modifier = 'LastDay'; Month = @( 'January','June' ); }
    }
    
    It 'should schedule for specific month' {
        Assert-TaskScheduled -InstallArguments @{ Month = @( 'January' ); DayOfMonth = 1; } -AssertArguments @{ ScheduleType = 'Monthly'; Month = @( 'January' ); DayOfMonth = 1; }
    }
    
    It 'should schedule for specific month with integer' {
        Assert-TaskScheduled -InstallArguments @{ Month = @( 1 ); DayOfMonth = 19; } -AssertArguments @{ ScheduleType = 'Monthly'; Month = @( 'January' ); DayOfMonth = 19; }
    }
    
    It 'should schedule for specific months' {
        Assert-TaskScheduled -InstallArguments @{ Month = @( 'January','April','July','October' ); DayOfMonth = 23; } -AssertArguments @{ ScheduleType = 'Monthly'; Month = @( 'January','April','July','October' ); DayOfMonth = 23; }
    }
    
    It 'should not schedule monthly task with month parameter' {
        $result = Install-ScheduledTask -Name $taskName -Principal LocalService -TaskToRun 'notepad' -Month $AllMonths -DayOfMonth 17 -ErrorAction SilentlyContinue
        $Global:Error.Count | Should BeGreaterThan 0
        $Global:Error[0] | Should Match 'to schedule a monthly task'
        $result | Should BeNullOrEmpty
        (Test-ScheduledTask -Name $taskName) | Should Be $false
    }
    
    It 'should schedule for specific months on specific day' {
        Assert-TaskScheduled -InstallArguments @{ Month = @( 'January','April','July','October' ); DayOfMonth = 5;  } -AssertArguments @{ ScheduleType = 'Monthly'; Month = @( 'January','April','July','October' ); DayOfMonth = 5; }
    }
    
    It 'should schedule week of month tasks' {
        Assert-TaskScheduled -InstallArguments @{ WeekOfMonth = 'First'; DayOfWeek = $today.DayOfWeek } -AssertArguments @{ ScheduleType = 'Monthly'; Modifier = 'First'; Month = $AllMonths; DayOfWeek = $today.DayOfWeek; }
    }
    
    It 'should not schedule week of month on multiple week days' {
        $result = Install-ScheduledTask -Name $taskName -Principal LocalService -TaskToRun 'notepad' -WeekOfMonth First -DayOfWeek Friday,Monday -ErrorAction SilentlyContinue
        $Global:Error.Count | Should BeGreaterThan 0
        $Global:Error[0] | Should Match 'single weekday'
        $result | Should BeNullOrEmpty
        (Test-ScheduledTask -Name $taskName) | Should Be $false
    }
    
    It 'should schedule week of month tasks on each week' {
        foreach( $week in @( 'First', 'Second', 'Third', 'Fourth', 'Last' ) )
        {
            $result = Install-ScheduledTask -Name $taskName -Principal LocalService -TaskToRun 'notepad' -WeekOfMonth $week -DayOfWeek $today.DayOfWeek -Force
            $Global:Error.Count | Should Be 0
            $result | Should Not BeNullOrEmpty
            Assert-ScheduledTask -Name $taskName -Principal 'Local Service' -TaskToRun 'notepad' -ScheduleType 'Monthly' -Modifier $week -DayOfWeek $today.DayOfWeek -Months $AllMonths
        }
    }
    
    It 'should schedule task to run once' {
        Assert-TaskScheduled -InstallArguments @{ Once = $true; StartTime = '3:03' } -AssertArguments @{ ScheduleType = 'Once'; StartTime = '3:03'; }
    }
    
    It 'should schedule task to run at logon' {
        Assert-TaskScheduled -InstallArguments @{ OnLogon = $true; } -AssertArguments @{ ScheduleType = 'OnLogon'; }
    }
    
    It 'should schedule task to run at start' {
        Assert-TaskScheduled -InstallArguments @{ OnStart = $true; } -AssertArguments @{ ScheduleType = 'OnStart'; }
    }
    
    It 'should schedule task to run on idle' {
        Assert-TaskScheduled -InstallArguments @{ OnIdle = 999; } -AssertArguments @{ ScheduleType = 'OnIdle'; IdleTime = 999; }
    }
    
    It 'should schedule task to run on event' {
        Assert-TaskScheduled -InstallArguments @{ OnEvent = $true ; EventChannelName = 'System' ; EventXPathQuery = '*[System/EventID=101]'; } -AssertArguments @{ ScheduleType = 'OnEvent'; Modifier = '*[System/EventID=101]'; EventChannelName = 'System'; }
    }
    #>
    function Assert-TaskScheduledFromXml
    {
        [CmdletBinding()]
        param(
            $Path,
            $Xml,
            $TaskCredential
        )
    
        Set-StrictMode -Version 'Latest'
    
        $installParams = @{ }
        if( $TaskCredential )
        {
            $installParams['TaskCredential'] = $TaskCredential
        }
    
        if( $Path )
        {
            $installParams['TaskXmlFilePath'] = $Path
        }
    
        if( $Xml )
        {
            $installParams['TaskXml'] = $Xml
        }
    
        $task = Install-ScheduledTask -Name $taskName @installParams
        $task | Should Not BeNullOrEmpty
        $Global:Error.Count | Should Be 0
        # Now, make sure task doesn't get re-created if it already exists.
        (Install-ScheduledTask -Name $taskName @installParams) | Should BeNullOrEmpty
        $Global:Error.Count | Should Be 0
        $task = Get-ScheduledTask -Name $taskName
        $task | Should Not BeNullOrEmpty
        $task.TaskName | Should Be $taskName
        if( $TaskCredential )
        {
            $task.RunAsUser | Should Be $TaskCredential.Username
        }
        else
        {
            $task.RunAsUser | Should Be 'System'
        }
    
        if( $Path )
        {
            $Xml = [xml]((Get-Content -Path $Path) -join ([Environment]::NewLine))
        }
        else
        {
            $Xml = [xml]$Xml
        }
    
        $actualXml = schtasks /query /tn $taskName /xml | Where-Object { $_ }
        $actualXml = $actualXml -join ([Environment]::NewLine)
        $actualXml = [xml]$actualXml
        $actualXml.OuterXml | Should Be $Xml.OuterXml
    
        if( $Path )
        {
            $Path | Should -Exist
        }
        else
        {
            (Get-ChildItem -Path $env:TEMP 'Carbon+Install-ScheduledTask+*') | Should BeNullOrEmpty
        }
    }
    
    It 'should install from xml file with relative path' {
        Push-Location -Path $PSScriptRoot
        try
        {
            Assert-TaskScheduledFromXml -Path 'ScheduledTasks\task.xml' -TaskCredential $credential
        }
        finally
        {
            Pop-Location
        }
    }
    
    It 'should install from xml file with absolute path' {
        Assert-TaskScheduledFromXml -Path (Join-Path -Path $PSScriptRoot -ChildPath 'ScheduledTasks\task.xml') -TaskCredential $credential
    }
    
    It 'should install from xml file for system user' {
        Assert-TaskScheduledFromXml -Path (Join-Path -Path $PSScriptRoot -ChildPath 'ScheduledTasks\task_with_principal.xml')
    }
    
    It 'should install from xml' {
        Assert-TaskScheduledFromXml -Xml ((Get-Content -Path (Join-Path -Path $PSScriptRoot -ChildPath 'ScheduledTasks\task_with_principal.xml')) -join ([Environment]::NewLine))
    }
}