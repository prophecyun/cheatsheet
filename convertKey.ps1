#split key which is 32 byte array
$key = get-content key
$key1 = New-Object Byte[] 16
$key2 = New-Object Byte[] 16
for ($i=0 ; $i -le 15 ; $i++) { $key1[$i] = $key[$i] }
for ($i=16 ; $i -le $key.Length-1 ; $i++) { $key2[$i-16] = $key[$i] }
$key1 | Out-File key1
$key2 | Out-File key2

#Download string outputs key as string, so need to convert to byte array again
$k1 = (New-Object System.Net.WebClient).DownloadString('c:\users\user\desktop\key1').Split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
$k2 = (New-Object System.Net.WebClient).DownloadString('c:\users\user\desktop\key2').Split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
$strArr = $k1 + $k2
$byteArr = New-Object Byte[] 32
$x=0
foreach ($s in $strArr) {$int = [int]$s;  $byteArr[$x]=$int; $x++;}
$key = get-content key
Compare-Object -ReferenceObject $key -DifferenceObject $byteArr -IncludeEqual