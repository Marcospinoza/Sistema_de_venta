<?php
include 'conexion.php';

$stmt = $pdo->query("CALL sp_listar_categorias()");
echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
?>
