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
  const MensagemCentralizada({Key? key, required this.mensagem})
      : super(key: key);

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
          child:
              Text(mensagem, style: TextStyle(fontSize: 16, color: Colors.red)),
        ),
      ),
    );
  }
}

/// Classe para definir variáveis globais.
class Global {
  /// URL base utilizada pela aplicação.
  //String urlGeral='https://laauci-ip-170-238-131-228.tunnelmole.net';
  String urlGeral = 'https://bhhody-ip-170-238-131-228.tunnelmole.net';
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

class Teste{
   tteste(){

  }
}


class ListaRacaCaes {
  // Lista de opções para os filtros
  static const List<String> _listaRacas = [
    'AFFENPINSCHER',
    'AFGHAN HOUND',
    'AIREDALE TERRIER',
    'AKITA INU',
    'ALASKAN MALAMUTE',
    'ALABAI',
    'AMERICAN BULLDOG',
    'AMERICAN BULLY',
    'AMERICAN COCKER SPANIEL',
    'AMERICAN ESKIMO DOG',
    'AMERICAN FOXHOUND',
    'AMERICAN PIT BULL TERRIER',
    'AMERICAN STAFFORDSHIRE TERRIER',
    'AMERICAN WATER SPANIEL',
    'ANATOLIAN SHEPHERD DOG',
    'AUSTRALIAN CATTLE DOG',
    'AUSTRALIAN KELPIE',
    'AUSTRALIAN SHEPHERD',
    'AUSTRALIAN TERRIER',
    'BASENJI',
    'BASSET HOUND',
    'BEAGLE',
    'BEARDED COLLIE',
    'BEDLINGTON TERRIER',
    'BELGIAN MALINOIS',
    'BELGIAN SHEEPDOG',
    'BELGIAN TERVUREN',
    'BERNESE MOUNTAIN DOG',
    'BICHON FRISE',
    'BLACK AND TAN COONHOUND',
    'BLACK RUSSIAN TERRIER',
    'BLOODHOUND',
    'BLUE LACY',
    'BORDER COLLIE',
    'BORDER TERRIER',
    'BORZOI',
    'BOSTON TERRIER',
    'BOXER',
    'BOYKIN SPANIEL',
    'BRITTANY',
    'BRUSSELS GRIFFON',
    'BULL TERRIER',
    'BULLDOG',
    'BULLMASTIFF',
    'CAIRN TERRIER',
    'CANAAN DOG',
    'CANE CORSO',
    'CAVALIER KING CHARLES SPANIEL',
    'CHESAPEAKE BAY RETRIEVER',
    'CHIHUAHUA',
    'CHINESE CRESTED',
    'CHOW CHOW',
    'COCKER SPANIEL',
    'COLLIE',
    'COTON DE TULEAR',
    'DACHSHUND',
    'DALMATIAN',
    'DOBERMAN PINSCHER',
    'DOGUE DE BORDEAUX',
    'DOGUE BRASILEIRO',
    'DOGUE ARGENTINO',
    'ENGLISH COCKER SPANIEL',
    'ENGLISH FOXHOUND',
    'ENGLISH SETTER',
    'ENGLISH SPRINGER SPANIEL',
    'ENGLISH TOY SPANIEL',
    'ENTLEBUCHER MOUNTAIN DOG',
    'FIELD SPANIEL',
    'FINNISH LAPPHUND',
    'FINNISH SPITZ',
    'FLAT-COATED RETRIEVER',
    'FRENCH BULLDOG',
    'GERMAN PINSCHER',
    'GERMAN SHEPHERD DOG',
    'GERMAN SHORTHAIRED POINTER',
    'GERMAN WIREHAIRED POINTER',
    'GIANT SCHNAUZER',
    'GOLDEN RETRIEVER',
    'GORDON SETTER',
    'GREAT DANE',
    'GREAT PYRENEES',
    'GREATER SWISS MOUNTAIN DOG',
    'GREYHOUND',
    'HARRIER',
    'HAVANESE',
    'IBIZAN HOUND',
    'ICELANDIC SHEEPDOG',
    'IRISH RED AND WHITE SETTER',
    'IRISH SETTER',
    'IRISH TERRIER',
    'IRISH WOLFHOUND',
    'ITALIAN GREYHOUND',
    'JAPANESE CHIN',
    'KANGAL',
    'KEESHOND',
    'KERRY BLUE TERRIER',
    'KOMONDOR',
    'KUVASZ',
    'LABRADOR RETRIEVER',
    'LAKE LAND TERRIER',
    'LEONBERGER',
    'LHASA APSO',
    'LOWCHEN',
    'MALTESE',
    'MANCHESTER TERRIER',
    'MASTIFF',
    'MINIATURE BULL TERRIER',
    'MINIATURE DACHSHUND',
    'MINIATURE PINSCHER',
    'MINIATURE SCHNAUZER',
    'NEWFOUNDLAND',
    'NORFOLK TERRIER',
    'NORWEGIAN BUHUND',
    'NORWEGIAN ELKHOUND',
    'NORWICH TERRIER',
    'OLD ENGLISH SHEEPDOG',
    'OTTERHOUND',
    'PAPILLON',
    'PARSON RUSSELL TERRIER',
    'PEKINGESE',
    'PEMBROKE WELSH CORGI',
    'PHARAOH HOUND',
    'PIT BULL',
    'PIT MONSTER',
    'PLOTT HOUND',
    'POINTER',
    'POMERANIAN',
    'POODLE',
    'PORTUGUESE WATER DOG',
    'PUG',
    'PULI',
    'PYRENEAN MASTIFF',
    'RAT TERRIER',
    'REDbone COONHOUND',
    'RHODESIAN RIDGEBACK',
    'ROTTWEILER',
    'SAINT BERNARD',
    'SALUKI',
    'SAMOYED',
    'SCHIPPERKE',
    'SCOTTISH DEERHOUND',
    'SCOTTISH TERRIER',
    'SEALYHAM TERRIER',
    'SHETLAND SHEEPDOG',
    'SHIBA INU',
    'SHIH TZU',
    'SIBERIAN HUSKY',
    'SILKY TERRIER',
    'SKYE TERRIER',
    'SMOOTH FOX TERRIER',
    'SOFT COATED WHEATEN TERRIER',
    'SPANISH WATER DOG',
    'SPINONE ITALIANO',
    'STAFFORDSHIRE BULL TERRIER',
    'STANDARD SCHNAUZER',
    'SUSSEX SPANIEL',
    'SWEDISH VALLHUND',
    'TIBETAN MASTIFF',
    'TIBETAN SPANIEL',
    'TIBETAN TERRIER',
    'TOY FOX TERRIER',
    'VIZSLA',
    'VIRA LATA',
    'WEIMARANER',
    'WELSH SPRINGER SPANIEL',
    'WELSH TERRIER',
    'WEST HIGHLAND WHITE TERRIER',
    'WHIPPET',
    'WIRE FOX TERRIER',
    'WIREHAIRED VIZSLA',
    'YORKSHIRE TERRIER'
  ];

