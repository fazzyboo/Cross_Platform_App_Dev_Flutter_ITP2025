import 'dart:convert';
import 'dart:io';
import 'constants.dart'; // contains bannerList, categoriesList, productList
import 'package:csv/csv.dart';

/// Convert image to base64
Future<String> imageToBase64(String path) async {
  final bytes = await File(path).readAsBytes();
  return base64Encode(bytes);
}

/// Generate CSV for banners
Future<void> generateBannersCSV() async {
  final List<List<String>> rows = [
    ['id', 'image_base64'] // Only include columns in your schema
  ];

  for (var banner in bannerList) {
    final base64Image = await imageToBase64(banner["imagePath"] as String);
    rows.add([
      banner["id"].toString(),
      base64Image,
    ]);
  }

  final csv = const ListToCsvConverter().convert(rows);
  final file = File('banners.csv');
  await file.writeAsString(csv);
  print("✅ banners.csv generated");
}

/// Generate CSV for categories
Future<void> generateCategoriesCSV() async {
  final List<List<String>> rows = [
    ['id', 'category', 'image_base64'] // Matches schema
  ];

  for (var category in categoriesList) {
    final base64Image = await imageToBase64(category["imagePath"] as String);
    rows.add([
      category["id"].toString(),
      category["category"],
      base64Image,
    ]);
  }

  final csv = const ListToCsvConverter().convert(rows);
  final file = File('categories.csv');
  await file.writeAsString(csv);
  print("✅ categories.csv generated");
}

/// Generate CSV for products
Future<void> generateProductsCSV() async {
  final List<List<String>> rows = [
    ['id', 'name', 'image_base64', 'oldPrice', 'newPrice', 'discount'] // Matches schema
  ];

  for (var product in productList) {
    final base64Image = await imageToBase64(product["imagePath"] as String);
    rows.add([
      product["id"].toString(),
      product["name"],
      base64Image,
      product["oldPrice"],
      product["newPrice"],
      product["discount"],
    ]);
  }

  final csv = const ListToCsvConverter().convert(rows);
  final file = File('products.csv');
  await file.writeAsString(csv);
  print("✅ products.csv generated");
}

/// Generate all CSVs
Future<void> generateAllCSVs() async {
  print("🌱 Generating CSV files...");
  await generateBannersCSV();
  await generateCategoriesCSV();
  await generateProductsCSV();
  print("🌱 CSV generation completed!");
}

