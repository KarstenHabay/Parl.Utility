Import-Module Diacritic

function Get-ParlStrippedName
{
    <#
    .SYNOPSIS
        Strips diacritic characters and special characters from names.

    .DESCRIPTION
        The `Get-ParlStrippedName` function processes an array of names, removing diacritic characters, converting them to lowercase, and stripping out special characters such as apostrophes, hyphens, and spaces.
        It logs verbose messages for debugging purposes.

    .PARAMETER Name
        The array of names to be processed. This parameter is mandatory and accepts input from the pipeline and by property name.
        It allows empty strings and empty collections.

    .INPUTS
        System.String[]
            You can pipe an array of strings (names) to the function.

    .OUTPUTS
        System.String
            The function outputs the processed names as strings.

    .EXAMPLE
        # Process a single name
        'José' | Get-ParlStrippedName

    .EXAMPLE
        # Process multiple names
        @('José', 'O'Connor', 'Smith-Jones') | Get-ParlStrippedName

    .EXAMPLE
        # Process names from a property
        $people = @(
            [PSCustomObject]@{ Name = 'José' },
            [PSCustomObject]@{ Name = 'O'Connor' },
            [PSCustomObject]@{ Name = 'Smith-Jones' }
        )
        $people | Get-ParlStrippedName -PropertyName Name

    .NOTES
        Author: Karsten Habay

        The function uses the `Remove-DiacriticChars` function from the `Diacritic` module to remove diacritic characters.
        It converts names to lowercase and removes apostrophes, hyphens, and spaces.

    .FUNCTIONALITY
        The function performs the following steps:
        1. Logs metadata and parameter information.
        2. Iterates through each name in the input array.
        3. Removes diacritic characters and converts the name to lowercase.
        4. Trims the name and removes apostrophes, hyphens, and spaces.
        5. Outputs the processed name.
        6. Logs verbose messages at the end.
    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true,
                    ValueFromPipeline = $true,
                    ValueFromPipelineByPropertyName = $true)]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [System.String[]]
        $Name
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

    process
    {
        foreach ($Item in $Name)
        {
            $StrippedName = Remove-DiacriticChars($Item.ToLower())
            $StrippedName = $StrippedName.Trim() -replace "'|-| ", ""

            Write-Output $StrippedName
        } #foreach
    } #process

    end {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
} #function
