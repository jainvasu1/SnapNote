import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<dynamic> getPosts() async {
    return _get('/posts');
  }

  static Future<dynamic> _get(String path) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl$path'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw Exception('HTTP Error: ${response.statusCode}');
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }
}
