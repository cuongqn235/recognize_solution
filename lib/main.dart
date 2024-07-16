import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:recognize_solution/camera_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(const MyApp());
}

late List<CameraDescription> cameras;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  img.Image? _croppedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.push<XFile>(context,
              MaterialPageRoute(builder: (context) => const CameraApp()));

          if (res != null) {
            final values = await res.readAsBytes();
            _loadAndCropImage(values);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Center(
          child: _croppedImage == null
              ? const Text('No Image')
              : Image.memory(Uint8List.fromList(img.encodePng(_croppedImage!))),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // Color _calculateAverageColor(img.Image image) {
  //   image.getColor(r, g, b)
  //   int red = 0;
  //   int green = 0;
  //   int blue = 0;
  //   int pixelCount = image.width * image.height;

  //   for (int y = 0; y < image.height; y++) {
  //     for (int x = 0; x < image.width; x++) {
  //       int pixel = image.getPixel(x, y);
  //       red += img.getRed(pixel);
  //       green += img.getGreen(pixel);
  //       blue += img.getBlue(pixel);
  //     }
  //   }

  //   red = (red / pixelCount).round();
  //   green = (green / pixelCount).round();
  //   blue = (blue / pixelCount).round();

  //   return Color.fromRGBO(red, green, blue, 1.0);
  // }

  void _loadAndCropImage(Uint8List bytes) async {
    // Load your image

    // Decode the image
    img.Image image = img.decodeImage(bytes)!;

    // Calculate crop dimensions
    int cropWidth = (image.width / 2).round();
    int cropHeight = cropWidth;
    int offsetX = (image.width / 4).round();
    int offsetY = (image.height / 2 - cropHeight / 2).round();

    // Crop the image
    img.Image croppedImage = img.copyCrop(image,
        x: offsetX, y: offsetY, width: cropWidth, height: cropHeight);
    setState(() {
      _croppedImage = croppedImage;
    });
    if (_croppedImage != null) {
      final x = (image.width / 2).round();
      final y = (image.width / 2).round();
      final color = _croppedImage!.getPixelInterpolate(
        x,
        y,
      );
    }
  }
}
