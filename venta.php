<?php
include 'conexion.php';
require('fpdf/fpdf.php'); // Ajusta la ruta si hace falta

try {
    $pdo->beginTransaction();

    // Recibimos id_cliente y productos JSON (array de {id, cantidad})
    $id_cliente = $_POST['id_cliente'];
    $productos = json_decode($_POST['productos'], true);

    // Registrar venta
    $stmt = $pdo->prepare("CALL sp_registrar_venta(?, @id_venta)");
    $stmt->execute([$id_cliente]);
    $stmt->closeCursor();

    // Obtener id_venta
    $idVentaResult = $pdo->query("SELECT @id_venta as id_venta")->fetch(PDO::FETCH_ASSOC);
    $id_venta = $idVentaResult['id_venta'];

    // Registrar detalle venta y actualizar stock
    $stmt = $pdo->prepare("CALL sp_registrar_detalle_venta(?, ?, ?)");
    foreach ($productos as $p) {
        $stmt->execute([$id_venta, $p['id'], $p['cantidad']]);
        $stmt->closeCursor();
    }

    $pdo->commit();

    // Obtener factura (3 conjuntos de resultados)
    $stmt = $pdo->prepare("CALL sp_obtener_factura_venta(?)");
    $stmt->execute([$id_venta]);

    // Primer conjunto: venta y cliente
    $venta = $stmt->fetch(PDO::FETCH_ASSOC);

    // Segundo conjunto: productos
    $stmt->nextRowset();
    $productosFactura = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Tercer conjunto: total
    $stmt->nextRowset();
    $totalResult = $stmt->fetch(PDO::FETCH_ASSOC);
    $total = $totalResult['total'];

    $stmt->closeCursor();

    // Crear PDF con FPDF
    class PDF extends FPDF {
        function Header() {
            $this->SetFont('Arial','B',16);
            $this->Cell(0,10,'Factura de Venta',0,1,'C');
            $this->Ln(5);
        }
        function Footer() {
            $this->SetY(-15);
            $this->SetFont('Arial','I',8);
            $this->Cell(0,10,'Pagina '.$this->PageNo().'/{nb}',0,0,'C');
        }
    }

    $pdf = new PDF();
    $pdf->AliasNbPages();
    $pdf->AddPage();
    $pdf->SetFont('Arial','',12);

    // Datos cliente
    $pdf->Cell(0,10,"Cliente: {$venta['nombres']} {$venta['apellidos']}",0,1);
    $pdf->Cell(0,10,"Direccion: {$venta['direccion']}",0,1);
    $pdf->Cell(0,10,"Telefono: {$venta['telefono']}",0,1);
    $pdf->Cell(0,10,"Fecha: {$venta['fecha']}",0,1);
    $pdf->Ln(10);

    // Tabla productos
    $pdf->SetFont('Arial','B',12);
    $pdf->Cell(80,10,'Producto',1);
    $pdf->Cell(30,10,'Cantidad',1);
    $pdf->Cell(40,10,'Precio',1);
    $pdf->Cell(40,10,'Subtotal',1);
    $pdf->Ln();

    $pdf->SetFont('Arial','',12);
    foreach ($productosFactura as $p) {
        $pdf->Cell(80,10,utf8_decode($p['descripcion']),1);
        $pdf->Cell(30,10,$p['cantidad'],1,0,'C');
        $pdf->Cell(40,10,number_format($p['precio'],2),1,0,'R');
        $pdf->Cell(40,10,number_format($p['subtotal'],2),1,0,'R');
        $pdf->Ln();
    }

    $pdf->SetFont('Arial','B',12);
    $pdf->Cell(150,10,'Total',1);
    $pdf->Cell(40,10,number_format($total,2),1,0,'R');

    // Enviar PDF inline al navegador
    header('Content-Type: application/pdf');
    $pdf->Output('I', 'FacturaVenta_'.$id_venta.'.pdf');

} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(400);
    echo json_encode(['error' => $e->getMessage()]);
}
?>
