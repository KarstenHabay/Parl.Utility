BeforeAll {
    $script:dscModuleName = 'Parl.Utility'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

InModuleScope -ModuleName 'Parl.Utility' {
    Describe "Get-ParlDatabaseConnection" {
        Mock -CommandName 'New-Object' -MockWith {
            param($TypeName)
            if ($TypeName -eq 'System.Data.Odbc.OdbcConnection') {
                return @{
                    Open = { }
                    Close = { }
                }
            }
        }

        It "opens a database connection with a valid connection string" {
            # Arrange
            $ConnectionString = "DSN=RegistreDesPersonnes;"

            # Act
            $dbConnection = Get-ParlDatabaseConnection -ConnectionString $ConnectionString

            # Assert
            $dbConnection | Should -Not -BeNullOrEmpty
            $dbConnection.ConnectionString | Should -Be $ConnectionString
        }

        It "throws an error with an invalid connection string" {
            # Arrange
            Mock -CommandName 'New-Object' -MockWith {
                param($TypeName)
                if ($TypeName -eq 'System.Data.Odbc.OdbcConnection') {
                    throw [System.InvalidOperationException] "Invalid connection string"
                }
            }

            # Act / Assert
            { Get-ParlDatabaseConnection -ConnectionString "DSN=InvalidDSN;" } | Should -Throw
        }
    }
}
