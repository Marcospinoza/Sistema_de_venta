<?php
include 'conexion.php';

$nombres = $_POST['nombres'] ?? '';
$apellidos = $_POST['apellidos'] ?? '';
$direccion = $_POST['direccion'] ?? '';
$telefono = $_POST['telefono'] ?? '';

if (!$nombres || !$apellidos) {
    echo json_encode(['error' => 'Nombres y apellidos son obligatorios']);
    exit;
}

try {
    $stmt = $pdo->prepare("CALL sp_insertar_cliente(?, ?, ?, ?)");
    $stmt->execute([$nombres, $apellidos, $direccion, $telefono]);
    $stmt->closeCursor();

    // Obtener el id_cliente recién insertado (puedes hacer un sp que devuelva el último insert id)
    $stmt2 = $pdo->prepare("CALL sp_obtener_id_cliente(?, ?)");
    $stmt2->execute([$nombres, $apellidos]);
    $cliente = $stmt2->fetch(PDO::FETCH_ASSOC);

    echo json_encode(['id_cliente' => $cliente['id_cliente']]);

} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>
