<?php
include 'conexion.php';

$stmt = $pdo->query("CALL sp_listar_productos()");
$productos = $stmt->fetchAll();

echo json_encode($productos);
?>
