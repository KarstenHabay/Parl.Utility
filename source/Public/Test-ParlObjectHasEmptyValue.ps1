function Test-ParlObjectHasEmptyValue
{
    <#
    .SYNOPSIS
        Tests if any specified properties of an object have empty or whitespace values.

    .DESCRIPTION
        The `Test-ParlObjectHasEmptyValue` function checks if any of the specified properties of an object are empty or contain only whitespace.
        If no properties are specified, it tests all properties of the object.
        The function returns `$true` if any of the tested properties are empty or contain only whitespace, and `$false` otherwise.

    .PARAMETER Object
        The object to test. This parameter is mandatory.

    .PARAMETER PropertyName
        A list of property names to test. If this parameter is not provided, all properties of the object will be tested.

    .INPUTS
        System.Object
            You can pipe an object to the function.

        System.String[]
            You can provide a list of property names to test.

    .OUTPUTS
        System.Boolean
            The function returns `$true` if any of the tested properties are empty or contain only whitespace, and `$false` otherwise.

    .EXAMPLE
        # Test if any properties of an object are empty
        $obj = [PSCustomObject]@{ Name = 'John'; Age = 30; Address = '' }
        Test-ParlObjectHasEmptyValue -Object $obj

    .EXAMPLE
        # Test specific properties of an object
        $obj = [PSCustomObject]@{ Name = 'John'; Age = 30; Address = '' }
        Test-ParlObjectHasEmptyValue -Object $obj -PropertyName 'Name', 'Address'

    .EXAMPLE
        # Test all properties of an object using pipeline input
        $obj = [PSCustomObject]@{ Name = 'John'; Age = 30; Address = '' }
        $obj | Test-ParlObjectHasEmptyValue

    .NOTES
        Author: Karsten Habay

        The function uses the `[string]::IsNullOrWhiteSpace` method to check if a property value is empty or contains only whitespace.
        If the `PropertyName` parameter is not provided, the function tests all properties of the object.

    .FUNCTIONALITY
        The function performs the following steps:
        1. Checks if the `PropertyName` parameter is provided. If not, it selects all properties of the object.
        2. Iterates through each specified property.
        3. Checks if the property value is empty or contains only whitespace.
        4. Returns `$true` if any property is empty or contains only whitespace.
        5. Returns `$false` if none of the properties are empty or contain only whitespace.
    #>

    param (
        # Object to test.
        [Parameter( Mandatory = $true,
                    Position = 0)]
        [object]
        $Object,

        # List of the Propertyname(s) to test.
        [Parameter( Position = 1)]
        [string[]]
        $PropertyName
    ) #param

    # If the PropertyName parameter is empty, select all properties.
    if (-not($PSBoundParameters['PropertyName']))
    {
        $PropertyName = ($Object | Get-Member).Name
    } #if

    # Check for missing values in the required properties.
    # If any of the tested properties is empty return true.
    foreach ($Property in $PropertyName)
    {
        if ([string]::IsNullOrWhiteSpace($Object.$Property))
        {
            return $true
        } #if
    } #foreach

    # If none of the tested properties are empty, return false.
    return $false
} #function Test-ParlObjectHasEmptyValue
