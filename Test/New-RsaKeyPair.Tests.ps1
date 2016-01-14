
& (Join-Path -Path $PSScriptRoot -ChildPath 'Import-CarbonForTest.ps1' -Resolve)

$tempDir = $null
$privateKeyPassword = (New-Credential -User 'doesn''t matter' -Password 'fubarsnafu').Password
$subject = $null
$publicKeyPath = $null
$privateKeyPath = $null

Describe 'New-RsaKeyPair' {

    function Assert-KeyProperty
    {
        param(
            $Length = 4096,
            $ValidTo = ([DateTime]::MaxValue),
            $Algorithm = 'sha512RSA'
        )
        $cert = Get-Certificate -Path $publicKeyPath
        $cert.NotAfter.ToShortDateString() | Should Be $ValidTo.ToShortDateString()
        $cert.Subject | Should Be $subject
        $cert.PublicKey.Key.KeySize | Should Be $Length
        $cert.PublicKey.Key.KeyExchangeAlgorithm | Should Be 'RSA-PKCS1-KeyEx'
        $cert.SignatureAlgorithm.FriendlyName | Should Be $Algorithm
        $keyUsage = $cert.Extensions | Where-Object { $_ -is [Security.Cryptography.X509Certificates.X509KeyUsageExtension] }
        $keyUsage | Should Not BeNullOrEmpty
        $keyUsage.KeyUsages.HasFlag([Security.Cryptography.X509Certificates.X509KeyUsageFlags]::DataEncipherment) | Should Be $true
        $keyUsage.KeyUsages.HasFlag([Security.Cryptography.X509Certificates.X509KeyUsageFlags]::KeyEncipherment) | Should Be $true
        $enhancedKeyUsage = $cert.Extensions | Where-Object { $_ -is [Security.Cryptography.X509Certificates.X509EnhancedKeyUsageExtension] }
        $enhancedKeyUsage | Should Not BeNullOrEmpty
        $usage = $enhancedKeyUsage.EnhancedKeyUsages | Where-Object { $_.FriendlyName -eq 'Document Encryption' }
        $usage | Should Not BeNullOrEmpty
    }

    BeforeEach {
        $tempDir = New-TempDirectory -Prefix $PSCommandPath
        $Global:Error.Clear()

        $subject = 'CN={0}' -f [Guid]::NewGuid()
        $publicKeyPath = Join-Path -Path $tempDir -ChildPath 'public.cer'
        $privateKeyPath = Join-Path -Path $tempDir -ChildPath 'private.pfx'
    }

    AfterEach {
        Remove-Item -Path $tempDir -Recurse
    }

    It 'should generate a public/private key pair' {

        $output = New-RsaKeyPair -Subject $subject -PublicKeyFile $publicKeyPath -PrivateKeyFile $privateKeyPath -Password $privateKeyPassword
        $output | Should Not BeNullOrEmpty
        $output.Count | Should Be 2

        $publicKeyPath | Should Exist
        $output[0].FullName | Should Be $publicKeyPath

        $privateKeyPath | Should Exist
        $output[1].FullName | Should Be $privateKeyPath

        Assert-KeyProperty

        # Make sure we can decrypt things with it.
        $secret = [IO.Path]::GetRandomFileName()
        $protectedSecret = Protect-String -String $secret -Certificate $publicKeyPath
        $decryptedSecret = Unprotect-String -ProtectedString $protectedSecret -PrivateKeyPath $privateKeyPath -Password $privateKeyPassword
        $decryptedSecret | Should Be $secret

        # Make sure it works with DSC
        $configData = @{
            AllNodes = @(
                @{
                    NodeName = 'localhost';
                    CertificateFile = $PublicKeyPath;
                    Thumbprint = $output[0].Thumbprint;
                }
            )
        }

        configuration TestEncryption
        {
            Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

            node $AllNodes.NodeName 
            {
                User 'CreateDummyUser'
                {
                    UserName = 'fubarsnafu';
                    Password = (New-Credential -UserName 'fubarsnafu' -Password 'Password1')
                }
            }
        }

        & TestEncryption -ConfigurationData $configData -OutputPath $tempDir

        $Global:Error.Count | Should Be 0
        Join-Path -Path $tempDir -ChildPath 'localhost.mof' | Should Not Contain 'Password1'
    }

    if( Get-Command -Name 'Protect-CmsMessage' -ErrorAction Ignore )
    {
        # Make sure we can protect CMS messages with it
        It 'should generate key pairs that can be used by CMS cmdlets' {
            $output = New-RsaKeyPair -Subject 'CN=to@example.com' -PublicKeyFile $publicKeyPath -PrivateKeyFile $privateKeyPath -Password $privateKeyPassword

            $cert = Install-Certificate -Path $privateKeyPath -StoreLocation CurrentUser -StoreName My -Password $privateKeyPassword

            try
            {
                $message = 'fubarsnafu'
                $protectedMessage = Protect-CmsMessage -To $publicKeyPath -Content $message
                Unprotect-CmsMessage -Content $protectedMessage | Should Be $message
            }
            finally
            {
                Uninstall-Certificate -Thumbprint $cert.Thumbprint -StoreLocation CurrentUser -StoreName My
            }
        }
    }


    It 'should generate key with custom configuration' {
        $validTo = (Get-Date).AddDays(30)
        $length = 2048

        $output = New-RsaKeyPair -Subject $subject `
                                 -PublicKeyFile $publicKeyPath `
                                 -PrivateKeyFile $privateKeyPath `
                                 -Password $privateKeyPassword `
                                 -ValidTo $validTo `
                                 -Length $length `
                                 -Algorithm sha1

        Assert-KeyProperty -Length $length -ValidTo $validTo -Algorithm 'sha1RSA'
        
    }

    It 'should reject subjects that don''t begin with CN=' {
        { New-RsaKeyPair -Subject 'fubar' -PublicKeyFile $publicKeyPath -PrivateKeyFile $privateKeyPath -Password $privateKeyPassword } | Should Throw
        $Global:Error[0] | Should Match 'does not match'
    }

    It 'should not protect private key' {
        $output = New-RsaKeyPair -Subject $subject -PublicKeyFile $publicKeyPath -PrivateKeyFile $privateKeyPath -Password $null
        $output.Count | Should Be 2

        $privateKey = Get-Certificate -Path $privateKeyPath
        $privateKey | Should Not BeNullOrEmpty

        $secret = [IO.Path]::GetRandomFileName()
        $protectedSecret = Protect-String -String $secret -PublicKeyPath $publicKeyPath
        Unprotect-String -ProtectedString $protectedSecret -PrivateKeyPath $privateKeyPath | Should Be $secret
    }
}