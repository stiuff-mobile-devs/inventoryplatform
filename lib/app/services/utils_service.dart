import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:inventoryplatform/app/ui/device/theme/warning_message.dart';

class UtilsService {
  Future<void> retryWithExponentialBackoff(
      Future<void> Function() action) async {
    const int maxRetries = 5;
    int retryCount = 0;
    int delay = 1000;

    while (retryCount < maxRetries) {
      try {
        await action();
        return;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: delay));
        delay *= 2;
      }
    }
  }

  String formatDate(DateTime? date) {
    return date != null
        ? DateFormat.yMMMMd().format(date)
        : "Data Indisponível";
  }

  String formatDatePortuguese(DateTime? date) {
    return date != null
        ? DateFormat("dd/MM/yyyy").format(date)
        : "Data Indisponível";
  }

  bool emailRegexMatch(String email) {
    final RegExp regex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return regex.hasMatch(email);
  }

  void showUnderDevelopmentNotice(BuildContext context) {
    showWarningDialog(
      context: context,
      title: 'Aviso',
      message: 'Ops! Esta função ainda não está disponível.',
      onConfirm: () {
        Navigator.of(context).pop();
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }

  void showLogoutNotice(BuildContext context, void Function() action) {
    showWarningDialog(
      context: context,
      title: 'Logout',
      message: 'Você deseja mesmo sair desta conta?',
      hasOnConfirm: true,
      onConfirm: () => action(),
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}
