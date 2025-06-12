// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';


// List<CameraDescription> cameras = [];

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: QRScannerScreen(),
//     );
//   }
// }

// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});

//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen> {
//   CameraController? controller;
//   Future<void>? _initializeControllerFuture;
//   int selectedTable = 1;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     final status = await Permission.camera.request();
//     if (status.isGranted) {
//       try {
//         if (cameras.isEmpty) {
//           cameras = await availableCameras();
//         }

//         if (cameras.isNotEmpty) {
//           controller = CameraController(cameras[0], ResolutionPreset.medium);
//           final initFuture = controller!.initialize();
//           setState(() {
//             _initializeControllerFuture = initFuture;
//           });
//         } else {
//           print('No camera found.');
//           setState(() {
//             _initializeControllerFuture = Future.error('No camera found');
//           });
//         }
//       } catch (e) {
//         print('Error initializing camera: $e');
//       }
//     } else {
//       print('Camera permission denied.');
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _initializeControllerFuture != null
//           ? FutureBuilder(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return Stack(
//                     children: [
//                       CameraPreview(controller!),

//                       // Scanner overlay
//                       const QRScannerOverlay(),

//                       // Top bar
//                       Positioned(
//                         top: 40,
//                         left: 20,
//                         right: 20,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               "Scan QR",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Image.asset(
//                                 'assets/logo.png', // Make sure your logo is in the assets folder
//                                 height: 50,       // Adjust the size as needed
//                               ),
                                  
                                  
                                  
                                  
//                                IconButton(
//                               icon: const Icon(Icons.close, color: Colors.white),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Bottom controls
//                       Positioned(
//                         bottom: 40,
//                         left: 20,
//                         right: 20,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text(
//                               "Table Number",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 const Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     "Please Enter Your Table Number: ",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: TextField(
//                                     keyboardType: TextInputType.number,
//                                     style: const TextStyle(color: Colors.white),
//                                     decoration: const InputDecoration(
//                                       hintText: "No.",
//                                       hintStyle: TextStyle(color: Colors.white54),
//                                       filled: true,
//                                       fillColor: Colors.black45,
//                                       border: OutlineInputBorder(),
//                                       contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                                     ),
//                                     onChanged: (value) {
//                                       final number = int.tryParse(value);
//                                       if (number != null && number > 0) {
//                                         setState(() {
//                                           selectedTable = number;
//                                         });
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 30),
//                               ),
//                               onPressed: () {
//                                 // Proceed action
//                               },
//                               child: const Text("Proceed"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                       child: Text('Camera error: ${snapshot.error}',
//                           style: const TextStyle(color: Colors.white)));
//                 } else {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//               },
//             )
//           : const Center(
//               child: Text("Waiting for camera permission...",
//                   style: TextStyle(color: Colors.white))),
//     );
//   }
// }

// class QRScannerOverlay extends StatelessWidget {
//   const QRScannerOverlay({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CustomPaint(
//         size: Size(MediaQuery.of(context).size.width * 0.8, 250),
//         painter: QRScannerPainter(),
//       ),
//     );
//   }
// }

// class QRScannerPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final borderPaint = Paint()
//       ..color = const Color.fromARGB(255, 80, 220, 5).withOpacity(0.8)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;

//     final greenLinePaint = Paint()
//       ..color = const Color.fromARGB(255, 175, 76, 76)
//       ..strokeWidth = 2;

//     final rect = Offset.zero & size;

//     canvas.drawRect(rect, borderPaint);

//     final centerY = size.height / 2;
//     canvas.drawLine(
//       Offset(0, centerY),
//       Offset(size.width, centerY),
//       greenLinePaint,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }



