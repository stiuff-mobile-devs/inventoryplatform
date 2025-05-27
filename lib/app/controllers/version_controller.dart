import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionController extends GetxController {
  late PackageInfo packageInfo;

  String get appName => packageInfo.appName;
  String get packageName => packageInfo.packageName;
  String get version => packageInfo.version;
  String get buildNumber => packageInfo.buildNumber;

  @override
  void onInit() async {
    super.onInit();
    packageInfo = await PackageInfo.fromPlatform();
    update(); // Notifica os listeners que os dados foram carregados
  }
}