  List<String> ListaRaca() {
    return _listaRacas;
  }
}

//Traz lista de estados
class ListaEstados {
  static final List<String> _listaEstados = [
    'ACRE (AC)',
    'ALAGOAS (AL)',
    'AMAPÁ (AP)',
    'AMAZONAS (AM)',
    'BAHIA (BA)',
    'CEARÁ (CE)',
    'DISTRITO FEDERAL (DF)',
    'ESPÍRITO SANTO (ES)',
    'GOIÁS (GO)',
    'MARANHÃO (MA)',
    'MATO GROSSO (MT)',
    'MATO GROSSO DO SUL (MS)',
    'MINAS GERAIS (MG)',
    'PARÁ (PA)',
    'PARAÍBA (PB)',
    'PARANÁ (PR)',
    'PERNAMBUCO (PE)',
    'PIAUÍ (PI)',
    'RIO DE JANEIRO (RJ)',
    'RIO GRANDE DO NORTE (RN)',
    'RIO GRANDE DO SUL (RS)',
    'RONDÔNIA (RO)',
    'RORAIMA (RR)',
    'SANTA CATARINA (SC)',
    'SÃO PAULO (SP)',
    'SERGIPE (SE)',
    'TOCANTINS (TO)'
  ];

  List<String> listaEstados() {
    return _listaEstados;
  }
}

class ListaRacaGatos {
  static final List<String> racadeGatos = [
  'ABISSÍNIO',
  'AMERICAN CURL',
  'AMERICAN SHORTHAIR',
  'AMERICAN WIREHAIR',
  'BALINES',
  'BENGAL',
  'BIRMANÊS',
  'BOBTAIL AMERICANO',
  'BOBTAIL JAPONÊS',
  'BOMBAIM',
  'BRASILEIRO CURL',
  'BRITISH SHORTHAIR',
  'BURMÊS',
  'CHARTREUX',
  'COLORPOINT SHORTHAIR',
  'CORNISH REX',
  'DEVON REX',
  'DON SPHYNX',
  'EUROPEU',
  'EXÓTICO',
  'HIMALAIO',
  'JAVANÊS',
  'KHAO MANEE',
  'KORAT',
  'LAPERM',
  'MAIN COON',
  'MANX',
  'MUNCHKIN',
  'NORUEGUÊS DA FLORESTA',
  'OCICAT',
  'ORIENTAL',
  'PERSA',
  'PELO CURTO BRASILEIRO',
  'RAGAMUFFIN',
  'RAGDOLL',
  'RUSSO AZUL',
  'SAGRADO DA BIRMÂNIA',
  'SCOTTISH FOLD',
  'SELKIRK REX',
  'SIAMES',
  'SIBERIANO',
  'SINGAPURA',
  'SOMALI',
  'SPHYNX',
  'TONQUINÊS',
  'TURCO ANGORÁ',
  'TURCO VAN'
];
  List<String> racadeGatosConhecidas() {
    return racadeGatos;
  }
}



class MyErrorDialog extends StatelessWidget {
  final String message;

  const MyErrorDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Aviso"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha o texto à esquerda
          children: [
            Text(
              message,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Fechar"),
            ),
          ],
        ),
      ),
    );
  }
}
