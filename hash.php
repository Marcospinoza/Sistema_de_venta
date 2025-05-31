<?php
$pass = 'Marck'; // la contraseña que quieras hashear
$hash = password_hash($pass, PASSWORD_DEFAULT);
echo $hash;
?>
