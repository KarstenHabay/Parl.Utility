function Show-ParlObjectUsingANSIColor
{
    <#
    .SYNOPSIS
        Displays the properties of an object with ANSI color coding.

    .DESCRIPTION
        The `Show-ParlObjectUsingANSIColor` function displays the properties of an object with ANSI color coding.
        It highlights properties with empty or null values in a specified color and allows skipping certain properties.
        The function logs verbose messages for debugging purposes.

    .PARAMETER Object
        The object whose properties are to be displayed. This parameter is mandatory.

    .PARAMETER ModifyEmptyParameterName
        An array of property names to be highlighted if they have empty or null values. If not provided, all properties are considered.

    .PARAMETER ModifyEmptyParameterColor
        The color to use for highlighting empty or null values. Valid values are 'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', and 'White'.
        The default value is 'Red'.

    .PARAMETER SkipParameter
        An array of property names to be skipped from display.

    .INPUTS
        System.Management.Automation.PSObject
            You can pipe an object to the function.

        System.String[]
            You can provide a list of property names to be highlighted or skipped.

    .OUTPUTS
        None
            The function does not output any objects. It displays the properties of the input object with ANSI color coding.

    .EXAMPLE
        # Display properties of an object with default settings
        $obj = [PSCustomObject]@{ Name = 'John'; Age = 30; Address = '' }
        Show-ParlObjectUsingANSIColor -Object $obj

    .EXAMPLE
        # Highlight specific properties if they are empty
        $obj = [PSCustomObject]@{ Name = 'John'; Age = 30; Address = '' }
        Show-ParlObjectUsingANSIColor -Object $obj -ModifyEmptyParameterName 'Address'

    .EXAMPLE
        # Skip certain properties from display
        $obj = [PSCustomObject]@{ Name = 'John'; Age = 30; Address = '' }
        Show-ParlObjectUsingANSIColor -Object $obj -SkipParameter 'Age'

    .NOTES
        Author: Karsten Habay

        The function uses ANSI escape codes to apply colors to the output.
        It logs verbose messages at the beginning, during processing, and at the end for debugging purposes.

    .FUNCTIONALITY
        The function performs the following steps:
        1. Logs metadata and parameter information.
        2. Defines ANSI color codes.
        3. Calculates the longest property name for alignment.
        4. Checks if `ModifyEmptyParameterName` is provided. If not, it uses all property names.
        5. Iterates through each property of the object.
        6. Skips properties listed in `SkipParameter`.
        7. Adds padding to property names for alignment.
        8. Replaces null values with empty strings.
        9. Formats date values if the property is of type DateTime.
        10. Sets the color for empty or null values based on `ModifyEmptyParameterColor`.
        11. Writes the property name and value with the appropriate color.
        12. Logs verbose messages at the end.
    #>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost',     '', Scope='Function')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidTrailingWhitespace', '', Scope='Function')]

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true,
                    Position = 0)]
        [psobject]
        $Object,

        [Parameter()]
        [array]
        $ModifyEmptyParameterName,

        [Parameter()]
        [ValidateSet('Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White')]
        [string]
        $ModifyEmptyParameterColor = 'Red',

        [Parameter()]
        [array]
        $SkipParameter
    )

    begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"

        Write-Verbose "[META   ] Computer  = $env:COMPUTERNAME"
        Write-Verbose "[META   ] User      = $env:USERDOMAIN\$env:USERNAME"
        Write-Verbose "[META   ] Command   = $($MyInvocation.Mycommand)"
        Write-Verbose "[META   ] PSEdition = $($PSVersionTable.PSEdition)"
        Write-Verbose "[META   ] PSVersion = $($PSVersionTable.PSVersion)"
        Write-Verbose "[META   ] Test Date = $(Get-Date)"

        # Define ANSI color codes
        $Colors = @{
            Black   = "`e[30m"
            Red     = "`e[91;1m"
            Green   = "`e[92;1m"
            Yellow  = "`e[93;1m"
            Blue    = "`e[94;1m"
            Magenta = "`e[95;1m"
            Cyan    = "`e[96;1m"
            White   = "`e[37m"
            Reset   = "`e[0m" # Resets Color
        }


        # Calculate the longest property name for alignment
        $LongestNameCount = $Object.PSObject.Properties.Name | Measure-Object -Property Length -Maximum | Select-Object -ExpandProperty Maximum

        # Checks if ModifyEmptyParameterName has been entered, if not use all property keys
        if (-not $PSBoundParameters.ContainsKey('ModifyEmptyParameterName'))
        {
            $ModifyEmptyParameterName = $Object.PSObject.Properties.Name
        } #if
    }

    process {
        foreach ($Property in $Object.PSObject.Properties)
        {
            if ($SkipParameter -contains $Property.Name)
            {
                continue
            }

            # Adds Padding to make all parameter name texts the same length
            $Name = $Property.Name.PadRight($LongestNameCount, " ")
            # Replace null values by empty strings
            $Value = if ([string]::IsNullOrWhiteSpace($Property.Value)) { $null } else { $Property.Value }
            # Correct the date format if Value is of type DateTime
            if (($value -is [datetime]) -and ($null -ne $Value))
            {
                $Value = $Value.ToShortDateString()
            }

            # Check if Value is null and Property is listed, set the ModifyEmptyParameterColor accordingly
            $ColorCode = if (($null -eq $Value) -and ($ModifyEmptyParameterName -contains $Property.Name))
            {
                $Colors[$ModifyEmptyParameterColor]
            } else {
                $Colors["Green"]
            }

            # Write the property name with color
            Write-Host "$($ColorCode)$Name :$($Colors["Reset"]) $($Colors["White"])$Value$($Colors["Reset"])"
        }
    }

    end {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    }
}
