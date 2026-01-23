
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageHelper {
  final ImagePicker _picker = ImagePicker();

  final Cloudinary _cloudinary = Cloudinary.unsignedConfig(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
  );  

  Future<XFile?> pickImage() async {
    try{
    final XFile? image =
       await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      return image;
  } catch (err) {
      print("Lỗi chọn ảnh: $err");
      return null;
    }
  }

  Future<String?> uploadToCloudinary (XFile imageFile) async{
    try{
      final bytes = await imageFile.readAsBytes();
        final response = await _cloudinary.unsignedUpload(
          file: imageFile.path,
          fileBytes: bytes,
          resourceType: CloudinaryResourceType.image,
          uploadPreset: dotenv.env['CLOUDINARY_UPLOAD_PRESET'],
        );

        if(response.isSuccessful){
          return response.secureUrl;
        }

        return null;
     
    }catch(err){
      print("Lỗi hệ thống: $err");
      return null;
    }
  }
 
}
