import 'package:get/get.dart';
import 'package:inventoryplatform/app/services/connection_service.dart';

class ConnectionController extends GetxController {
  late ConnectionService _connectionService;
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut<ConnectionService>(() => ConnectionService());
    _connectionService = Get.find<ConnectionService>();
    _connectionService.startMonitoring();
    _connectionService.connectionStatus.listen((status) {
      updateConnectionStatus(status);
    });
  }

  @override
  void onClose() {
    _connectionService.stopMonitoring();
    super.onClose();
  }

  void updateConnectionStatus(bool status) {
    isConnected.value = status;
  }
}
