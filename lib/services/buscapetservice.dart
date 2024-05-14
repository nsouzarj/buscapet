import 'package:buscapet/classesutils/utilspet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../classes/classecadastro.dart';


class BuscapetService {
    Global global= Global();

    Future<List<CadastroPet>> getPetList()  async {
        try {
            // Replace with your actual API call or data retrieval method
            final response = await http.get(Uri.parse("${global.urlGeral}/pet/listapet"));

            if (response.statusCode == 200) {
              final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
              return parsed.map<CadastroPet>((json) => CadastroPet.fromJson(json)).toList();
            } else {
              throw Exception('Failed to load CadastroPet');
            }
        } catch (e) {

            // Handle exceptions during API call or JSON parsing
            throw Exception('Error fetching pet list: $e');
        }
    }
}

    // Custom Exception Class
class NetworkError implements Exception {
     final String message;
     NetworkError(this.message);
     @override
     String toString() => 'NetworkError: $message';
 }