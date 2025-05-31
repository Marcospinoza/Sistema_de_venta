<?php
include 'conexion.php';

$id = $_POST['id_categoria'];
$descripcion = $_POST['descripcion'];

$stmt = $pdo->prepare("CALL sp_actualizar_categoria(?, ?)");
$stmt->execute([$id, $descripcion]);

echo json_encode(["success" => true, "mensaje" => "Categoría actualizada correctamente."]);
?>
