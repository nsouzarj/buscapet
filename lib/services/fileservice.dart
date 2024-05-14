import 'dart:io';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ServiceImages {
  void uploadMultipleImages(List<File> imageFiles) async {
    Global global=Global();

    // Crie um URI para o endpoint do seu servidor
    var uri = Uri.parse('${global.urlGeral}/pet/uploadimage');

    // Crie um novo objeto MultipartRequest
    var request =  http.MultipartRequest("POST", uri);

    // Iterar sobre a lista de arquivos
    for (var imageFile in imageFiles) {
      // Abra o arquivo de imagem
      var stream =  http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      // Crie um novo arquivo MultipartFile a partir do arquivo de imagem
      var multipartFile =  http.MultipartFile(
          'files', stream, length,
          filename: basename(imageFile.path));

      // Adicione o arquivo à solicitação
      request.files.add(multipartFile);
    }

    // Envie a solicitação ao servidor
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Upload successful");
    } else {
      print("Upload failed");
    }
  }
}