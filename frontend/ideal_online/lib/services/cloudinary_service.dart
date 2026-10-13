import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  // Replace with your actual Cloud Name and Unsigned Upload Preset
  static const String _cloudName = 'hgyzdtwi';
  static const String _uploadPreset = 'ideal_online_preset';

  static final _cloudinary = CloudinaryPublic(
    _cloudName,
    _uploadPreset,
    cache: false,
  );

  /// Uploads an image to Cloudinary and returns its high-res CDN HTTPS URL.
  static Future<String?> uploadImage(XFile imageFile) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'products',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl; // e.g. https://res.cloudinary.com/.../image.jpg
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }
}