import 'dart:convert';
import 'dart:typed_data';

class ImageUtils {
  static Uint8List? decodeImage(String? imageString) {
    if (imageString == null || imageString.isEmpty) return null;

    try {
      // Case 1: Java Arrays.toString() format "[1, 2, 3]"
      if (imageString.startsWith('[') && imageString.endsWith(']')) {
        // Remove brackets
        String clean = imageString.substring(1, imageString.length - 1);
        if (clean.isEmpty) return null;
        
        // Split by comma and parse to bytes (these are the bytes of the Base64 string!)
        List<String> byteStrings = clean.split(',');
        List<int> base64Bytes = byteStrings.map((s) => int.parse(s.trim())).toList();
        
        // Convert these bytes to the Base64 String
        String base64String = utf8.decode(base64Bytes);
        
        // Now decode the Base64 String to actual image bytes
        return base64Decode(base64String);
      } 
      // Case 2: Standard Base64 String
      else {
        return base64Decode(imageString);
      }
    } catch (e) {
      print("Error decoding image: $e");
      return null;
    }
  }
}
