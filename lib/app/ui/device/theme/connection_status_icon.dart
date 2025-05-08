import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/connection_controller.dart';

class ConnectionStatusIcon extends StatelessWidget {
  const ConnectionStatusIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // Certifique-se de que o ConnectionController está disponível
    // final ConnectionController controller = Get.find<ConnectionController>();

    return GetX<ConnectionController>(
      builder: (controller) {
        debugPrint(
            'Estado de conexão: ${controller.isConnected.value ? "Conectado" : "Desconectado"}');

        if (!controller.isConnected.value) {
          return const Positioned(
            right: 20,
            child: Icon(
              Icons.signal_cellular_connected_no_internet_4_bar_rounded,
              color: Colors.red,
              size: 24,
            ),
          );
        } else {
          return const Positioned(
            right: 20,
            child: Icon(
              Icons.signal_cellular_4_bar_rounded,
              color: Colors.grey,
              size: 24,
            ),
          );
        }
      },
    );
  }
}
