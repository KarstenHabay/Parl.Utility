BeforeAll {
    $script:dscModuleName = 'Parl.Utility'
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
    $Module = Get-Module -Name $script:dscModuleName -ListAvailable
    Import-Module -Name $Module -Force
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Show-ParlObjectUsingANSIColor' {
    BeforeAll {
        # Arrange
        # Mock the Write-Host to intercept and check the output
        Mock Write-Host {throw "Don't call Write-Host for real"}

        # Test object with various properties
    }

    It 'Should display property names in green when they have values' {
        # Arrange
        Mock Write-Host { }
        $testObject = [PSCustomObject]@{
            Name = 'TestObject'
            Value = $null
            Count = 43
            Status = ''
        }
        # Act
        Write-Output "Starting Act"
        Show-ParlObjectUsingANSIColor -Object $testObject -ModifyEmptyParameterName @('Value', 'Status')
        # Assert
        Write-Output "Starting Assert"
        Should -Invoke Write-Host -Times 4 -Exactly
        Should -Invoke Write-Host -ParameterFilter {$Object -eq "`e[92;1mName   :`e[0m `e[37mTestObject`e[0m"}
        Should -Invoke Write-Host -ParameterFilter {$Object -eq "`e[92;1mCount  :`e[0m `e[37m42`e[0m"}
    }

    # It 'Should display property names in red when they are empty or null' {
    #     $ActualOutput = Show-ParlObjectUsingANSIColor -Object $testObject -ModifyEmptyParameterName @('Value', 'Status')
    #     $ActualOutput | Should -Contain "`e[91;1mValue  :`e[0m `e[37m`e[0m"
    #     $ActualOutput | Should -Contain "`e[91;1mStatus :`e[0m `e[37m`e[0m"
    # }

    # It 'Should skip specified properties' {
    #     Show-ParlObjectUsingANSIColor -Object $testObject -ModifyEmptyParameterName @('Value', 'Status') -SkipParameter @('Count')
    #     Should -Invoke Write-Host -ParameterFilter {
    #         $Output -notmatch "Count"
    #     } -Exactly -Times 0
    # }

    # It 'Should handle objects with no properties' {
    #     Show-ParlObjectUsingANSIColor -Object ([PSCustomObject]@{}) -ModifyEmptyParameterName @()
    #     Should -Invoke Write-Host -Exactly -Times 0
    # }

    # It 'Should use the default color red for empty properties if no color is specified' {
    #     $ActualOutput = Show-ParlObjectUsingANSIColor -Object $testObject -ModifyEmptyParameterName @('Value', 'Status')
    #     $ActualOutput | Should -Contain "`e[91;1mValue  :`e[0m `e[37m`e[0m"
    #     $ActualOutput | Should -Contain "`e[91;1mStatus :`e[0m `e[37m`e[0m"
    # }

    # It 'Should allow changing the color for empty properties' {
    #     $ActualOutput = Show-ParlObjectUsingANSIColor -Object $testObject -ModifyEmptyParameterName @('Value', 'Status') -ModifyEmptyParameterColor 'Blue'
    #     $ActualOutput | Should -Contain "`e[94;1mValue  :`e[0m `e[37m`e[0m"
    #     $ActualOutput | Should -Contain "`e[94;1mStatus :`e[0m `e[37m`e[0m"
    # }
}
