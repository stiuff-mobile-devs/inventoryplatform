// ignore_for_file: use_build_context_synchronously, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/material.dart';

class ImageItem extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onRemove;
  final VoidCallback? onAddImage;

  const ImageItem({
    super.key,
    this.imagePath,
    this.onRemove,
    this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.file(
                File(imagePath!),
                width: MediaQuery.of(context).size.width / 3 - 16,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: -5,
                right: -5,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: onRemove,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width / 3 - 16,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: IconButton(
            onPressed: onAddImage,
            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
            tooltip: 'Adicionar imagem',
          ),
        ),
      );
    }
  }
}
