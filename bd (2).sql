-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 30-05-2025 a las 01:00:15
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE PROCEDURE `sp_actualizar_categoria` (IN `p_id_categoria` INT, IN `p_descripcion` VARCHAR(100))   BEGIN
  UPDATE categorias
  SET descripcion = p_descripcion
  WHERE id_categoria = p_id_categoria;
END$$

CREATE PROCEDURE `sp_actualizar_cliente` (IN `p_id_cliente` INT, IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))   BEGIN
  UPDATE clientes
  SET nombres = p_nombres,
      apellidos = p_apellidos,
      direccion = p_direccion,
      telefono = p_telefono
  WHERE id_cliente = p_id_cliente;
END$$

CREATE PROCEDURE `sp_actualizar_producto` (IN `p_id_producto` INT, IN `p_descripcion` VARCHAR(50), IN `p_precio` DECIMAL(18,2), IN `p_stock` INT, IN `p_id_categoria` INT, IN `p_id_proveedor` INT)   BEGIN
  UPDATE productos
  SET descripcion = p_descripcion,
      precio = p_precio,
      stock = p_stock,
      id_categoria = p_id_categoria,
      id_proveedor = p_id_proveedor
  WHERE id_producto = p_id_producto;
END$$

CREATE PROCEDURE `sp_actualizar_proveedor` (IN `p_id_proveedor` INT, IN `p_razonsocial` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))   BEGIN
  UPDATE proveedores
  SET razonsocial = p_razonsocial,
      direccion = p_direccion,
      telefono = p_telefono
  WHERE id_proveedor = p_id_proveedor;
END$$

CREATE  PROCEDURE `sp_buscar_clientes` (IN `p_termino` VARCHAR(100))   BEGIN
  SELECT * FROM clientes
  WHERE nombres LIKE CONCAT('%', p_termino, '%')
     OR apellidos LIKE CONCAT('%', p_termino, '%');
END$$

CREATE PROCEDURE `sp_detalles_productos` ()   BEGIN
  SELECT p.id_producto, p.descripcion, p.precio, p.stock, c.descripcion AS categoria, pr.razonsocial AS proveedor
  FROM productos p
  JOIN categorias c ON p.id_categoria = c.id_categoria
  JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor;
END$$

CREATE PROCEDURE `sp_eliminar_categoria` (IN `p_id_categoria` INT)   BEGIN
  DELETE FROM categorias
  WHERE id_categoria = p_id_categoria;
END$$

CREATE PROCEDURE `sp_eliminar_cliente` (IN `p_id_cliente` INT)   BEGIN
  DELETE FROM clientes
  WHERE id_cliente = p_id_cliente;
END$$

CREATE  PROCEDURE `sp_eliminar_producto` (IN `p_id_producto` INT)   BEGIN
  DELETE FROM productos
  WHERE id_producto = p_id_producto;
END$$

CREATE  PROCEDURE `sp_eliminar_proveedor` (IN `p_id_proveedor` INT)   BEGIN
  DELETE FROM proveedores
  WHERE id_proveedor = p_id_proveedor;
END$$

CREATE  PROCEDURE `sp_insertar_categoria` (IN `p_descripcion` VARCHAR(100))   BEGIN
  INSERT INTO categorias (descripcion)
  VALUES (p_descripcion);
END$$

CREATE  PROCEDURE `sp_insertar_cliente` (IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))   BEGIN
  INSERT INTO clientes (nombres, apellidos, direccion, telefono)
  VALUES (p_nombres, p_apellidos, p_direccion, p_telefono);
END$$

CREATE  PROCEDURE `sp_insertar_producto` (IN `p_descripcion` VARCHAR(50), IN `p_precio` DECIMAL(18,2), IN `p_stock` INT, IN `p_id_categoria` INT, IN `p_id_proveedor` INT)   BEGIN
  INSERT INTO productos (descripcion, precio, stock, id_categoria, id_proveedor)
  VALUES (p_descripcion, p_precio, p_stock, p_id_categoria, p_id_proveedor);
END$$

CREATE PROCEDURE `sp_insertar_proveedor` (IN `p_razonsocial` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))   BEGIN
  INSERT INTO proveedores (razonsocial, direccion, telefono)
  VALUES (p_razonsocial, p_direccion, p_telefono);
END$$

CREATE  PROCEDURE `sp_listar_categorias` ()   BEGIN
  SELECT * FROM categorias;
END$$

