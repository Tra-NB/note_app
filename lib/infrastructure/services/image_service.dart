
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageService {

  Future<XFile> compressImage(XFile file) async {

    if (kIsWeb) {
      return file; 
    }

    try {
      final dir = await getTemporaryDirectory();
      
      final targetPath = p.join(
        dir.path, 
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg'
      );

      
      var result = await FlutterImageCompress.compressAndGetFile(
        file.path,    
        targetPath,    
        quality: 70,    
        minWidth: 1090, 
        minHeight: 1090,
      );

      if (result == null) {
        return file; 
      }

      
      return result;
    } catch (e) {
      print("Lỗi nén ảnh: $e");
      return file; 
    }
  }
}