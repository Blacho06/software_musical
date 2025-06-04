-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-06-2025 a las 22:08:42
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `inventario_musical`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`, `activo`) VALUES
(1, 'Guitarras', 'Guitarras acústicas y eléctricas', 1),
(2, 'Pianos', 'Pianos acústicos y digitales', 1),
(3, 'Percusión', 'Baterías y instrumentos de percusión', 1),
(4, 'Vientos', 'Instrumentos de viento madera y metal', 1),
(5, 'Cuerdas', 'Violines, violas, cellos y contrabajos', 1),
(6, 'Accesorios', 'Cables, púas, soportes y otros accesorios', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `apellido` varchar(200) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `apellido`, `telefono`, `email`, `direccion`, `fecha_registro`) VALUES
(1, 'Juan', 'Pérez', '555-0001', 'juan.perez@email.com', NULL, '2025-06-04 20:05:04'),
(2, 'María', 'González', '555-0002', 'maria.gonzalez@email.com', NULL, '2025-06-04 20:05:04'),
(3, 'Carlos', 'Rodríguez', '555-0003', 'carlos.rodriguez@email.com', NULL, '2025-06-04 20:05:04'),
(4, 'Ana', 'Martínez', '555-0004', 'ana.martinez@email.com', NULL, '2025-06-04 20:05:04'),
(5, 'Luis', 'García', '555-0005', 'luis.garcia@email.com', NULL, '2025-06-04 20:05:04');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ventas`
--

