import 'dart:async';
import 'package:flutter/services.dart';

class ImageGallerySaver {
  static const MethodChannel _channel = MethodChannel('image_gallery_saver');

  /// Save image to gallery
  ///
  /// [imageBytes] Image bytes
  /// [quality] Quality of the image, defaults to 80
  /// [name] Name of the image, defaults to current timestamp
  static Future<Map<String, dynamic>> saveImage(
    Uint8List imageBytes, {
    int quality = 80,
    String? name,
  }) async {
    final result = await _channel.invokeMethod(
      'saveImageToGallery',
      <String, dynamic>{
        'imageBytes': imageBytes,
        'quality': quality.toString(),
        'name': name,
      },
    );
    return Map<String, dynamic>.from(result);
  }

  /// Save file to gallery
  ///
  /// [file] File path
  /// [name] Name of the file, defaults to the file name
  static Future<Map<String, dynamic>> saveFile(String file, {String? name}) async {
    final result = await _channel.invokeMethod(
      'saveFileToGallery',
      <String, dynamic>{
        'filePath': file,
        'name': name,
      },
    );
    return Map<String, dynamic>.from(result);
  }
}