CREATE  PROCEDURE `sp_listar_clientes` ()   BEGIN
  SELECT * FROM clientes;
END$$

CREATE PROCEDURE `sp_listar_productos` ()   BEGIN
  SELECT 
    p.id_producto,
    p.descripcion,
    p.precio,
    p.stock,
    c.descripcion AS categoria,
    pr.razonsocial AS proveedor,
    p.id_categoria,
    p.id_proveedor
  FROM productos p
  INNER JOIN categorias c ON p.id_categoria = c.id_categoria
  INNER JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor;
END$$

CREATE  PROCEDURE `sp_listar_proveedores` ()   BEGIN
  SELECT * FROM proveedores;
END$$

CREATE  PROCEDURE `sp_obtener_categoria` (IN `p_id_categoria` INT)   BEGIN
  SELECT * FROM categorias
  WHERE id_categoria = p_id_categoria;
END$$

CREATE  PROCEDURE `sp_obtener_factura_venta` (IN `p_id_venta` INT)   BEGIN
  SELECT v.id_venta, v.fecha, c.nombres, c.apellidos, c.direccion, c.telefono
  FROM ventas v
  JOIN clientes c ON v.id_cliente = c.id_cliente
  WHERE v.id_venta = p_id_venta;

  SELECT p.descripcion, dv.cantidad, p.precio, (dv.cantidad * p.precio) AS subtotal
  FROM detalle_ventas dv
  JOIN productos p ON dv.id_producto = p.id_producto
  WHERE dv.id_venta = p_id_venta;

  SELECT SUM(dv.cantidad * p.precio) AS total
  FROM detalle_ventas dv
  JOIN productos p ON dv.id_producto = p.id_producto
  WHERE dv.id_venta = p_id_venta;
END$$

CREATE  PROCEDURE `sp_obtener_id_cliente` (IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50))   BEGIN
  SELECT id_cliente
  FROM clientes
  WHERE nombres = p_nombres AND apellidos = p_apellidos
  LIMIT 1;
END$$

CREATE  PROCEDURE `sp_obtener_producto` (IN `p_id_producto` INT)   BEGIN
  SELECT 
    id_producto,
    descripcion,
    precio,
    stock,
    id_categoria,
    id_proveedor
  FROM productos
  WHERE id_producto = p_id_producto;
END$$

CREATE  PROCEDURE `sp_obtener_proveedor` (IN `p_id_proveedor` INT)   BEGIN
  SELECT * FROM proveedores
  WHERE id_proveedor = p_id_proveedor;
END$$

CREATE PROCEDURE `sp_obtener_usuario_por_nombre` (IN `p_usuario` VARCHAR(50))   BEGIN
  SELECT id_usuario, usuario, password, rol
  FROM usuarios
  WHERE usuario = p_usuario;
END$$

CREATE  PROCEDURE `sp_obten_id_cliente` (IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50))   BEGIN
  SELECT *
  FROM clientes
  WHERE nombres = p_nombres AND apellidos = p_apellidos
  LIMIT 1;
END$$

CREATE  PROCEDURE `sp_registrar_detalle_venta` (IN `p_id_venta` INT, IN `p_id_producto` INT, IN `p_cantidad` INT)   BEGIN
  DECLARE v_stock INT;

  SELECT stock INTO v_stock FROM productos WHERE id_producto = p_id_producto;

  IF v_stock < p_cantidad THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
  ELSE
    INSERT INTO detalle_ventas(id_venta, id_producto, cantidad)
    VALUES(p_id_venta, p_id_producto, p_cantidad);

    UPDATE productos SET stock = stock - p_cantidad WHERE id_producto = p_id_producto;
  END IF;
END$$

