function Get-ParlDatabaseConnection
{
    <#
    .SYNOPSIS
        Establishes a connection to a database using the provided connection string.

    .DESCRIPTION
        The `Get-ParlDatabaseConnection` function creates and opens an ODBC connection to a database using the provided connection string.
        It outputs the connection object if the connection is successful, and logs verbose messages for debugging purposes.
        If the connection fails, it writes an error message and exits the script.

    .PARAMETER ConnectionString
        The connection string used to establish the database connection. This parameter is mandatory and cannot be null or empty.

    .INPUTS
        System.String
            You can provide the connection string as a string.

    .OUTPUTS
        System.Data.Odbc.OdbcConnection
            The function outputs an OdbcConnection object if the connection is successful.

    .EXAMPLE
        # Establish a connection to a database
        $connectionString = "DSN=RegistreDesPersonnes;"
        $connection = Get-ParlDatabaseConnection -ConnectionString $connectionString

    .NOTES
        Author: Karsten Habay

        The function uses the `System.Data.Odbc.OdbcConnection` class to create and open the connection.
        It logs verbose messages to indicate the status of the connection attempt.
        If the connection fails, it catches the `System.InvalidOperationException` and writes an error message.

    .FUNCTIONALITY
        The function performs the following steps:
        1. Creates a new OdbcConnection object.
        2. Sets the connection string for the OdbcConnection object.
        3. Attempts to open the connection.
        4. Logs a verbose message if the connection is successful.
        5. Outputs the OdbcConnection object.
        6. Catches any `System.InvalidOperationException` exceptions.
        7. Writes an error message if the connection fails and exits the script.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ConnectionString
    )

    $Connection = New-Object System.Data.Odbc.OdbcConnection
    $Connection.ConnectionString = $ConnectionString

    try {
        $Connection.Open()
        Write-Verbose -Message 'Connection to the database is OK.'
        Write-Output $Connection
    }
    catch [System.InvalidOperationException] {
        Write-Error -Message 'Connection to the database is not working.'
        Exit
    }
}
