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
$secureString | ConvertFrom-SecureString -Key $EncryptionKeyData | Out-File -FilePath "Desktop/secret.encrypted"
#Use key to decrypt
$PasswordSecureString = Get-Content "Desktop/secret.encrypted" | ConvertTo-SecureString -Key $EncryptionKeyData
$PlainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PasswordSecureString))
