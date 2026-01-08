import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  /// Get coordinates from an address string using Nominatim (OpenStreetMap)
  static Future<LatLng?> getCoordinatesFromAddress(String address) async {
    if (address.isEmpty) return null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?q=${Uri.encodeComponent(address)}&format=json&limit=1'),
        headers: {
          'User-Agent': 'AteApp/1.0', // Important for Nominatim's policy
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
    } catch (e) {
      print(' Geocoding error: $e');
    }
    return null;
  }
}
