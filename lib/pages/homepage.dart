import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spicebite/pages/Dashboard.dart';
import 'package:spicebite/pages/navigationBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const QRScannerScreen(),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> with TickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController();
  bool _isTorchOn = false;
  bool _qrDetected = false;
  String? _scannedData;
  int selectedTable = 1;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  void _handleBarcode(BarcodeCapture barcodeCapture) {
    final barcodes = barcodeCapture.barcodes;
    if (barcodes.isNotEmpty && !_qrDetected) {
      setState(() {
        _qrDetected = true;
        _scannedData = barcodes.first.rawValue;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR detected: $_scannedData')),
        );
      }
    }
  }

  Future<void> _toggleTorch() async {
    try {
      await cameraController.toggleTorch();
      setState(() => _isTorchOn = !_isTorchOn);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to toggle torch')),
        );
      }
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanBoxSize = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('QR Scanner'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off),
      //       onPressed: _toggleTorch,
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [

          MobileScanner(
            controller: cameraController,
            onDetect: _handleBarcode,
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
                                _isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: _toggleTorch,
                              tooltip: _isTorchOn ? 'Turn Off Torch' : 'Turn On Torch',
                            ),
                             Column(
                              children: [
                                
                                Image.asset(
                                  'assets/logo.png',
                                  height: 80,
                                ),
                                Text(
                                  _qrDetected ? "QR Code Detected!" : "Scanning...",
                                  style: TextStyle(
                                    color: _qrDetected ? Colors.green : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () async {
                                // Properly stop camera before navigating
                                await cameraController.stop();
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              },
                            ),


                          ],
                        ),
                      ),

          // Bottom controls
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Table:",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final number = int.tryParse(value);
                          if (number != null && number > 0) {
                            setState(() => selectedTable = number);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_qrDetected) {
                      // Stop camera before navigating
                      await cameraController.stop();
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Navigation(selectedIndex: 0)
                            //   tableNumber: selectedTable,
                            //   qrData: _scannedData,
                            // ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please scan a QR code first')),
                      );
                    }
                  },
                  child: const Text('Proceed'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class Dashboard extends StatelessWidget {
//   final int tableNumber;
//   final String? qrData;

//   const Dashboard({
//     super.key,
//     required this.tableNumber,
//     this.qrData,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Dashboard')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Table: $tableNumber'),
//             if (qrData != null) Text('QR Data: $qrData'),
//           ],
//         ),
//       ),
//     );
//   }
// }