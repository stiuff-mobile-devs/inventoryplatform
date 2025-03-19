import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/controllers/panel_controller.dart';
import 'package:inventoryplatform/app/ui/device/tab_dashboard.dart';
import 'package:inventoryplatform/app/ui/device/tab_inventories.dart';
import 'package:inventoryplatform/app/ui/device/tab_materials.dart';
import 'package:inventoryplatform/app/ui/device/theme/base_scaffold.dart';
import 'package:inventoryplatform/app/ui/device/theme/scrollable_bottom_nav_bar.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  late final PanelController _panelController;

  List<Widget> _tabs = [
    const DashboardTab(),
    const InventoriesTab(),
    const MaterialsTab(),
  ];

  @override
  void initState() {
    super.initState();

    _panelController = Get.find<PanelController>();
    _panelController.setCurrentDepartment(Get.arguments);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabs = [
        const DashboardTab(),
        const InventoriesTab(),
        const MaterialsTab(),
      ];
    });

    _panelController.refreshItemsForTab();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GetBuilder<PanelController>(
        builder: (_) {
          return BaseScaffold(
            hideTitle: true,
            showBackButton: true,
            body: Stack(
              children: [
                Obx(
                  () => _tabs[_panelController.selectedTabIndex.value],
                ),
                Obx(
                  () => Align(
                    alignment: Alignment.bottomCenter,
                    child: ScrollableBottomNavigationBar(
                      onTabSelected: (index) {
                        _panelController.selectedTabIndex.value = index;
                      },
                      selectedTabIndex: _panelController.selectedTabIndex.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
