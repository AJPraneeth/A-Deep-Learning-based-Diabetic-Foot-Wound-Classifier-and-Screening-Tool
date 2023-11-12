// import 'dart:typed_data';
// import 'package:tflite_flutter/tflite_flutter.dart';
// //import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'package:image/image.dart' as img;

// class StickerSegmentationService {
//   late Interpreter interpreter;
//   late InterpreterOptions _interpreterOptions;
//   //late int outputType = TfLiteType.kTfLiteFloat32;
//   late TensorType outputType = interpreter.getOutputTensor(0).type;
//   late TensorType inputType = interpreter.getInputTensor(0).type;

//   late Float32List outputBuffer;
//   late List<int> inputShape;
//   late List<int> outputShape;

//   StickerSegmentationService({String? modelPath}) {
//     _interpreterOptions = InterpreterOptions();
//     _interpreterOptions.threads = 1;

//     if (modelPath != null) {
//       loadModel(modelPath);
//     } else {
//       print('Error: Model path is null.');
//     }
//   }
//   Future<void> loadModel(String modelPath) async {
//     try {
//       interpreter =
//           await Interpreter.fromAsset(modelPath, options: _interpreterOptions);

//       inputShape = interpreter.getInputTensor(0).shape;
//       outputShape = interpreter.getOutputTensor(0).shape;

//       outputBuffer = Float32List(outputShape.reduce((a, b) => a * b));

//       print('Load Model - $inputShape / $outputShape / $outputType?$inputType');
//     } catch (err) {
//       print('Error: ${err.toString()}');
//     }
//   }

//   Future<img.Image?> segmentImage(Uint8List imageData) async {
//     if (interpreter == null) {
//       print('Error: Model has not been loaded.');
//       return null;
//     }
//     print('segmentImage1');
//     img.Image? baseImage = img.decodeImage(imageData); // Removed the null check

//     // Resize the input image to match the model's input shape
//     img.Image resizedImage = img.copyResize(
//       baseImage!,
//       width: inputShape[2],
//       height: inputShape[1],
//       interpolation:
//           img.Interpolation.nearest, // Use nearest neighbor for resizing
//     );
//     print(resizedImage);
//     print('segmentImage2');
//     // Convert the resized image to a list of float values
//     List<double> inputData = [];
//     for (int y = 0; y < inputShape[1]; y++) {
//       for (int x = 0; x < inputShape[2]; x++) {
//         final color = resizedImage.getPixel(x, y);
//         inputData.add(color.r / 255.0); // Normalize the red component to [0, 1]
//         inputData
//             .add(color.g / 255.0); // Normalize the green component to [0, 1]
//         inputData
//             .add(color.b / 255.0); // Normalize the blue component to [0, 1]
//       }
//     }
//     print(inputData);
//     print('segmentImage3');
//     interpreter.run(Float32List.fromList(inputData), outputBuffer);

//     // Post-process the segmentation result and create a segmented image
//     // ...

//     // Assuming that the outputBuffer contains the segmented image data as a list of bytes
//     Float32List outputData = outputBuffer;

//     Uint8List outputDataAsUint8List =
//         Uint8List.fromList(outputData.map((value) => value.toInt()).toList());
//     ByteBuffer outputDataByteBuffer = outputDataAsUint8List.buffer;
//     print('segmentImage4');
//     img.Image segmentedImage = img.Image.fromBytes(
//       width: inputShape[2],
//       height: inputShape[1],
//       bytes: outputDataByteBuffer,
//       // format: img.Format.int8, // Use img.Format.luminance or img.Format.gray
//     );
//     print('segmentImage1');
//     return segmentedImage;
//   }

//   void dispose() {
//     interpreter.close();
//   }
// }

