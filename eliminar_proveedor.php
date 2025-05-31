<?php
include 'conexion.php';

$id = $_GET['id'];
$stmt = $pdo->prepare("CALL sp_eliminar_proveedor(?)");
$stmt->execute([$id]);

echo json_encode(["success" => true, "mensaje" => "Proveedor eliminado correctamente."]);
?>
