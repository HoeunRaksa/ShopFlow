import 'dart:io';
import 'package:dio/dio.dart';

class FileUploadHelper {
  FileUploadHelper._();

  static Future<FormData> imageToFormData(
      File file, {
        String fieldName = "image",
      }) async {
    return FormData.fromMap({
      fieldName: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });
  }
}