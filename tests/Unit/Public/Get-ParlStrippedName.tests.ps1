BeforeAll {
    $script:dscModuleName = 'Parl.Utility'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Get-ParlStrippedName' {
    Context 'Single Value Input Test' {
        It "Processes a single name" {
            $result = Get-ParlStrippedName -Name "José"
            $result | Should -BeExactly "jose"
        } #It
    } #Context

    Context 'Array Input Test' {
        It "Processes an array of names" {
            $names = "José", "André", "María"
            $result = Get-ParlStrippedName -Name $names
            $result | Should -BeExactly @("jose", "andre", "maria")
        } #It
    } #Context

    Context 'Pipeline Input Test' {
        It "Processes names from the pipeline" {
            $names = "José", "André", "María"
            $names | Get-ParlStrippedName | Should -BeExactly @("jose", "andre", "maria")
        } #It
    } #Context

    Context 'Edge Cases' {
        It "Handles empty input" {
            $result = Get-ParlStrippedName -Name @()
            $result | Should -BeExactly @()
        } #It

        It "Handles non-string input" {
            $result = Get-ParlStrippedName -Name 123
            $result | Should -BeExactly 123
        } #It
    } #Context
} #Discribe
