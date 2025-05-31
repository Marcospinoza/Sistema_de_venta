<?php
include 'conexion.php';

$stmt = $pdo->query("CALL sp_listar_proveedores()");
echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
?>