CREATE  PROCEDURE `sp_registrar_venta` (IN `p_id_cliente` INT, OUT `p_id_venta` INT)   BEGIN
  INSERT INTO ventas(fecha, id_cliente) VALUES (NOW(), p_id_cliente);
  SET p_id_venta = LAST_INSERT_ID();
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `descripcion`) VALUES
(2, 'menestras'),
(3, 'lacteos'),
(4, 'Hogar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(50) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombres`, `apellidos`, `direccion`, `telefono`) VALUES
(8, 'luis', 'utos ceras', 'av. san carlos 2275', '96565656'),
(10, 'juan', 'campos', 'Jr. salaverry 789', '865678'),
(11, 'jose', 'rojas', 'Jr. salaverry ', '1536489'),
(12, 'rodrigo', 'pineda', 'av sal si te dejan', '123456789'),
(13, 'maria', 'pineda', 'av sal si puedes', '159732648'),
(14, 'damaris', 'solansh', 'av sal si te dejan', '789456'),
(15, 'marco', 'rosales', 'av sal si te dejan', '1597326'),
(16, 'lizbeth', 'mamani', 'av sal si puedes', '12346987');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ventas`
--

CREATE TABLE `detalle_ventas` (
  `id_detventa` int(11) NOT NULL,
  `id_venta` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `detalle_ventas`
--

INSERT INTO `detalle_ventas` (`id_detventa`, `id_venta`, `id_producto`, `cantidad`) VALUES
(15, 17, 2, 1),
(16, 17, 3, 7),
(17, 18, 2, 8),
(18, 18, 3, 2),
(19, 19, 2, 9),
(20, 20, 3, 10),
(21, 21, 2, 10),
(22, 21, 2, 10),
(23, 21, 2, 10),
(24, 21, 2, 10),
(25, 21, 2, 10),
(26, 21, 2, 10),
(27, 22, 3, 10),
(28, 23, 2, 10),
(29, 24, 3, 1),
(30, 27, 3, 10),
(31, 28, 2, 2),
(32, 29, 2, 2),
(33, 30, 2, 2),
(34, 31, 3, 1),
(35, 32, 3, 2),
(38, 35, 4, 1),
(39, 35, 3, 1),
(40, 35, 2, 1),
(41, 36, 2, 1),
(42, 37, 2, 10),
(43, 38, 3, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `precio` decimal(18,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `descripcion`, `precio`, `stock`, `id_categoria`, `id_proveedor`) VALUES
(2, 'lentejas', 34.00, 90, 2, 7),
(3, 'leche gloria', 23.90, 140, 3, 6),
(4, 'recojedor premium', 22.00, 900, 3, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `razonsocial` varchar(50) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `razonsocial`, `direccion`, `telefono`) VALUES
(6, 'alicorp', 'av. los nogales 890', '343545345'),
(7, 'gesa', 'av. los gamonales 567', '54654654');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `rol` enum('administrador','operador') NOT NULL DEFAULT 'operador'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `usuario`, `password`, `nombre`, `email`, `fecha_registro`, `rol`) VALUES
(1, 'juan', '$2y$10$AmpO/i1GLipmCRuf4XVzL.G1GKc20VjT8qCxxLYVpIGtGNmWwTaT6', 'juan', 'Marck@gmail.com', '2025-05-29 17:26:16', 'operador'),
(4, 'juanxd', '$2y$10$8yJqvqDV6FS6ITw6xDksgO7vC60J2wS9ylOe3MiafMjpMIrqkCiwK', 'juan', 'Marc@gmail.com', '2025-05-29 17:28:48', 'operador'),
(5, 'Marco', '$2y$10$p/zDfWhI1eU9SyIO8zWBeeWbf6x5wjGNwkdVZ/UXjXWikeurb/BZm', 'Marco', 'marco@gmail.com', '2025-05-29 19:41:30', 'administrador');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_venta` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `id_cliente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id_venta`, `fecha`, `id_cliente`) VALUES
(17, '2025-04-08 00:43:19', 8),
(18, '2025-04-08 00:46:03', 10),
(19, '2025-04-08 00:46:46', 8),
(20, '2025-05-29 11:19:15', 11),
(21, '2025-05-29 11:30:58', 10),
(22, '2025-05-29 11:41:54', 13),
(23, '2025-05-29 11:46:48', 13),
(24, '2025-05-29 11:48:13', 14),
(27, '2025-05-29 11:57:42', 12),
(28, '2025-05-29 15:09:09', 13),
(29, '2025-05-29 15:09:50', 13),
(30, '2025-05-29 15:16:23', 13),
(31, '2025-05-29 15:19:10', 12),
(32, '2025-05-29 15:22:11', 15),
(35, '2025-05-29 15:23:58', 15),
(36, '2025-05-29 16:18:19', 16),
(37, '2025-05-29 16:47:17', 15),
(38, '2025-05-29 17:34:31', 12);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indices de la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  ADD PRIMARY KEY (`id_detventa`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `id_venta` (`id_venta`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `id_categoria` (`id_categoria`),
  ADD KEY `id_proveedor` (`id_proveedor`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `usuario` (`usuario`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id_venta`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  MODIFY `id_detventa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  ADD CONSTRAINT `detalle_ventas_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detalle_ventas_ibfk_2` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productos_ibfk_2` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
