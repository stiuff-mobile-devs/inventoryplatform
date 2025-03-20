import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/ui/device/theme/inventory_form.dart';
import 'package:inventoryplatform/app/ui/device/theme/base_scaffold.dart';

class InventoryFormPage extends StatefulWidget {
  const InventoryFormPage({super.key});

  @override
  InventoryFormState createState() => InventoryFormState();
}

class InventoryFormState extends State<InventoryFormPage> {
  final InventoryController controller = Get.put(InventoryController());
  GlobalKey<InventoryFormState> inventoryFormKey = GlobalKey<InventoryFormState>();

  String getHeaderPrefix(int activeMode) {
    const modeLabels = {
      0: 'Adicionando',
      1: 'Visualizando',
      2: 'Editando',
    };
    return modeLabels[activeMode] ?? 'Unavailable';
  }

  @override
  void initState() {
    super.initState();
    /*if (Get.arguments.length > 1 && Get.arguments[1] != null) {
      controller.initialData = Get.arguments[1];
    }
    if (controller.initialData != null) controller.activeMode = 1.obs;*/
  }

  void _cancelForm() {
    controller.activeMode.value = 1;
    formKeys() => inventoryFormKey = GlobalKey<InventoryFormState>();
    formKeys.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BaseScaffold(
        hideTitle: true,
        showBackButton: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildOrganizationBadge(),
                const SizedBox(height: 20),
                Obx(() => _buildForm()),
                Obx(() => _buildActionButtons()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          '${getHeaderPrefix(controller.activeMode.value)} '
          'Inventário',
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade700,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        controller.currentDepartment.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildForm() {
    formMap() => InventoryForm(
            key: inventoryFormKey,
            initialData: controller.initialData,
            isFormReadOnly: controller.activeMode.value == 1,
          );

    return formMap.call();
  }

  Widget _buildActionButtons() {
    if (controller.activeMode.value == 0 || controller.activeMode.value == 2) {
      return _buildEditModeButtons();
    } else {
      return _buildViewModeButtons();
    }
  }

  Widget _buildEditModeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (controller.activeMode.value == 2)
          TextButton(
            onPressed: _cancelForm,
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(width: 16.0),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildSaveButton() {
    return TextButton(
      onPressed: () => _submitForm(),
      style: _buttonStyle(Colors.blue),
      child: const Row(
        children: [
          Icon(Icons.save_rounded),
          SizedBox(width: 8.0),
          Text('Salvar'),
        ],
      ),
    );
  }

  Widget _buildViewModeButtons() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildEditButton(),
          const SizedBox(height: 16.0),
          //_buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return TextButton(
      onPressed: () => controller.activeMode.value = 2,
      style: _buttonStyle(Colors.orange.withOpacity(0.8)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit),
          SizedBox(width: 8.0),
          Text('Editar'),
        ],
      ),
    );
  }

  /*Widget _buildDeleteButton() {
    return TextButton(
      onPressed: () => controller.deleteItem(),
      style: _buttonStyle(Colors.red),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_forever),
          const SizedBox(width: 8.0),
          Text(
            'Deletar ${controller.utilsService.tabNameToSingular(controller.tabType)}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }*/

  ButtonStyle _buttonStyle(Color color) {
    return ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      backgroundColor: WidgetStateProperty.all(color),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  void _submitForm() {
    controller.submitForm(inventoryFormKey);
  }
}
