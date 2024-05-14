// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classecadastro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CadastroPet _$CadastroPetFromJson(Map<String, dynamic> json) => CadastroPet(
      id: (json['id'] as num).toInt(),
      nomeAnimal: json['nomeAnimal'] as String,
      tipo: json['tipo'] as String,
      raca: json['raca'] as String,
      idade: json['idade'] as String,
      chipado: json['chipado'] as bool,
      vacinado: json['vacinado'] as bool,
      castrado: json['castrado'] as bool,
      descricao: json['descricao'] as String,
      situacao: json['situacao'] as String,
      datadodesaparecimento: json['datadodesaparecimento'] as String,
      bairro: json['bairro'] as String,
      cidadeEstado: json['cidadeEstado'] as String,
      nomeTutor: json['nomeTutor'] as String,
      email: json['email'] as String,
      celular: json['celular'] as String,
      imagens: (json['imagens'] as List<dynamic>)
          .map((e) => ImagemPet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CadastroPetToJson(CadastroPet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nomeAnimal': instance.nomeAnimal,
      'tipo': instance.tipo,
      'raca': instance.raca,
      'idade': instance.idade,
      'chipado': instance.chipado,
      'vacinado': instance.vacinado,
      'castrado': instance.castrado,
      'descricao': instance.descricao,
      'situacao': instance.situacao,
      'datadodesaparecimento': instance.datadodesaparecimento,
      'bairro': instance.bairro,
      'cidadeEstado': instance.cidadeEstado,
      'nomeTutor': instance.nomeTutor,
      'email': instance.email,
      'celular': instance.celular,
      'imagens': instance.imagens,
    };
