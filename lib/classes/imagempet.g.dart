// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagempet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImagemPet _$ImagemPetFromJson(Map<String, dynamic> json) => ImagemPet(
      id: (json['id'] as num).toInt(),
      caminhoImagem: json['caminhoImagem'] as String,
      nomeArquivo: json['nomeArquivo'] as String,
      tipo: json['tipo'] as String,
    );

Map<String, dynamic> _$ImagemPetToJson(ImagemPet instance) => <String, dynamic>{
      'id': instance.id,
      'caminhoImagem': instance.caminhoImagem,
      'nomeArquivo': instance.nomeArquivo,
      'tipo': instance.tipo,
    };
