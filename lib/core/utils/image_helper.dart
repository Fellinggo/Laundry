// lib/utils/image_helper.dart
import 'package:flutter/material.dart';

class ImageHelper {
  // Mapping gambar berdasarkan value dari field 'image' di JSON
  static const Map<String, String> _imageAssetMap = {
    'regular': 'assets/images/Cucireg.png',
    'setrika': 'assets/images/Cucisetrika.png',
    'kering': 'assets/images/kering.png',
    'paket': 'assets/images/paket.png',
    'jas/gaun': 'assets/images/jasgaun.png',
    'setrika saja': 'assets/images/setrikasaja.png',
    'bedcover': 'assets/images/sprei.png',
    'sepatu': 'assets/images/sepatu.png',
  };
  
  // Default image jika tidak ditemukan mapping
  static const String _defaultImage = 'assets/images/services/default_service.png';
  
  /// Mendapatkan path asset gambar berdasarkan keyword dari API
  static String getImagePath(String imageKeyword) {
    if (imageKeyword.isEmpty) {
      return _defaultImage;
    }
    
    // Coba cari mapping exact match
    if (_imageAssetMap.containsKey(imageKeyword)) {
      return _imageAssetMap[imageKeyword]!;
    }
    
    // Coba cari dengan lowercase
    final lowerKeyword = imageKeyword.toLowerCase();
    for (var entry in _imageAssetMap.entries) {
      if (entry.key.toLowerCase() == lowerKeyword) {
        return entry.value;
      }
    }
    
    // Coba cari partial match (untuk jaga-jaga)
    for (var entry in _imageAssetMap.entries) {
      if (lowerKeyword.contains(entry.key.toLowerCase()) || 
          entry.key.toLowerCase().contains(lowerKeyword)) {
        return entry.value;
      }
    }
    
    // Jika tidak ditemukan, return default
    return _defaultImage;
  }
  
  /// Widget builder untuk gambar dengan fallback
  static Widget buildServiceImage({
    required String imageKeyword,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final imagePath = getImagePath(imageKeyword);
    
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback jika asset tidak ditemukan
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: (width ?? 40) / 2,
                color: Colors.grey[400],
              ),
              if (height != null && height > 80)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'No Image',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}