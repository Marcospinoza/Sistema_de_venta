<?php
include 'conexion.php';

$id = $_POST['id_proveedor'];
$razon = $_POST['razonsocial'];
$direccion = $_POST['direccion'];
$telefono = $_POST['telefono'];

$stmt = $pdo->prepare("CALL sp_actualizar_proveedor(?, ?, ?, ?)");
$stmt->execute([$id, $razon, $direccion, $telefono]);

echo json_encode(["success" => true, "mensaje" => "Proveedor actualizado correctamente."]);
?>
