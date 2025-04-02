import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/material_controller.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AlternateCameraPage extends StatefulWidget {
  final String? codDepartment;

  const AlternateCameraPage({super.key, this.codDepartment,});

  @override
  State<AlternateCameraPage> createState() => _AlternateCameraPageState();
}

class _AlternateCameraPageState extends State<AlternateCameraPage> {
  String? _scannedCode;
  double _buttonBottomPosition = 0;
  double _buttonOpacity = 0.0;
  bool _isInFormPage = false;
  final MobileScannerController _scannerController = MobileScannerController();
  final MaterialController _materialController = MaterialController();


  List<Rect> _barcodeRects = [];

  @override
  void initState() {
    super.initState();

    _scannerController.start().then((_) {
      final size = _scannerController.cameraResolution;
      if (size != null) {
        debugPrint('Resolução capturada: ${size.width}x${size.height}');
      } else {
        debugPrint('Não foi possível determinar a resolução da câmera.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: (barcodeCapture) {
              final barcodes = barcodeCapture.barcodes;
              final List<Rect> detectedRects = [];
              for (var barcode in barcodes) {
                if (barcode.rawValue != null) {
                  detectedRects.add(_cornersToRect(barcode.corners));
                }
              }

              setState(() {
                _barcodeRects = detectedRects;
                if (barcodes.isNotEmpty && !_isInFormPage) {
                  _scannedCode = barcodes.first.rawValue;
                  _buttonBottomPosition = 50;
                  _buttonOpacity = 1.0;
                }
              });
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Mire em um código de barras para escanear',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: BarcodeRectPainter(_barcodeRects),
            child: Container(),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            bottom: _buttonBottomPosition,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _buttonOpacity,
              child: GestureDetector(
                onTap: () async {
                  if (_scannedCode != null) {
                    setState(() {
                      _isInFormPage = true;
                    });
                    MaterialModel checkMaterial =  await _materialController.checkMaterial(_scannedCode!, '');
                    if (checkMaterial.id.isEmpty && checkMaterial.barcode!.isEmpty){
                        Get.offNamed(Routes.MATERIAL,
                          parameters: {'codDepartment': widget.codDepartment!, 'barcode': _scannedCode!});
                      }
                    else{
                      MaterialModel checkMaterial =  await _materialController.checkMaterial(_scannedCode!, '');
                      await _materialController.navigateToMaterialDetails(context, checkMaterial);
                      Navigator.of(context).pop(); // Fecha a página atual
                    }
                  }
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Código: $_scannedCode',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Rect _mapRectToScreen(Rect rect, Size screenSize) {
    const scaleX = 0.8;
    const scaleY = 1.275;

    return Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );
  }

  Rect _cornersToRect(List<Offset> corners) {
    final left = corners.map((c) => c.dx).reduce((a, b) => a < b ? a : b);
    final top = corners.map((c) => c.dy).reduce((a, b) => a < b ? a : b);
    final right = corners.map((c) => c.dx).reduce((a, b) => a > b ? a : b);
    final bottom = corners.map((c) => c.dy).reduce((a, b) => a > b ? a : b);

    final rect = Rect.fromLTRB(left, top, right, bottom);
    final screenSize = MediaQuery.of(context).size;

    return _mapRectToScreen(rect, screenSize);
  }
}

class BarcodeRectPainter extends CustomPainter {
  final List<Rect> barcodeRects;

  BarcodeRectPainter(this.barcodeRects);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (var rect in barcodeRects) {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