CREATE TABLE `detalle_ventas` (
  `id` int(11) NOT NULL,
  `venta_id` int(11) DEFAULT NULL,
  `instrumento_id` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `instrumentos`
--

CREATE TABLE `instrumentos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `categoria_id` int(11) DEFAULT NULL,
  `marca` varchar(100) DEFAULT NULL,
  `modelo` varchar(100) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `stock_minimo` int(11) DEFAULT 5,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `instrumentos`
--

INSERT INTO `instrumentos` (`id`, `nombre`, `descripcion`, `categoria_id`, `marca`, `modelo`, `precio`, `stock`, `stock_minimo`, `imagen`, `activo`, `fecha_creacion`) VALUES
(1, 'Guitarra Acústica Yamaha', 'Guitarra acústica de calidad con sonido cálido y equilibrado', 1, 'Yamaha', 'FG800', 299.99, 15, 5, '🎸', 1, '2025-06-04 20:05:04'),
(2, 'Piano Digital Casio', 'Piano digital con 88 teclas pesadas y sonidos realistas', 2, 'Casio', 'CDP-S110', 599.99, 8, 5, '🎹', 1, '2025-06-04 20:05:04'),
(3, 'Batería Completa Pearl', 'Set completo de batería profesional de 5 piezas', 3, 'Pearl', 'Export EXX', 799.99, 3, 5, '🥁', 1, '2025-06-04 20:05:04'),
(4, 'Violín 4/4 Stentor', 'Violín tamaño completo ideal para estudiantes', 5, 'Stentor', 'Student I', 199.99, 12, 5, '🎻', 1, '2025-06-04 20:05:04'),
(5, 'Saxofón Alto Yamaha', 'Saxofón alto profesional en Mi bemol', 4, 'Yamaha', 'YAS-280', 899.99, 5, 5, '🎷', 1, '2025-06-04 20:05:04'),
(6, 'Guitarra Eléctrica Fender', 'Guitarra eléctrica Stratocaster clásica', 1, 'Fender', 'Player Stratocaster', 449.99, 7, 5, '🎸', 1, '2025-06-04 20:05:04'),
(7, 'Bajo Eléctrico Ibanez', 'Bajo eléctrico de 4 cuerdas con sonido versátil', 1, 'Ibanez', 'GSR200', 349.99, 6, 5, '🎸', 1, '2025-06-04 20:05:04'),
(8, 'Flauta Traversa Gemeinhardt', 'Flauta traversa plateada para principiantes', 4, 'Gemeinhardt', '2SP', 299.99, 10, 5, '🎶', 1, '2025-06-04 20:05:04'),
(9, 'Teclado Yamaha', 'Teclado de 61 teclas con ritmos y sonidos', 2, 'Yamaha', 'PSR-E373', 179.99, 20, 5, '🎹', 1, '2025-06-04 20:05:04'),
(10, 'Trompeta Bach', 'Trompeta profesional en Si bemol', 4, 'Bach', 'TR300H2', 399.99, 4, 5, '🎺', 1, '2025-06-04 20:05:04');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_inventario`
--

CREATE TABLE `movimientos_inventario` (
  `id` int(11) NOT NULL,
  `instrumento_id` int(11) DEFAULT NULL,
  `tipo_movimiento` varchar(50) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `stock_anterior` int(11) NOT NULL,
  `stock_nuevo` int(11) NOT NULL,
  `motivo` varchar(200) DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `fecha_movimiento` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `rol` varchar(50) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `username`, `password`, `nombre`, `rol`, `id_rol`, `activo`, `fecha_creacion`) VALUES
(1, 'admin', 'admin123', 'Administrador', 'Administrador', 1, 1, '2025-06-04 20:05:04'),
(2, 'dueno', 'dueno123', 'Propietario', 'Dueño', 2, 1, '2025-06-04 20:05:04'),
(3, 'vendedor', 'vendedor123', 'Vendedor', 'Vendedor', 3, 1, '2025-06-04 20:05:04');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `fecha_venta` timestamp NOT NULL DEFAULT current_timestamp(),
  `subtotal` decimal(10,2) NOT NULL,
  `descuento` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `estado` varchar(50) DEFAULT 'completada'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_instrumentos_completa`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_instrumentos_completa` (
`id` int(11)
,`nombre` varchar(200)
,`descripcion` text
,`categoria` varchar(100)
,`marca` varchar(100)
,`modelo` varchar(100)
,`precio` decimal(10,2)
,`stock` int(11)
,`stock_minimo` int(11)
,`imagen` varchar(255)
,`nivel_stock` varchar(5)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_ventas_resumen`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_ventas_resumen` (
`id` int(11)
,`fecha_venta` timestamp
,`cliente` varchar(401)
,`vendedor` varchar(100)
,`total` decimal(10,2)
,`total_items` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_instrumentos_completa`
--
DROP TABLE IF EXISTS `vista_instrumentos_completa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_instrumentos_completa`  AS SELECT `i`.`id` AS `id`, `i`.`nombre` AS `nombre`, `i`.`descripcion` AS `descripcion`, `c`.`nombre` AS `categoria`, `i`.`marca` AS `marca`, `i`.`modelo` AS `modelo`, `i`.`precio` AS `precio`, `i`.`stock` AS `stock`, `i`.`stock_minimo` AS `stock_minimo`, `i`.`imagen` AS `imagen`, CASE WHEN `i`.`stock` <= `i`.`stock_minimo` THEN 'Bajo' WHEN `i`.`stock` <= `i`.`stock_minimo` * 2 THEN 'Medio' ELSE 'Alto' END AS `nivel_stock` FROM (`instrumentos` `i` left join `categorias` `c` on(`i`.`categoria_id` = `c`.`id`)) WHERE `i`.`activo` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_ventas_resumen`
--
DROP TABLE IF EXISTS `vista_ventas_resumen`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_ventas_resumen`  AS SELECT `v`.`id` AS `id`, `v`.`fecha_venta` AS `fecha_venta`, concat(`c`.`nombre`,' ',coalesce(`c`.`apellido`,'')) AS `cliente`, `u`.`nombre` AS `vendedor`, `v`.`total` AS `total`, count(`dv`.`id`) AS `total_items` FROM (((`ventas` `v` left join `clientes` `c` on(`v`.`cliente_id` = `c`.`id`)) left join `usuarios` `u` on(`v`.`usuario_id` = `u`.`id`)) left join `detalle_ventas` `dv` on(`v`.`id` = `dv`.`venta_id`)) GROUP BY `v`.`id`, `v`.`fecha_venta`, `c`.`nombre`, `c`.`apellido`, `u`.`nombre`, `v`.`total` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_detalle_ventas_venta` (`venta_id`),
  ADD KEY `idx_detalle_ventas_instrumento` (`instrumento_id`);

--
-- Indices de la tabla `instrumentos`
--
ALTER TABLE `instrumentos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_instrumentos_categoria` (`categoria_id`),
  ADD KEY `idx_instrumentos_stock` (`stock`);

--
-- Indices de la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `instrumento_id` (`instrumento_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `idx_ventas_fecha` (`fecha_venta`),
  ADD KEY `idx_ventas_usuario` (`usuario_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `instrumentos`
--
ALTER TABLE `instrumentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  ADD CONSTRAINT `detalle_ventas_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`),
  ADD CONSTRAINT `detalle_ventas_ibfk_2` FOREIGN KEY (`instrumento_id`) REFERENCES `instrumentos` (`id`);

--
-- Filtros para la tabla `instrumentos`
--
ALTER TABLE `instrumentos`
  ADD CONSTRAINT `instrumentos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`);

--
-- Filtros para la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  ADD CONSTRAINT `movimientos_inventario_ibfk_1` FOREIGN KEY (`instrumento_id`) REFERENCES `instrumentos` (`id`),
  ADD CONSTRAINT `movimientos_inventario_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
