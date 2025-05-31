<?php
session_start();
include 'conexion.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usuario = $_POST['usuario'];
    $password = $_POST['password'];

    // Llamar procedimiento almacenado
    $stmt = $pdo->prepare("CALL sp_obtener_usuario_por_nombre(?)");
    $stmt->execute([$usuario]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    $stmt->closeCursor();

    if ($user) {
        // Verificar contraseña
    if (password_verify($password, $user['password'])) {
    $_SESSION['id_usuario'] = $user['id_usuario'];
    $_SESSION['usuario'] = $user['usuario'];
    $_SESSION['rol'] = $user['rol'];  // <--- agregar rol en sesión
    header('Location: dashboard.php');
    exit;
}
 else {
            echo "Contraseña incorrecta.";
        }
    } else {
        echo "Usuario no encontrado.";
    }
} else {
    header('Location: login.html');
    exit;
}
?>
