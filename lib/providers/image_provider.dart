import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

/// Provider to fetch all public URLs from a specific bucket
final bucketImagesProvider =
FutureProvider.family<List<String>, String>((ref, bucketName) async {
  try {
    // 1. List all files recursively (if needed) or just the root
    final files = await supabase.storage.from(bucketName).list();

    // 2. Map file names to their public URL
    final urls = files
    // Filter out any metadata files or folders if necessary (e.g., .emptyFolderPlaceholder)
    // A simple check is to ensure the name is not null or empty.
        .where((file) => file.name.isNotEmpty && file.name != '.emptyFolderPlaceholder')
        .map((file) {
      // The getPublicUrl method correctly constructs the URL
      return supabase.storage.from(bucketName).getPublicUrl(file.name);
    }).toList();

    return urls;
  } catch (e) {
    // Better to print the error for debugging
    print("Error fetching images: $e");
    throw Exception("Failed to fetch images from bucket '$bucketName': $e");
  }
});

