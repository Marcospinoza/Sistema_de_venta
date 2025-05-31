<?php
include 'conexion.php';
header('Content-Type: application/json');

$nombres = $_GET['nombres'];
$apellidos = $_GET['apellidos'];

$stmt = $pdo->prepare("CALL sp_obten_id_cliente(?, ?)");
$stmt->execute([$nombres, $apellidos]);
$cliente = $stmt->fetch(PDO::FETCH_ASSOC);

echo json_encode($cliente ?: []);
?>
