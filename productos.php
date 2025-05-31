<?php
include 'conexion.php';

$stmt = $pdo->query("CALL sp_detalles_productos()");
$productos = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($productos);
?>