import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:my_app/pages/Dashboard.dart';
import 'helper/convertYUV420ToNV21.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QRScannerScreen(),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  CameraController? controller;
  Future<void>? _initializeControllerFuture;
  late final BarcodeScanner barcodeScanner;
  bool isDetecting = false;
  int selectedTable = 1;

    bool _qrDetected = false;
     bool _torchEnabled = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _initializeCamera();
  }

 Future<void> _initializeCamera() async {
  print("Requesting camera permission...");

  final status = await Permission.camera.request();
  if (!status.isGranted) {
    print('Camera permission denied.');
    return;
  }

  try {
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }

    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.medium);

      // Initialize the camera
      await controller!.initialize();
      print("Camera initialized successfully.");

      // Set up image analysis
    

      // Start the image stream
      controller!.startImageStream((CameraImage image) {
        print("Starting image stream...");
        _processCameraImage(image);
      });

      setState(() {
        _initializeControllerFuture = Future.value();
      });
    } else {
      print('No camera found.');
      setState(() {
        _initializeControllerFuture = Future.error('No camera found');
      });
    }
  } catch (e) {
    print('Error initializing camera: $e');
  }
}

 Future<void> _processCameraImage(CameraImage image) async {
  print("Processing camera image...");
  if (isDetecting) return;
  isDetecting = true;

  try {
   print("object detected");
    final bytes = convertYUV420ToNV21(image);
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    InputImageRotation imageRotation;
    switch (cameras[0].sensorOrientation) {
      case 0:
        imageRotation = InputImageRotation.rotation0deg;
        break;
      case 90:
        imageRotation = InputImageRotation.rotation90deg;
        break;
      case 180:
        imageRotation = InputImageRotation.rotation180deg;
        break;
      case 270:
        imageRotation = InputImageRotation.rotation270deg;
        break;
      default:
        imageRotation = InputImageRotation.rotation0deg;
    }
    // Create metadata for the input image

    print("Creating input image metadata...");
    // Ensure the bytesPerRow is set correctly for NV21 format


    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: InputImageFormat.nv21,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
    print("Processing input image for barcode detection...");
    // Process the image to detect barcodes
    try{  
      
        final barcodes = await barcodeScanner.processImage(inputImage);
         if (barcodes.isNotEmpty) {
      if (!_qrDetected) {
        setState(() {
          _qrDetected = true;
        });
      }
      for (final barcode in barcodes) {
         if (barcode.format == BarcodeFormat.qrCode) {
        // Handle the QR code value
        print('QR Code found: ${barcode.displayValue}');
      }
      }
    } else {
      
          _qrDetected = false;
          print("No barcodes detected.");
      }
    
    }
    catch(Exception){
      print("barcode not detected.");
    }
   
  } catch (e) {
    debugPrint('Barcode detection error: $e');
    if (_qrDetected) {
      setState(() {
        _qrDetected = false;
      });
    }
  } finally {
    isDetecting = false;
  }
}


  @override
  void dispose() {
    controller?.dispose();
    barcodeScanner.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scanBoxSize = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      backgroundColor: Colors.black,
      body: _initializeControllerFuture != null
          ? FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CameraPreview(controller!),
                      ),

                      // Scanner overlay
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: scanBoxSize,
                              height: scanBoxSize,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _qrDetected ? Colors.green : Colors.white,
                                     width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Positioned(
                                  top: scanBoxSize * _animation.value,
                                  child: Container(
                                    width: scanBoxSize,
                                    height: 2,
                                    color: Colors.red,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Top bar
                      Positioned(
                        top: 40,
                        left: 20,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                _torchEnabled ? Icons.flashlight_on : Icons.flashlight_off,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: _toggleTorch,
                              tooltip: _torchEnabled ? 'Turn Off Torch' : 'Turn On Torch',
                            ),

                            Image.asset(
                              'assets/logo.png', // Ensure your logo is in the assets folder
                              height: 130, // Adjust the size as needed
                            ),

                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),

                      // Bottom Input UI
                      Positioned(
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Table Number",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Enter Your Table Number:",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    style:
                                        const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: "No.",
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      filled: true,
                                      fillColor: Colors.black45,
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      final number = int.tryParse(value);
                                      if (number != null && number > 0) {
                                        setState(() {
                                          selectedTable = number;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 30),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Dashboard(
                                      
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Proceed"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Camera error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white)));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : const Center(
              child: Text("Waiting for camera permission...",
                  style: TextStyle(color: Colors.white))),
    );
  }

 Future<void> _toggleTorch() async {
    if (controller == null) return;
    try {
      if (_torchEnabled) {
        await controller!.setFlashMode(FlashMode.off);
      } else {
        await controller!.setFlashMode(FlashMode.torch);
      }
      setState(() {
        _torchEnabled = !_torchEnabled;
      });
    } catch (e) {
      print('Error toggling torch: $e');
    }
  }
  
}
