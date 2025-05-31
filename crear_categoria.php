<?php
include 'conexion.php';

$descripcion = $_POST['descripcion'];
$stmt = $pdo->prepare("CALL sp_insertar_categoria(?)");
$stmt->execute([$descripcion]);

echo json_encode(["success" => true, "mensaje" => "Categoría creada correctamente."]);
?>
