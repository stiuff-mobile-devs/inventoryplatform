import 'package:flutter/material.dart';

void mostrarUsuariosDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Usuários'),
      content: const Text('Aqui é o conteúdo do pop-up "Usuários".'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    ),
  );
}
