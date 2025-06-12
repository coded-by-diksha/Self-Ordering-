

import 'dart:typed_data';
import 'package:camera/camera.dart';

Uint8List convertYUV420ToNV21(CameraImage image) {
  final int width = image.width;
  final int height = image.height;
  
  final int uvRowStride = image.planes[1].bytesPerRow;
  final int uvPixelStride = image.planes[1].bytesPerPixel ?? 0;
  
  final Uint8List nv21 = Uint8List(width * height * 3 ~/ 2);
  
  // Copy Y plane
  final Uint8List yPlane = image.planes[0].bytes;
  nv21.setRange(0, width * height, yPlane);
  
  // Interleave U and V planes into NV21 format (VU interleaved)
  int index = width * height;
  final Uint8List uPlane = image.planes[1].bytes;
  final Uint8List vPlane = image.planes[2].bytes;
  
  for (int row = 0; row < height ~/ 2; row++) {
    for (int col = 0; col < width ~/ 2; col++) {
      final int uvIndex = row * uvRowStride + col * uvPixelStride;
      nv21[index++] = vPlane[uvIndex];
      nv21[index++] = uPlane[uvIndex];
    }
  }
  
  return nv21;
}