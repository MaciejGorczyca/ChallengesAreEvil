$LeagueProcess = Get-WmiObject -Query "Select * from Win32_Process where Name = 'LeagueClientUx.exe'"

# Extract the port and auth token from the process' command line
$PortRegEx = '--app-port=(\S+?)("|\s)'
$AuthTokenRegEx = '--remoting-auth-token=(\S+?)("|\s)'
$Port = $LeagueProcess.CommandLine | Select-String -Pattern $PortRegEx | % { $_.Matches.Groups[1].Value }
$AuthToken = $LeagueProcess.CommandLine | Select-String -Pattern $AuthTokenRegEx | ForEach-Object { $_.Matches.Groups[1].Value }

# Define the API URL
$URL = "https://127.0.0.1:$Port/lol-challenges/v1/update-player-preferences/"

# Define the request headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("riot:" + $AuthToken))) 


# Disable SSL verification due to self-signed certificates
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy


# Define the body content
$bodyContent = ConvertTo-Json -Compress @{ "challengeIds" = @() }

# Send the request
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$response = Invoke-RestMethod -Uri $URL -Headers $headers -Method Post -Body $bodyContent -ContentType "application/json"

# Output the response
$response


