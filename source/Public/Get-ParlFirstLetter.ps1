function Get-ParlFirstLetter
{
    <#
    .SYNOPSIS
        Extracts the first letter of each word in a name.

    .DESCRIPTION
        The `Get-ParlFirstLetter` function processes an array of names, extracting the first letter of each word in the name.
        It converts the names to lowercase, replaces hyphens with spaces, and then splits the names into words.
        The function logs verbose messages for debugging purposes.

    .PARAMETER Name
        The array of names to be processed. This parameter is mandatory and accepts input from the pipeline and by property name.
        It allows empty strings and empty collections.

    .INPUTS
        System.String[]
            You can pipe an array of strings (names) to the function.

    .OUTPUTS
        System.String
            The function outputs the first letters of each word in the names as strings.

    .EXAMPLE
        # Process a single name
        'John Doe' | Get-ParlFirstLetter
        # Output: jd

    .EXAMPLE
        # Process multiple names
        @('John Doe', 'Jane-Smith', 'Alice Johnson') | Get-ParlFirstLetter
        # Output: jd js aj

    .EXAMPLE
        # Process names from a property
        $people = @(
            [PSCustomObject]@{ Name = 'John Doe' },
            [PSCustomObject]@{ Name = 'Jane-Smith' },
            [PSCustomObject]@{ Name = 'Alice Johnson' }
        )
        $people | Get-ParlFirstLetter -PropertyName Name
        # Output: jd js aj

    .NOTES
        Author: Karsten Habay

        The function converts names to lowercase, replaces hyphens with spaces, and splits the names into words.
        It then extracts the first letter of each word and concatenates them.
        The function logs verbose messages at the beginning, during processing, and at the end for debugging purposes.

    .FUNCTIONALITY
        The function performs the following steps:
        1. Logs metadata and parameter information.
        2. Iterates through each name in the input array.
        3. Converts the name to lowercase and replaces hyphens with spaces.
        4. Splits the name into words.
        5. Extracts the first letter of each word and concatenates them.
        6. Outputs the concatenated first letters.
        7. Logs verbose messages at the end.
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
            $FirstLetters = ""
            $Names = (($Item.ToLower()).Replace("-", " ")).Split(" ")

            foreach ($n in $Names)
            {
                $FirstLetters += $n[0]
            } #foreach $n

            Write-Output $FirstLetters
        } #foreach $Item
    } #process

    end {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
} #function
