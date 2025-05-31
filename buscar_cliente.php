<?php
include 'conexion.php';

$termino = $_GET['q'] ?? '';

if (empty($termino)) {
    echo json_encode([]);
    exit;
}

$stmt = $pdo->prepare("CALL sp_buscar_clientes(?)");
$stmt->execute([$termino]);
$clientes = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($clientes);
?>
