import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageController extends GetxController{

  final RxnString _base64String = RxnString();
  final RxString _message = "".obs;
  final RxString _imagePath = "".obs;

  String get message => _message.value;
  String? get base64String => _base64String.value;
  String get imagePath => _imagePath.value;

  Future<void> convertImage(File? imageFile) async {
    const int maxSizeBytes = 500000; // 500KB

    if (imageFile == null) {
      _message.value = "Nenhuma imagem selecionada.";
      return;
    }

    _base64String.value = null;
    _message.value = "Processando sua imagem... Isso pode levar alguns segundos.";

    /*if (!imageFile.path.toLowerCase().endsWith('.jpg') && 
        !imageFile.path.toLowerCase().endsWith('.jpeg')) {
      _message.value = "A imagem deve ser no formato JPG ou JPEG.";
      return;
    }*/

    Uint8List imageBytes = await imageFile.readAsBytes();
    if (imageBytes.lengthInBytes <= maxSizeBytes) {
      _base64String.value = base64Encode(imageBytes);
      _message.value = "Imagem selecionada com sucesso!";
      return;
    }

    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      _message.value = "Erro ao processar a imagem.";
      return;
    }

    Uint8List compressedImage = Uint8List.fromList(img.encodeJpg(image, quality: 10));
    
    if (compressedImage.lengthInBytes > maxSizeBytes) {
      _message.value = "A imagem ainda é muito grande!";
    } else {
      _base64String.value = base64Encode(compressedImage);
      _message.value = "A imagem ultrapassou o limite de 500KB e foi comprimida. Esse processo pode resultar em perda de qualidade na imagem.";
    }
  }


Future<void> saveBase64AsImage(String base64String) async {
  try {
    // Decodifica a string Base64 em bytes
    final bytes = base64Decode(base64String);

    // Obtém o diretório temporário do dispositivo
    final directory = await getTemporaryDirectory();

    // Cria o caminho completo do arquivo
    final filePath = '${directory.path}/converted_image';

    // Cria o arquivo e escreve os bytes nele
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    // Retorna o caminho do arquivo salvo
     _imagePath.value = file.path;
  } catch (e) {
    _message.value = "Erro ao salvar a imagem: $e";
   
  }
}
}
