<?php
include 'conexion.php';

$id = $_GET['id'];
$stmt = $pdo->prepare("CALL sp_obtener_categoria(?)");
$stmt->execute([$id]);
echo json_encode($stmt->fetch(PDO::FETCH_ASSOC));
?>
