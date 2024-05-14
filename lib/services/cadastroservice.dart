import 'package:buscapet/classes/classeuser.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../classes/classecadastro.dart';

class ServicePet {
  // URL do endpoint do backend para cadastro
  Global global = Global();

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

  //Cadasta o suario no sistem

  // Método para cadastrar um novo animal
  Future<void> cadUserApi(Usuario usuario) async {
    // Convertendo o objeto Cadastro para JSON
    String cadastroJson = jsonEncode(usuario.toJson());
    // Enviando os dados para o backend
    http.Response response = await http.post(
      Uri.parse('${global.urlGeral}/usuarios/caduser'),
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

// Método para verificar se o usuário existe
  Future<bool> verifyUserCad(String email, String senha) async {
    try {
      String senhaHash = hashPassword(senha);
      // Enviando os dados para o backend
      final response = await http.get(
        Uri.parse('${global.urlGeral}/usuarios/login/$email/$senhaHash'),
      );

      // Verificando a resposta do servidor
      if (response.statusCode == 200) {
        // Decodificando o corpo da resposta (que deve ser um booleano)
        final bool usuarioExiste = json.decode(response.body);
        return usuarioExiste;
      } else {
        throw Exception('Falha ao verificar usuário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao verificar usuário: $e');
      return false;
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
