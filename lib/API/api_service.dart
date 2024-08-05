import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cctv_specification.dart';

class ApiService {
  final String baseUrl = 'http://192.168.192.240/cctv_api';

  Future<List<CCTVSpecification>> getCCTVSpecifications() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<CCTVSpecification> cctvSpecifications =
          body.map((dynamic item) => CCTVSpecification.fromJson(item)).toList();
      return cctvSpecifications;
    } else {
      throw Exception('Failed to load CCTVSpecification');
    }
  }

  Future<void> createCCTVSpecification(CCTVSpecification cctv) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': cctv.id,
        'name': cctv.name,
        'resolution': cctv.resolution,
        'lens_type': cctv.lensType,
        'description': cctv.description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create CCTVSpecification');
    }
  }

  Future<void> updateCCTVSpecification(CCTVSpecification cctv) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': cctv.id,
        'name': cctv.name,
        'resolution': cctv.resolution,
        'lens_type': cctv.lensType,
        'description': cctv.description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update CCTVSpecification');
    }
  }

  Future<void> deleteCCTVSpecification(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete CCTVSpecification');
    }
  }

  // Tambahkan metode getCCTVNames
  Future<List<String>> getCCTVNames() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<String> cctvNames =
          body.map((dynamic item) => item['name'].toString()).toList();
      return cctvNames;
    } else {
      throw Exception('Failed to load CCTV names');
    }
  }
}
