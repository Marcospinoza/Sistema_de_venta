<?php
include 'conexion.php';

$razon = $_POST['razonsocial'];
$direccion = $_POST['direccion'];
$telefono = $_POST['telefono'];

$stmt = $pdo->prepare("CALL sp_insertar_proveedor(?, ?, ?)");
$stmt->execute([$razon, $direccion, $telefono]);

echo json_encode(["success" => true, "mensaje" => "Proveedor creado correctamente."]);
?>
