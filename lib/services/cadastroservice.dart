import 'package:buscapet/classes/classeuser.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../classes/classecadastro.dart';

class ServicePet {
  // URL do endpoint do backend para cadastro
  Global global = Global();
  HashCode _hashCode = HashCode();

  // Método para cadastrar um novo animal
  Future<void> cadPetApi(CadastroPet cadastro) async {
    // Convertendo o objeto Cadastro para JSON
    String cadastroJson = jsonEncode(cadastro.toJson());
    // Enviando os dados para o backend
    http.Response response = await http.post(
      Uri.parse('${global.urlGeral}/pet/cad'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: cadastroJson,
    );

    // Verificando a resposta do servidor
    if (response.statusCode == 200) {
      print('Cadastro enviado com sucesso!');
    } else if (response.statusCode == 201) {
      print('Cadastro criado com sucesso!');
    } else {
      throw Exception('Falha ao enviar cadastro: ${response.statusCode}');
    }
  }

 

}
