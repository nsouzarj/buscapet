import 'package:json_annotation/json_annotation.dart';

import 'imagempet.dart';

part 'classecadastro.g.dart';

@JsonSerializable()
class CadastroPet {
  int id;
  String nomeAnimal;
  String tipo;
  String raca;
  String idade;
  bool chipado;
  bool vacinado;
  bool castrado;
  String descricao;
  String situacao;
  String datadodesaparecimento;
  String endereco;
  String bairro;
  String cidade;
  String estado;
  String nomeTutor;
  String email;
  String celular;
  List<ImagemPet> imagens;

  CadastroPet({
    required this.id,
    required this.nomeAnimal,
    required this.tipo,
    required this.raca,
    required this.idade,
    required this.chipado,
    required this.vacinado,
    required this.castrado,
    required this.descricao,
    required this.situacao,
    required this.datadodesaparecimento,
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.nomeTutor,
    required this.email,
    required this.celular,
    required this.imagens,
  });

  // A factory constructor for creating a new Cadastro instance from a map.
  factory CadastroPet.fromJson(Map<String, dynamic> json) =>
      _$CadastroPetFromJson(json);

  // A method for converting a Cadastro instance to a map.
  Map<String, dynamic> toJson() => _$CadastroPetToJson(this);
}
