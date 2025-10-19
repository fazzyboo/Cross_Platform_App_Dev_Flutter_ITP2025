// lib/core/utils/storage_helper.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageHelper {
  static final _supabase = Supabase.instance.client;

  // Get public URL for an image
  static String getPublicUrl(String bucket, String filePath) {
    return _supabase.storage.from(bucket).getPublicUrl(filePath);
  }

  // Get carousel image URL
  static String getCarouselImage(String fileName) {
    return getPublicUrl('carousels', fileName);
  }

  // Get category image URL
  static String getCategoryImage(String fileName) {
    return getPublicUrl('categories', fileName);
  }

  // Get product image URL
  static String getProductImage(String fileName) {
    return getPublicUrl('products', fileName);
  }

  // List all files in a bucket (useful for debugging)
  static Future<List<FileObject>> listFiles(String bucket) async {
    final files = await _supabase.storage.from(bucket).list();
    return files;
  }
}