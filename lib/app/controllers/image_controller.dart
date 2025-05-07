import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ImageController extends GetxController{

  Future<List<String>> convertImagesToBase64(List<File?> imageFiles) async {
    const int maxSizeBytes = 500000; // 500KB
    List<String> base64Strings = [];

    for (File? imageFile in imageFiles) {
      if (imageFile == null) {
        print("Arquivo de imagem nulo.");
        continue;
      }
      Uint8List imageBytes = await imageFile.readAsBytes();
      if (imageBytes.lengthInBytes <= maxSizeBytes) {
        base64Strings.add(base64Encode(imageBytes));   
        continue;
      }

      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        print("Erro ao decodificar a imagem.");
        continue;
      }

      Uint8List compressedImage = Uint8List.fromList(img.encodeJpg(image, quality: 10));
      
      if (compressedImage.lengthInBytes <= maxSizeBytes) {
        base64Strings.add(base64Encode(compressedImage));
        print("A imagem ultrapassou o limite de 500KB e foi comprimida. Esse processo pode resultar em perda de qualidade na imagem.");
      } 
    }
    return base64Strings;

  }

Future<List<String>> convertBase64ToImages(List<String> base64Strings) async {
  List<String> filePaths = [];
  try {
    // Obtém o diretório temporário do dispositivo
    final directory = await getTemporaryDirectory();

    for (int i = 0; i < base64Strings.length; i++) {
      final base64String = base64Strings[i];

      // Decodifica a string Base64 em bytes
      final bytes = base64Decode(base64String);

      // Cria o caminho completo do arquivo com um nome único
final filePath = '${directory.path}/converted_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // Cria o arquivo e escreve os bytes nele
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Adiciona o caminho do arquivo à lista
      filePaths.add(file.path);
    }
  } catch (e) {
    print("Erro ao converter Base64 para imagem: $e");
  }
  return filePaths;
}
}
