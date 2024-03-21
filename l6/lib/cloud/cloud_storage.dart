import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:archive/archive.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'cloud_path.dart';

class CloudStorage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static const List<String> compressedSizes = ['1024x1024'];

  Future<List<String>> listFiles(
    String directoryPath,
    String? bucketName,
  ) async {
    Reference ref;
    if (null == bucketName) {
      ref = _firebaseStorage.ref(directoryPath);
    } else {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: bucketName,
      );
      ref = storage.ref(directoryPath);
    }
    ListResult result = await ref.listAll();
    List<String> fileList = [];
    for (var ref in result.items) {
      fileList.add(ref.name);
    }
    return fileList;
  }

  Future<String> getDownloadUrl(String objectPath) async {
    String downloadUrl =
        await _firebaseStorage.ref(objectPath).getDownloadURL();
    return downloadUrl;
  }

  Future<bool> uploadFile(String filePath, String objectPath) async {
    File file = File(filePath);
    try {
      await _firebaseStorage.ref(objectPath).putFile(file);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadRawData(String input, String objectPath) async {
    List<int> encoded = utf8.encode(input);
    Uint8List data = Uint8List.fromList(encoded);
    try {
      await _firebaseStorage.ref(objectPath).putData(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> downloadRawData(String objectPath, String? bucketName) async {
    try {
      Uint8List? downloadedData;
      if (null == bucketName) {
        downloadedData = await _firebaseStorage.ref(objectPath).getData();
      } else {
        FirebaseStorage storage = FirebaseStorage.instanceFor(
          bucket: bucketName,
        );
        downloadedData = await storage.ref(objectPath).getData();
      }
      return utf8.decode(downloadedData!);
    } catch (e) {
      return null;
    }
  }

  Future<bool> uploadCompressedData(String input, String objectPath) async {
    List<int>? encoded = utf8.encode(input);
    List<int>? compressed = GZipEncoder().encode(encoded);
    Uint8List? data = Uint8List.fromList(compressed!);
    try {
      await _firebaseStorage.ref(objectPath).putData(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> downloadCompressedData(String objectPath) async {
    try {
      Uint8List? compressedData =
          await _firebaseStorage.ref(objectPath).getData();
      List<int>? uncompressedData = GZipDecoder().decodeBytes(compressedData!);
      return utf8.decode(uncompressedData);
    } catch (e) {
      return null;
    }
  }
/*
  Future<bool> uploadImageFile(
    String filePath,
    String objectPath,
    String? mimeType,
  ) async {
    File file = File(filePath);
    try {
      final metadata = SettableMetadata(
        contentType: mimeType,
      );
      // Get the image bucket.
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: CloudPath.getImageBucket(),
      );
      await storage
          .ref(objectPath)
          .putFile(file, metadata)
          .timeout(const Duration(seconds: 30));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadEncodedImageData(
    Uint8List input,
    String objectPath,
    String? mimeType,
  ) async {
    try {
      // Get the image bucket.
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: CloudPath.getImageBucket(),
      );
      final metadata = SettableMetadata(
        contentType: mimeType,
      );
      await storage
          .ref(objectPath)
          .putData(input, metadata)
          .timeout(const Duration(seconds: 30));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getImageDownloadUrl(String objectPath) async {
    try {
      String? downloadUrl;
      // Get the image bucket.
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: CloudPath.getImageBucket(),
      );
      // If the image is compressed its name will be: objectName_compressedSize
      // Try with compressed sizes first.
      for (int i = 0; i < compressedSizes.length; i++) {
        try {
          downloadUrl = await storage
              .ref(objectPath + '_' + compressedSizes[i])
              .getDownloadURL();
          // break on the first download url.
          break;
        } catch (e) {
          continue;
        }
      }
      // If no compressed image found
      // try with the original image name.
      downloadUrl ??= await storage.ref(objectPath).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  } */
}
