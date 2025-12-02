import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageUtils {
  static Future<File> compressAndGetFile(File file, {int quality = 70}) async {
    final dir = await getApplicationDocumentsDirectory();
    final targetPath = p.join(dir.path, 'images', '${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}');
    await Directory(p.join(dir.path, 'images')).create(recursive: true);
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      keepExif: false,
    );
    return result ?? file;
  }
}
