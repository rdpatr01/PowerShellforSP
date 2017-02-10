$publicCertPath = ""
$certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($publicCertPath)

New-SPTrustedRootAuthority -Name "HighTrustedSampleCert" -Certificate $certificate

$realm = Get-SPAuthenticationRealm

$specificIssuerId = ""
$fullIssuerIdentifier = $specificIssuerId + '@' + $realm 

New-SPTrustedSecurityTokenIssuer -Name "High Trust Sample Cert" -Certificate $certificate -RegisteredIssuerName $fullIssuerIdentifier –IsTrustBroker
iisreset 

$serviceConfig = Get-SPSecurityTokenServiceConfig
$serviceConfig.AllowOAuthOverHttp = $true
$serviceConfig.Update()

