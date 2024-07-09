import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _completer = Completer<bool>();

  late final Interpreter _interpreter;

  late final Tensor _inputTensor, _outputTensor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initData() async {
    final options = InterpreterOptions();
    _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite',
        options: options);
    // Get tensor input shape [1, 224, 224, 3]
    _inputTensor = _interpreter.getInputTensors().first;
    // Get tensor output shape [1, 1001]
    _outputTensor = _interpreter.getOutputTensors().first;

    _completer.complete(true);
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  void _incrementCounter() async {
    final ImagePicker picker = ImagePicker();

    final photo = await picker.pickImage(source: ImageSource.camera);
    await _completer.future;
    if (kDebugMode) {
      print('PATH---->${photo?.path}');
    }
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      img.Image imageInput = img.decodeImage(bytes)!;
      img.Image resizedImage =
          img.copyResize(imageInput, width: 224, height: 224);

      // Normalize the image pixels to be between 0 and 1
      var normalizedImage =
          resizedImage.getBytes().map((pixel) => pixel / 255.0).toList();

      // Convert the normalized image to Float32List
      Float32List inputImage = Float32List.fromList(normalizedImage);
      Float32List output = Float32List(1 * 1000);
      _interpreter.run(inputImage, output);
      print('DONE---->${output.toString()}');
    }
  }
}
