import 'package:buscapet/classes/classeuser.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../classes/classecadastro.dart';
import 'package:buscapet/classesutils/utilspet.dart';

class UsuaroService{
    Global global = Global();
    HashCode _hashCode = HashCode();

 // Método para gerar codigo para trocar ou recuoerar a senha
  Future<bool> gerarCodigo(String email) async {
    try {

      // Enviando os dados para o backend
      final response = await http.get(
        Uri.parse('${global.urlGeral}/usuarios/gerarcodigo/$email'),
      );

      // Verificando a resposta do servidor
      if (response.statusCode == 200) {
        // Decodificando o corpo da resposta (que deve ser um booleano)
        final bool usuarioExiste = json.decode(response.body);
        return usuarioExiste;
      } else {
        throw Exception('Falha ao gerar codigo: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao verificar usuário: $e');
      return false;
    }
  }



 

  // Método para cadastrar um novo usuario
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
      String senhaHash = _hashCode.hashPassword(senha);
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


 // Método para altear
  Future<bool> alterarSenha(String email, String senha, String codigogerado) async {
    try {
      String senhaHash = _hashCode.hashPassword(senha);
      // Enviando os dados para o backend

      ///alterarsenha/{email}/{senha}/{codigogerado}
      final response = await http.get(
        Uri.parse('${global.urlGeral}/usuarios/alterarsenha/$email/$senhaHash/$codigogerado'),
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
      print('Erro ao aterar a senha do usuario: $e');
      return false;
    }
  }








}


