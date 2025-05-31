<?php
include 'conexion.php';

$id = $_GET['id'];
$stmt = $pdo->prepare("CALL sp_eliminar_producto(?)");
$stmt->execute([$id]);

echo json_encode(["success" => true, "mensaje" => "Producto eliminado correctamente."]);
?>
