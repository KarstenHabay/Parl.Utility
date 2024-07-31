BeforeAll {
    $script:dscModuleName = 'Parl.Utility'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Get-ParlFirstLetter' {
    Context 'Valid Input Test' {
        It 'Should return correct initials for a full name' {
            $result = Get-ParlFirstLetter -Name 'John-Doe Smith'
            $result | Should -Be 'JDS'
        } #It

        It 'Should return correct initials for an array of full names' {
            $result = Get-ParlFirstLetter -Name 'John-Doe Smith', 'Mary-Anne Johnson'
            $result | Should -Be 'JDS', 'MAJ'
        } #It

        It 'Should handle input from the pipeline' {
            $names = 'Alice', 'Robert James Smith'
            $result = $names | Get-ParlFirstLetter
            $result | Should -Be 'A', 'RJS'
        } #It
    } #Context

    Context 'Empty Input Test' {
        It 'Should return an empty string for empty input' {
            $result = Get-ParlFirstLetter -Name ''
            $result | Should -Be ''
        } #It

        It 'Should return an empty array for empty input' {
            $result = Get-ParlFirstLetter -Name @()
            $result | Should -Be @()
        } #It

        It 'Should handle empty input from the pipeline' {
            $result = @() | Get-ParlFirstLetter
            $result | Should -Be @()
        } #It
    } #Context

    Context 'Single-Word Name Test' {
        It 'Should return the first letter for a single-word name' {
            $result = Get-ParlFirstLetter -Name 'Alice'
            $result | Should -Be 'A'
        } #It
    } #Context

    Context 'Hyphenated Name Test' {
        It 'Should handle hyphenated names' {
            $result = Get-ParlFirstLetter -Name 'Mary-Anne Johnson'
            $result | Should -Be 'MAJ'
        } #It
    } #Context

    Context 'Multiple Words Test' {
        It 'Should handle multiple words in a name' {
            $result = Get-ParlFirstLetter -Name 'Robert James Smith'
            $result | Should -Be 'RJS'
        } #It
    } #Context

    Context 'Mixed Case Test' {
        It 'Should handle mixed case input' {
            $result = Get-ParlFirstLetter -Name 'eLiZaBeTh'
            $result | Should -Be 'E'
        } #It
    } #Context
} #Discribe
