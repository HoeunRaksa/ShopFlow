import '../network/constants.dart';

class HelperImage {
  static String buildImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1000&auto=format&fit=crop';
    }
    if (imageUrl.startsWith('http')) return imageUrl;
    String cleanBase = AppConstants.baseUrl.replaceAll('/api', '');
    if (cleanBase.endsWith('/')) {
      if (imageUrl.startsWith('/')) {
        return '$cleanBase${imageUrl.substring(1)}';
      }
      return '$cleanBase$imageUrl';
    } else {
      if (imageUrl.startsWith('/')) {
        return '$cleanBase$imageUrl';
      }
      return '$cleanBase/$imageUrl';
    }
  }
}