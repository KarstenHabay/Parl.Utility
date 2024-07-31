function Compare-ParlObjectsValue
{
    <#
    .SYNOPSIS
        Compares the values of common properties between two objects.

    .DESCRIPTION
        The `Compare-ParlObjectsValue` function compares the common values of properties between two objects.
        It can exclude specified properties from the comparison and optionally show only the properties with different values.
        The function logs verbose messages for debugging purposes.

    .PARAMETER CompareObject
        The first object to compare. This parameter is mandatory.

    .PARAMETER WithObject
        The second object to compare. This parameter is mandatory.

    .PARAMETER ExcludedParameter
        An array of property names to exclude from the comparison.

    .PARAMETER ShowDifferent
        A switch to show only the properties with different values between the two objects.

    .INPUTS
        System.Management.Automation.PSObject
            You can pipe objects to the function.

        System.String[]
            You can provide a list of property names to exclude from the comparison.

    .OUTPUTS
        System.Management.Automation.PSCustomObject
            The function outputs a custom object with the property names and their values from both objects.

    .EXAMPLE
        # Example 1: Compare two objects and show all properties
        $obj1 = [PSCustomObject]@{ Name = 'John'; Age = 30; Address = '123 Main St' }
        $obj2 = [PSCustomObject]@{ Name = 'John'; Age = 31; Address = '123 Main St' }
        Compare-ParlObjectsValue -CompareObject $obj1 -WithObject $obj2

        # Example 2: Compare two objects and show only different properties
        $obj1 = [PSCustomObject]@{ Name = 'John'; Age = 30; Address = '123 Main St' }
        $obj2 = [PSCustomObject]@{ Name = 'John'; Age = 31; Address = '123 Main St' }
        Compare-ParlObjectsValue -CompareObject $obj1 -WithObject $obj2 -ShowDifferent

        # Example 3: Compare two objects and exclude specific properties
        $obj1 = [PSCustomObject]@{ Name = 'John'; Age = 30; Address = '123 Main St' }
        $obj2 = [PSCustomObject]@{ Name = 'John'; Age = 31; Address = '123 Main St' }
        Compare-ParlObjectsValue -CompareObject $obj1 -WithObject $obj2 -ExcludedParameter 'Address'

    .NOTES
        Author: Karsten Habay

        The function compares the values of properties that are common between the two objects.
        It can exclude specified properties from the comparison and optionally show only the properties with different values.
        The function logs verbose messages at the beginning, during processing, and at the end for debugging purposes.

    .FUNCTIONALITY
        The function performs the following steps:
        1. Logs metadata and parameter information.
        2. Retrieves the common property names between the two objects.
        3. Iterates through each common property.
        4. Excludes specified properties from the comparison.
        5. Compares the values of the properties between the two objects.
        6. Optionally shows only the properties with different values.
        7. Outputs a custom object with the property names and their values from both objects.
        8. Logs verbose messages at the end.
    #>

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [psobject]
        $CompareObject,

        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [psobject]
        $WithObject,

        [Parameter(
            Position = 2
        )]
        [string[]]
        $ExcludedParameter,

        [Parameter()]
        [switch]
        $ShowDifferent
    ) #param

    begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"

        Write-Verbose "[META   ] Computer  = $env:COMPUTERNAME"
        Write-Verbose "[META   ] User      = $env:USERDOMAIN\$env:USERNAME"
        Write-Verbose "[META   ] Command   = $($MyInvocation.Mycommand)"
        Write-Verbose "[META   ] PSEdition = $($PSVersionTable.PSEdition)"
        Write-Verbose "[META   ] PSVersion = $($PSVersionTable.PSVersion)"
        Write-Verbose "[META   ] Test Date = $(Get-Date)"

        Write-Verbose "[BEGIN  ] PARAMETER CompareObject     : <$CompareObject>"
        Write-Verbose "[BEGIN  ] PARAMETER WithObject        : <$WithObject>"
        Write-Verbose "[BEGIN  ] PARAMETER ExcludedParameter : <$ExcludedParameter>"
        Write-Verbose "[BEGIN  ] PARAMETER ShowDifferent     : <$ShowDifferent>"
    } #begin

    process {
        # Get common property names
        $CommonProperties = $CompareObject.psobject.Properties.Name | Where-Object { $WithObject.psobject.Properties.Name -contains $_ }

        # Create a Table
        $Table = foreach ($PropertyName in $CommonProperties)
        {
            if ($PropertyName -notin $ExcludedParameter)
            {
                if ($PSBoundParameters.ContainsKey('ShowDifferent'))
                {
                    if ($CompareObject.$PropertyName -ne $WithObject.$PropertyName)
                    {
                        [pscustomobject]@{
                            Property      = $PropertyName
                            CompareObject = $CompareObject.$PropertyName
                            WithObject    = $WithObject.$PropertyName
                        }
                    } #if
                } else {
                    [pscustomobject]@{
                        Property      = $PropertyName
                        CompareObject = $CompareObject.$PropertyName
                        WithObject    = $WithObject.$PropertyName
                    }
                } #if-else
            } #if
        } #foreach PropertyName
        Write-Output $Table | Format-Table -AutoSize
    } #process

    end {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
} #function Compare-ParlObjectsValue
