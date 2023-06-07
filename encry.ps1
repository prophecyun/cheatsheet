 Set-ExecutionPolicy unrestricted
 $file = "c:\users\user\desktop\test.zip"
 $DestinationFile = "c:\users\user\desktop\encry"

$FileStreamReader = New-Object System.IO.FileStream($File, [System.IO.FileMode]::Open)
$FileStreamWriter = New-Object System.IO.FileStream($DestinationFile, [System.IO.FileMode]::Create)

#create encryption key
 $EncryptionKeyBytes = New-Object Byte[] 32 | out-file C:\users\user\Desktop\key

 $Crypto = [System.Security.Cryptography.SymmetricAlgorithm]::Create($Algorithm)

 $Crypto.key = Get-Content C:\users\user\Desktop\key
 $Crypto.GenerateIV()
 $FileStreamWriter.Write([System.BitConverter]::GetBytes($Crypto.IV.Length), 0, 4)
 $FileStreamWriter.Write($Crypto.IV, 0, $Crypto.IV.Length)

 $Transform = $Crypto.CreateEncryptor()
 $CryptoStream = New-Object System.Security.Cryptography.CryptoStream($FileStreamWriter, $Transform, [System.Security.Cryptography.CryptoStreamMode]::Write)
 $FileStreamReader.CopyTo($CryptoStream)
    
 $CryptoStream.FlushFinalBlock()
 $CryptoStream.Close()
 $FileStreamReader.Close()
 $FileStreamWriter.Close()
