BeforeAll {
    $script:dscModuleName = 'Parl.Utility'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Test-ParlObjectHasEmptyValue' {

}
