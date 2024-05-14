import 'package:json_annotation/json_annotation.dart';

part 'imagempet.g.dart';
@JsonSerializable()
class ImagemPet {
  int id;
  String caminhoImagem;
  String nomeArquivo;
  String tipo;

  ImagemPet({
    required this.id,
    required this.caminhoImagem,
    required this.nomeArquivo,
    required this.tipo,
  });

// Adicione métodos toJson e fromJson se necessário
  // A factory constructor for creating a new Cadastro instance from a map.
  factory ImagemPet.fromJson(Map<String, dynamic> json) => _$ImagemPetFromJson(json);

  // A method for converting a Cadastro instance to a map.
  Map<String, dynamic> toJson() => _$ImagemPetToJson(this);
}