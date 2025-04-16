import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../data/models/tag_model.dart';

class TagController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> saveTag(BuildContext context, tag, String type) async {
    try {
      final box = Hive.box<TagModel>('tags');

      // Cria um novo TagModel
      final tagModel = TagModel(
        id: tag,
        type: type,
        date: DateTime.now(),
      );

      // Salva o TagModel na box
      await box.add(tagModel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("TAG adicionado com sucesso!")),
      );
    } catch (e) {
      print('Erro ao salvar a tag: $e');
    }
  }
}
