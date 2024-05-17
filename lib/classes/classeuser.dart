import 'dart:convert';

class Usuario {
  final int? id;
  final String nomeUser;
  final String emailUser;
  final String celularUser;
  final String senhaUser;
  final String? endereco; // Adiciona o campo endereco
  final String? cep; // Adiciona o campo cep
  final String? bairro; // Adiciona o campo bairro
  final String? cidade; // Adiciona o campo cidade
  final String? estado; // Adiciona o campo estado

  Usuario({
    this.id,
    required this.nomeUser,
    required this.emailUser,
    required this.celularUser,
    required this.senhaUser,
    this.endereco,
    this.cep,
    this.bairro,
    this.cidade,
    this.estado,
  });

  // Converte o objeto Usuario para um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeUser': nomeUser,
      'emailUser': emailUser,
      'celularUser': celularUser,
      'senhaUser': senhaUser,
      'endereco': endereco,
      'cep': cep,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
    };
  }

  // Cria um objeto Usuario a partir de um mapa JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nomeUser: json['nomeUser'],
      emailUser: json['emailUser'],
      celularUser: json['celularUser'],
      senhaUser: json['senhaUser'],
      endereco: json['endereco'],
      cep: json['cep'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
    );
  }

  // Converte o objeto Usuario para uma string JSON
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Cria um objeto Usuario a partir de uma string JSON
  factory Usuario.fromJsonString(String jsonString) {
    return Usuario.fromJson(jsonDecode(jsonString));
  }
}