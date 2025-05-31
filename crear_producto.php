<?php
include 'conexion.php';

$descripcion = $_POST['descripcion'];
$precio = $_POST['precio'];
$stock = $_POST['stock'];
$id_categoria = $_POST['id_categoria'];
$id_proveedor = $_POST['id_proveedor'];

$stmt = $pdo->prepare("CALL sp_insertar_producto(?, ?, ?, ?, ?)");
$stmt->execute([$descripcion, $precio, $stock, $id_categoria, $id_proveedor]);

echo json_encode(["success" => true, "mensaje" => "Producto creado correctamente."]);
?>
