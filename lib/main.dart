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

  Color? _color;

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.push<XFile>(context,
              MaterialPageRoute(builder: (context) => const CameraApp()));

          if (res != null) {
            final values = await res.readAsBytes();
            if (context.mounted) {
              _loadAndCropImage(context, values);
            }
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      body: SafeArea(
        child: Center(
          child: _croppedImage == null
              ? const Text('No Image')
              : Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Image.memory(
                      Uint8List.fromList(img.encodePng(_croppedImage!)),
                      fit: BoxFit.fitWidth,
                    ),
                    if (_color != null)
                      Positioned(
                        top: 50,
                        left: 16,
                        right: 16,
                        child: ColoredBox(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: 100,
                                color: _color,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Red:${_color!.red}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Green:${_color!.green}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Blue:${_color!.blue}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void _loadAndCropImage(BuildContext context, Uint8List bytes) async {
    // final center = context.size!.center(Offset.zero);
    // Load your image

    // Decode the image
    img.Image image = img.decodeImage(bytes)!;

    // // Calculate crop dimensions
    // int cropWidth = (image.width / 2).round();
    // int cropHeight = cropWidth;
    // int offsetX = (image.width / 4).round();
    // int offsetY = (image.height / 2 - cropHeight / 2).round();

    // // Crop the image
    // img.Image croppedImage = img.copyCrop(image,
    //     x: offsetX, y: offsetY, width: cropWidth, height: cropHeight);
    setState(() {
      _croppedImage = image;
    });
    if (_croppedImage != null) {
      final x = (image.width / 2).round();
      final y = (image.height / 2).round();
      final color = image.getPixelSafe(x, y);
      print('With====> : ${color.width}---${color.height}');
      setState(() {
        _color = Color.fromARGB(
            255, color.r.toInt(), color.g.toInt(), color.b.toInt());
      });
    }
  }
}
