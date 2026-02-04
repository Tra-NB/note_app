import 'dart:typed_data';
import 'package:dio/dio.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:note_app/config.dart';
import 'package:note_app/domain/interface/repositories/i_storage_repository.dart';

class CloudinaryStorageRepository implements IStorageRepository {
  final Dio _dio = Dio();

  final String _cloudName = AppConfig.cloudinaryCloudName; 
  final String _uploadPreset = AppConfig.cloudinaryUploadPreset; 

  @override
  Future<String?> uploadImageAsync(XFile file) async {
    try {
      Uint8List bytes = await file.readAsBytes();

      String url = "https://api.cloudinary.com/v1_1/$_cloudName/image/upload";

      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(bytes, filename: file.name),
        "upload_preset": _uploadPreset,
      });

      var response = await _dio.post(url, data: formData);
      
      return response.data['secure_url'];
    } catch (e) {
      print("Lỗi upload Cloudinary: $e");
      return null;
    }
  }

  @override
  Future<void> deleteImageAsync(String imageUrl) async {
    
    print("xóa ảnh: $imageUrl");
  }
}