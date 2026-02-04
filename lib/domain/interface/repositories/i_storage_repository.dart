import 'package:image_picker/image_picker.dart';


abstract class IStorageRepository {

  Future<String?> uploadImageAsync(XFile file);
  Future<void> deleteImageAsync(String publicId);
}