BeforeAll {
    $script:dscModuleName = 'Parl.Utility'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Compare-ParlObjectsValue' {
    Context 'Comparing two valid objects' {}
    Context 'Comparing two valid objects with no common parameters' {}
    Context 'Comparing no objects' {}

}
