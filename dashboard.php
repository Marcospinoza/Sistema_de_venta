<?php
session_start();

if (!isset($_SESSION['id_usuario'])) {
    header('Location: login.html');
    exit;
}

$rol = $_SESSION['rol'];
?>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <title>Dashboard</title>
  <style>
    /* Reset básico */
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
      background: #f5f7fa;
      color: #333;
      padding: 30px;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    h1 {
      color: #2c3e50;
      margin-bottom: 5px;
      font-size: 2.5rem;
    }

    h2 {
      color: #34495e;
      margin-bottom: 25px;
      font-weight: 400;
    }

    .container {
      background: white;
      width: 100%;
      max-width: 700px;
      border-radius: 10px;
      padding: 30px 40px;
      box-shadow: 0 8px 16px rgba(0,0,0,0.1);
    }

    p {
      font-size: 1.2rem;
      margin-bottom: 15px;
      color: #555;
    }

    ul {
      list-style: none;
      margin-bottom: 30px;
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
    }

    ul li {
      flex: 1 1 calc(50% - 15px);
    }

    ul li a {
      display: block;
      background: #3498db;
      color: white;
      padding: 12px 20px;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 600;
      text-align: center;
      box-shadow: 0 3px 6px rgba(52, 152, 219, 0.5);
      transition: background-color 0.3s ease;
    }

    ul li a:hover {
      background: #2980b9;
      box-shadow: 0 5px 10px rgba(41, 128, 185, 0.6);
    }

    .logout {
      display: inline-block;
      padding: 12px 25px;
      background: #e74c3c;
      color: white;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 700;
      box-shadow: 0 3px 7px rgba(231, 76, 60, 0.6);
      transition: background-color 0.3s ease;
      margin-top: auto;
    }

    .logout:hover {
      background: #c0392b;
      box-shadow: 0 5px 12px rgba(192, 57, 43, 0.8);
    }

    /* Responsive */
    @media (max-width: 480px) {
      ul li {
        flex: 1 1 100%;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Bienvenido, <?= htmlspecialchars($_SESSION['usuario']) ?></h1>
    <h2>Rol: <?= htmlspecialchars($rol) ?></h2>

    <?php if ($rol === 'administrador'): ?>
      <p>Opciones para administrador:</p>
      <ul>
        <li><a href="index.html">Gestionar Clientes</a></li>
        <li><a href="producto.html">Gestionar Productos</a></li>
        <li><a href="proveedor.html">Gestionar Proveedores</a></li>
        <li><a href="categoria.html">Gestionar Categorias</a></li>
        <li><a href="venta.html">Vender Productos </a></li>
      
    <?php elseif ($rol === 'operador'): ?>
      <p>Opciones para operador:</p>
      <ul>
        <li><a href="venta.html">Registrar Venta</a></li>
      </ul>
    <?php else: ?>
      <p>Rol desconocido.</p>
    <?php endif; ?>

    <a href="logout.php" class="logout">Cerrar sesión</a>
  </div>
</body>
</html>
