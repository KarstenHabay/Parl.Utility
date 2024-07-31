BeforeAll {
    $script:dscModuleName = 'Parl.Utility'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Get-ParlLoggedInUser' {
<#     # Mocking external commands
    Mock -CommandName quser -MockWith {
        @"
USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
user1                 rdp-tcp#125        30  Active          .  11/07/2024 8:59
user2                 rdp-tcp#133        35  Active          .  11/07/2024 10:10
"@
    }


    Mock -CommandName LogOff.exe

    # Test with default parameters
    It 'Should return logged in users on the local computer' {
        $result = Get-ParlLoggedInUser
        $result | Should -HaveCount 2
        $result[0].UserName | Should -Be 'user1'
        $result[1].UserName | Should -Be 'user2'
    }

    # Test with specific ComputerName
    It 'Should return logged in users on a specified computer' {
        $result = Get-ParlLoggedInUser -ComputerName 'TestComputer'
        $result | Should -HaveCount 2
        $result[0].ComputerName | Should -Be 'TESTCOMPUTER'
    }

    # Test with UserName filter
    It 'Should return only the specified user' {
        $result = Get-ParlLoggedInUser -UserName 'user1'
        $result | Should -HaveCount 1
        $result[0].UserName | Should -Be 'user1'
    }

    # Test with Exclude filter
    It 'Should exclude the specified user' {
        $result = Get-ParlLoggedInUser -Exclude 'user2'
        $result | Should -HaveCount 1
        $result[0].UserName | Should -Be 'user1'
    }

    # Test with Logoff switch
    It 'Should log off the specified user' {
        $result = Get-ParlLoggedInUser -UserName 'user1' -Logoff
        $result | Should -HaveCount 1
        $result[0].UserName | Should -Be 'user1'
        Assert-MockCalled -CommandName LogOff.exe -Exactly 1 -Scope It
    }

    # Test error handling
    It 'Should handle errors gracefully' {
        Mock -CommandName quser -MockWith { throw 'Test error' }
        { Get-ParlLoggedInUser } | Should -Throw 'Test error'
    }

    # Test verbose output
    It 'Should output verbose messages' {
        $result = Get-ParlLoggedInUser -Verbose
        $result | Should -HaveCount 2
        $VerbosePreference = 'Continue'
        $result = Get-ParlLoggedInUser -Verbose
        $result | Should -HaveCount 2
    }
 #>}
