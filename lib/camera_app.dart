import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:recognize_solution/main.dart';

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class OverlayPainter extends CustomPainter {
  final double screenWidth;
  final double screenHeight;

  OverlayPainter({required this.screenWidth, required this.screenHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final double sideLength = screenWidth * 0.5; // Side length of the square
    const double strokeWidth = 2.0;
    final squarePath = Path()
      ..addRect(Rect.fromCenter(
        center: Offset(screenWidth / 2, screenHeight / 2),
        width: sideLength,
        height: sideLength,
      ));

    final outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight));
    final overlayPath =
        Path.combine(PathOperation.difference, outerPath, squarePath);

    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawPath(overlayPath, paint);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(screenWidth / 2, screenHeight / 2),
        width: sideLength,
        height: sideLength,
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
      ),
      body: Column(
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 0.6,
              child: Stack(
                children: [
                  Positioned.fill(child: CameraPreview(controller)),
                  CustomPaint(
                    painter: OverlayPainter(
                      screenWidth: MediaQuery.of(context).size.width,
                      screenHeight: MediaQuery.of(context).size.width / 6 * 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final image = await controller.takePicture();
                if (context.mounted) {
                  Navigator.pop(context, image);
                }
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Take Picture'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }
}
