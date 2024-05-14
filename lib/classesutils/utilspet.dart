import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Classe utilitária para formatação de datas.
class UtilsPet {
  /// Formata uma data de acordo com o tipo especificado.
  ///
  /// * `dataOriginal`: A data original a ser formatada.
  /// * `tipo`: Define o formato de saída, "US" para formato americano (YYYY-MM-DD) e "BR" para formato brasileiro (DD/MM/YYYY).
  ///
  /// Retorna uma string com a data formatada.
  String formatarData(String dataOriginal, String tipo) {
    String dataFormatada = '';
    if (tipo == 'US') {
      List<String> partes = dataOriginal.split('/');
      // Reorganiza as partes para o formato desejado
      dataFormatada = '${partes[2]}-${partes[1]}-${partes[0]}';
    } else if (tipo == 'BR') {
      DateTime dateTime = DateTime.parse(dataOriginal);
      dataFormatada = DateFormat('dd/MM/yyyy').format(dateTime);
    }
    return dataFormatada;
  }
}

/// Widget que exibe uma mensagem centralizada na tela.
class MensagemCentralizada extends StatelessWidget {
  /// Mensagem a ser exibida.
  final String mensagem;

  /// Construtor da classe.
  ///
  /// * `key`: Chave única para o widget.
  /// * `mensagem`: Mensagem a ser exibida.
  const MensagemCentralizada({Key? key, required this.mensagem}) : super(key: key);

  /// Constrói o widget que exibe a mensagem centralizada na tela.
  ///
  /// * `context`: Contexto do widget.
  ///
  /// Retorna um widget com a mensagem centralizada.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(mensagem, style: TextStyle(fontSize: 16, color: Colors.red)),
        ),
      ),
    );
  }
}

/// Classe para definir variáveis globais.
class Global {
  /// URL base utilizada pela aplicação.
  //String urlGeral='https://laauci-ip-170-238-131-228.tunnelmole.net';
  String urlGeral = "https://znojnv-ip-170-238-131-228.tunnelmole.net";
}

/// Classe para validação de emails.
class ValidaEmail {
  /// Valida se um email é válido.
  ///
  /// * `email`: Email a ser validado.
  ///
  /// Retorna um booleano indicando se o email é válido.
  bool validarEmail(String email) {
    bool recebe = EmailValidator.validate(email);
    return recebe;
  }
}

/// Classe para geração de hashes.
class HashCode {
  /// Gera o hash SHA256 de uma senha.
  ///
  /// * `password`: Senha a ser codificada.
  ///
  /// Retorna uma string contendo o hash SHA256 da senha.
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}