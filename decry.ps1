 $file = "c:\users\user\desktop\encry"
 $DestinationFile = "c:\users\user\desktop\decry.zip"
 
 $FileStreamReader = New-Object System.IO.FileStream($File, [System.IO.FileMode]::Open)
 $FileStreamWriter = New-Object System.IO.FileStream($DestinationFile, [System.IO.FileMode]::Create)


 [Byte[]]$LenIV = New-Object Byte[] 4
 $FileStreamReader.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
 $FileStreamReader.Read($LenIV,  0, 3) | Out-Null
 [Int]$LIV = [System.BitConverter]::ToInt32($LenIV,  0)
 [Byte[]]$IV = New-Object Byte[] $LIV
 $FileStreamReader.Seek(4, [System.IO.SeekOrigin]::Begin) | Out-Null
 $FileStreamReader.Read($IV, 0, $LIV) | Out-Null

 $Algorithm = 'AES'
 $Crypto = [System.Security.Cryptography.SymmetricAlgorithm]::Create($Algorithm)
 $Crypto.IV = $IV
 
 $Crypto.key = Get-Content C:\users\user\Desktop\key
 $Transform = $Crypto.CreateDecryptor()
 $CryptoStream = New-Object System.Security.Cryptography.CryptoStream($FileStreamWriter, $Transform, [System.Security.Cryptography.CryptoStreamMode]::Write)
 $FileStreamReader.CopyTo($CryptoStream)

 $CryptoStream.FlushFinalBlock()
 $CryptoStream.Close()
 $FileStreamReader.Close()
 $FileStreamWriter.Close()