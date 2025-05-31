<?php
include 'conexion.php';

$id = $_GET['id'];
$stmt = $pdo->prepare("CALL sp_obtener_producto(?)");
$stmt->execute([$id]);
$producto = $stmt->fetch();

echo json_encode($producto);
?>
