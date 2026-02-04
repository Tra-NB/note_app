import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart'; // Đảm bảo đường dẫn này đúng

class ImageHelper {
  final ImagePicker _picker = ImagePicker();

  // Sửa lỗi: thêm {ImageSource source}
  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    return await _picker.pickImage(source: source);
  }

  // Sửa lỗi: thêm method uploadToCloudinary
 // Trong ImageHelper
Future<String?> uploadToCloudinary(XFile imageFile) async {
  try {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/${AppConfig.cloudinaryCloudName}/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = AppConfig.cloudinaryUploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = utf8.decode(responseData); 
    final jsonResponse = jsonDecode(responseString);

    if (response.statusCode == 200) {
      return jsonResponse['secure_url'] as String?; 
    } else {
      print("Cloudinary Error: ${jsonResponse['error']['message']}");
      return null;
    }
  } catch (e) {
    print("Upload Exception: $e");
    return null;
  }
}
}