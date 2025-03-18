import 'package:get/get.dart';

class SidebarController extends GetxController {

  var userId = ''.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhotoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /*Future<String?> getProfileImageUrl() {
    return _authService.getProfileImageUrl();
  }*/

  /*Future<String> getName(String uid) async {
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection("users").doc(uid).get();

    if (user.exists) {
      return user["name"];
    } else {
      return "Usuário";
    }
  }

  Future<void> _loadUserInfo() async {
    var user = _authService.currentUser;
    if (user != null) {
      userId.value = user.uid;
      userName.value = user.displayName ?? await getName(user.uid);
      userEmail.value = user.email ?? '';
      userPhotoUrl.value = user.photoURL ?? '';
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }*/
}
