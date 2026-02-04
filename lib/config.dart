import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get cloudinaryCloudName => dotenv.get('CLOUDINARY_CLOUD_NAME', fallback: '');
  static String get cloudinaryUploadPreset => dotenv.get('CLOUDINARY_UPLOAD_PRESET', fallback: '');
}