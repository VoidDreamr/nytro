import 'package:image/image.dart';
import 'package:nytro/core/ny_texture_2.dart';
import 'package:nytro/nytro_image/pixel_ext.dart';

extension NyTextureImage on NyTexture2 {
  static NyTexture2 fromImage(Image image) {
    final tex = NyTexture2.create(image.width, image.height);
    for (Pixel pixel in image) {
      tex.set(pixel.x, pixel.y, pixel.colorNormalized);
    }
    return tex;
  }

  static Future<NyTexture2?> fromFile(String path) async {
    Image? image = await decodeImageFile(path);
    if (image == null) {
      return null;
    } else {
      return fromImage(image);
    }
  }
}
