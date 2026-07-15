import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class MeterCropView extends StatefulWidget {
  final String imagePath;
  const MeterCropView({super.key, required this.imagePath});

  @override
  State<MeterCropView> createState() => _MeterCropViewState();
}

class _MeterCropViewState extends State<MeterCropView> {
  final TransformationController _transformationController = TransformationController();
  bool _isProcessing = false;
  
  // Dimensi gambar asli
  int _originalWidth = 0;
  int _originalHeight = 0;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImageDimensions();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _loadImageDimensions() async {
    try {
      final file = File(widget.imagePath);
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded != null) {
        setState(() {
          _originalWidth = decoded.width;
          _originalHeight = decoded.height;
          _isImageLoaded = true;
        });
      }
    } catch (e) {
      debugPrint("Error loading image dimensions: $e");
    }
  }

  Future<void> _processCrop(double displayWidth, double displayHeight, double boxWidth, double boxHeight) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Dapatkan transformasi saat ini
      final matrix = _transformationController.value;
      final double scale = matrix.getMaxScaleOnAxis();
      final double tx = matrix.entry(0, 3);
      final double ty = matrix.entry(1, 3);

      // Hitung koordinat kotak fokus relatif terhadap viewport (yang berukuran displayWidth x displayHeight)
      final double boxLeft = (displayWidth - boxWidth) / 2;
      final double boxTop = (displayHeight - boxHeight) / 2;

      // Hitung koordinat pangkasan dalam skala viewport
      final double cropLeftInViewport = (boxLeft - tx) / scale;
      final double cropTopInViewport = (boxTop - ty) / scale;
      final double cropWidthInViewport = boxWidth / scale;
      final double cropHeightInViewport = boxHeight / scale;

      // Rasio konversi dari viewport ke resolusi asli
      final double ratioX = _originalWidth / displayWidth;
      final double ratioY = _originalHeight / displayHeight;

      // Hitung koordinat pangkasan akhir pada gambar asli
      final int finalX = (cropLeftInViewport * ratioX).toInt().clamp(0, _originalWidth);
      final int finalY = (cropTopInViewport * ratioY).toInt().clamp(0, _originalHeight);
      final int finalWidth = (cropWidthInViewport * ratioX).toInt().clamp(1, _originalWidth - finalX);
      final int finalHeight = (cropHeightInViewport * ratioY).toInt().clamp(1, _originalHeight - finalY);

      debugPrint("Crop: X=$finalX, Y=$finalY, W=$finalWidth, H=$finalHeight");

      // Lakukan pemotongan secara asinkron
      final file = File(widget.imagePath);
      final bytes = await file.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      
      if (originalImage != null) {
        final croppedImage = img.copyCrop(
          originalImage,
          x: finalX,
          y: finalY,
          width: finalWidth,
          height: finalHeight,
        );

        // Simpan ke file temp baru
        final tempDir = Directory.systemTemp;
        final croppedFile = File('${tempDir.path}/cropped_meter_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await croppedFile.writeAsBytes(img.encodeJpg(croppedImage, quality: 90));

        // Kembalikan path gambar yang terpotong ke controller
        Get.back(result: croppedFile.path);
      } else {
        throw Exception("Gagal memuat data piksel gambar");
      }
    } catch (e) {
      debugPrint("Crop failed: $e");
      Get.snackbar(
        'Gagal Memotong',
        'Terjadi kesalahan saat memotong gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090C15),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const Text(
                    'Pangkas Foto Meteran',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Deskripsi atas
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Sesuaikan angka meteran agar pas di dalam kotak fokus untuk mendapatkan hasil scan terbaik.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),

            Expanded(
              child: !_isImageLoaded
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // Tentukan ukuran display berdasarkan aspect ratio gambar
                        final double viewWidth = constraints.maxWidth;
                        final double viewHeight = constraints.maxHeight;
                        final double imgAR = _originalWidth / _originalHeight;

                        double displayWidth, displayHeight;
                        if (viewWidth / viewHeight > imgAR) {
                          displayHeight = viewHeight;
                          displayWidth = viewHeight * imgAR;
                        } else {
                          displayWidth = viewWidth;
                          displayHeight = viewWidth / imgAR;
                        }

                        // Dimensi kotak fokus di tengah
                        final double boxWidth = displayWidth * 0.85;
                        final double boxHeight = boxWidth * 0.25;

                        return Center(
                          child: Container(
                            width: displayWidth,
                            height: displayHeight,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Stack(
                              children: [
                                // InteractiveViewer untuk panning & zooming gambar
                                InteractiveViewer(
                                  transformationController: _transformationController,
                                  minScale: 1.0,
                                  maxScale: 5.0,
                                  boundaryMargin: const EdgeInsets.all(50),
                                  child: Image.file(
                                    File(widget.imagePath),
                                    width: displayWidth,
                                    height: displayHeight,
                                    fit: BoxFit.fill,
                                  ),
                                ),

                                // Bounding Box Custom Overlay
                                IgnorePointer(
                                  child: CustomPaint(
                                    size: Size(displayWidth, displayHeight),
                                    painter: BoundingBoxPainter(
                                      boxWidth: boxWidth,
                                      boxHeight: boxHeight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Panel Bawah / Action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  if (_isProcessing)
                    Center(
                      child: Column(
                        children: [
                          const CircularProgressIndicator(color: Colors.blue),
                          const SizedBox(height: 12),
                          const Text(
                            'Memotong gambar...',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  else SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D47A1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          // Ambil dimensi sebenarnya dari LayoutBuilder pas diklik
                          final renderBox = context.findRenderObject() as RenderBox?;
                          if (renderBox != null) {
                            // Mencari ukuran riil penampil gambar di dalam widget pohon
                            final double viewWidth = MediaQuery.of(context).size.width;
                            // Asumsikan perkiraan tinggi area gambar
                            final double imgAR = _originalWidth / _originalHeight;
                            // Kita hitung kembali dimensi display sesuai dengan LayoutBuilder
                            final double viewHeight = renderBox.size.height - 240; // Kurangi tinggi padding/panel
                            
                            double displayWidth, displayHeight;
                            if (viewWidth / viewHeight > imgAR) {
                              displayHeight = viewHeight;
                              displayWidth = viewHeight * imgAR;
                            } else {
                              displayWidth = viewWidth;
                              displayHeight = viewWidth / imgAR;
                            }

                            final double boxWidth = displayWidth * 0.85;
                            final double boxHeight = boxWidth * 0.25;

                            _processCrop(displayWidth, displayHeight, boxWidth, boxHeight);
                          }
                        },
                        icon: const Icon(Icons.crop_free),
                        label: const Text(
                          'Pangkas & Pindai',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final double boxWidth;
  final double boxHeight;

  BoundingBoxPainter({required this.boxWidth, required this.boxHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final double viewWidth = size.width;
    final double viewHeight = size.height;

    // Posisi kotak fokus
    final double left = (viewWidth - boxWidth) / 2;
    final double top = (viewHeight - boxHeight) / 2;
    final Rect boxRect = Rect.fromLTWH(left, top, boxWidth, boxHeight);

    // 1. Gambar overlay gelap transparan di luar kotak fokus
    final Paint overlayPaint = Paint()..color = Colors.black.withOpacity(0.65);
    
    // Atas
    canvas.drawRect(Rect.fromLTWH(0, 0, viewWidth, top), overlayPaint);
    // Kiri
    canvas.drawRect(Rect.fromLTWH(0, top, left, boxHeight), overlayPaint);
    // Kanan
    canvas.drawRect(Rect.fromLTWH(left + boxWidth, top, viewWidth - (left + boxWidth), boxHeight), overlayPaint);
    // Bawah
    canvas.drawRect(Rect.fromLTWH(0, top + boxHeight, viewWidth, viewHeight - (top + boxHeight)), overlayPaint);

    // 2. Gambar border kotak fokus
    final Paint borderPaint = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final RRect rrect = RRect.fromRectAndRadius(boxRect, const Radius.circular(8));
    canvas.drawRRect(rrect, borderPaint);

    // 3. Gambar sudut siku-siku yang lebih tebal (corner indicators) agar kelihatan seperti scanner professional
    final Paint cornerPaint = Paint()
      ..color = Colors.blue.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    
    const double cornerLength = 20.0;

    // Kiri Atas
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), cornerPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), cornerPaint);

    // Kanan Atas
    canvas.drawLine(Offset(left + boxWidth, top), Offset(left + boxWidth - cornerLength, top), cornerPaint);
    canvas.drawLine(Offset(left + boxWidth, top), Offset(left + boxWidth, top + cornerLength), cornerPaint);

    // Kiri Bawah
    canvas.drawLine(Offset(left, top + boxHeight), Offset(left + cornerLength, top + boxHeight), cornerPaint);
    canvas.drawLine(Offset(left, top + boxHeight), Offset(left, top + boxHeight - cornerLength), cornerPaint);

    // Kanan Bawah
    canvas.drawLine(Offset(left + boxWidth, top + boxHeight), Offset(left + boxWidth - cornerLength, top + boxHeight), cornerPaint);
    canvas.drawLine(Offset(left + boxWidth, top + boxHeight), Offset(left + boxWidth, top + boxHeight - cornerLength), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) {
    return oldDelegate.boxWidth != boxWidth || oldDelegate.boxHeight != boxHeight;
  }
}
