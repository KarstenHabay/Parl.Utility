function Get-ParlLoggedInUser
{
    <#
    .SYNOPSIS
        Retrieves information about logged-in users on one or more remote computers.

    .DESCRIPTION
        The Get-ParlLoggedInUser function queries one or more remote computers to retrieve information about logged-in users.
        It uses the 'quser' command to gather session details and can optionally log off users.

    .PARAMETER ComputerName
        Specifies the name of the remote computer(s) to query.
        If not specified, the function uses the local computer name by default.

    .PARAMETER UserName
        Specifies the username to filter the results.
        Only sessions matching this username will be returned.

    .PARAMETER Exclude
        Specifies a string to exclude certain usernames from the results.
        Any session with a username that matches this string will be excluded.

    .PARAMETER Logoff
        Indicates that the function should log off the users found.
        If this switch is specified, the function will log off the users after retrieving their session information.

    .EXAMPLE
        Get-ParlLoggedInUser -ComputerName "Server01"

        Retrieves information about all logged-in users on the computer named "Server01".

    .EXAMPLE
        Get-ParlLoggedInUser -ComputerName "Server01", "Server02" -UserName "jdoe"

        Retrieves information about the user "jdoe" on the computers "Server01" and "Server02".

    .EXAMPLE
        Get-ParlLoggedInUser -ComputerName "Server01" -Exclude "admin"

        Retrieves information about all logged-in users on "Server01", excluding any usernames that contain "admin".

    .EXAMPLE
        Get-ParlLoggedInUser -ComputerName "Server01" -Logoff

        Retrieves information about all logged-in users on "Server01" and logs them off.

    .NOTES
        Name: Get-ParlLoggedInUser
        Original Author: Paul Contreras
        Adaptation Author: Karsten Habay
        DateUpdated: 2024-07-11

    .LINK
        https://thesysadminchannel.com/get-logged-in-users-using-powershell/ -
        Original article with unaltered version.
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Scope='Function')]

    [CmdletBinding()]
    param (
        [Parameter(
            Position=0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string[]]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter()]
        [Alias("SamAccountName")]
        [string]
        $UserName,

        [Parameter()]
        [string]
        $Exclude,

        [Parameter()]
        [switch]
        $Logoff
    ) #param

    begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"

        Write-Verbose "[META   ] Computer  = $env:COMPUTERNAME"
        Write-Verbose "[META   ] User      = $env:USERDOMAIN\$env:USERNAME"
        Write-Verbose "[META   ] Command   = $($MyInvocation.Mycommand)"
        Write-Verbose "[META   ] PSEdition = $($PSVersionTable.PSEdition)"
        Write-Verbose "[META   ] PSVersion = $($PSVersionTable.PSVersion)"
        Write-Verbose "[META   ] Test Date = $(Get-Date)"
    } #begin

    process {
        Write-Verbose "[PROCESS] Running through all given Computers: $ComputerName"
        foreach ($Computer in $ComputerName)
        {
            Write-Verbose "[PROCESS] Running on computer: $Computer"
            try
            {
                $Computer = $Computer.ToUpper()
                $SessionList = quser /Server:$Computer 2>$null
                Write-Verbose "[PROCESS] Get list with Sessions: $SessionList"
                if ($SessionList)
                {
                    foreach ($Session in ($SessionList | Select-Object -Skip 1))
                    {
                        $Session = $Session.ToString().trim() -replace '\s+', ' ' -replace '>', ''
                        Write-Verbose "Running session: $Session"
                        $TestName = $session.Split(' ')[0]

                        if ($PSBoundParameters.ContainsKey('Username'))
                        {
                            Write-Verbose "Command contains -UserName: $UserName"
                            if ($TestName -ne $UserName)
                            {
                                Write-Verbose "Session with Name $TestName <> $UserName >> Skip to next Session"
                                continue
                            }
                        }

                        if ($PSBoundParameters.ContainsKey('Exclude'))
                        {
                            Write-Verbose "Command contains -Exclude $Exclude"
                            if ($TestName -ilike "*$Exclude*")
                            {
                                Write-Verbose "Session with Name $TestName <> $Exclude >> Skip to next Session"
                                continue
                            }
                        }

                        Write-Verbose 'Creating User Session information object'
                        $UserInfo = if ($Session.Split(' ')[3] -eq 'Active')
                        {
                            [PSCustomObject]@{
                                ComputerName = $Computer
                                UserName     = $session.Split(' ')[0]
                                SessionName  = $session.Split(' ')[1]
                                SessionID    = $Session.Split(' ')[2]
                                SessionState = $Session.Split(' ')[3]
                                IdleTime     = $Session.Split(' ')[4]
                                LogonTime    = $session.Split(' ')[5, 6, 7] -as [string] -as [datetime]
                            } #PSCustomObject
                        } else {
                            [PSCustomObject]@{
                                ComputerName = $Computer
                                UserName     = $session.Split(' ')[0]
                                SessionName  = $null
                                SessionID    = $Session.Split(' ')[1]
                                SessionState = 'Disconnected'
                                IdleTime     = $Session.Split(' ')[3]
                                LogonTime    = $session.Split(' ')[4, 5, 6] -as [string] -as [datetime]
                            } #PSCustomObject
                        } #if-else

                        Write-Output $UserInfo

                        if ($PSBoundParameters.ContainsKey('Logoff'))
                        {
                            Write-Verbose 'Command contains -Logoff Switch'
                            LogOff.exe $UserInfo.SessionID /SERVER:$Computer
                            Write-Host "Logged out: $($UserInfo.UserName)"
                        } #if
                    } #foreach SessionList


                } #if
            } #try
            catch
            {
                Write-Error $_.Exception.Message
            } #catch
        } #foreach ComputerName
    } #process

    end {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
} #function Get-ParlLoggedInUser
