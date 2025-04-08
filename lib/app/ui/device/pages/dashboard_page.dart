import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:inventoryplatform/app/controllers/inventory_controller.dart';
import 'package:inventoryplatform/app/controllers/panel_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/ui/device/theme/chart_status.dart';
import 'package:inventoryplatform/app/ui/device/theme/chart_update.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final PanelController _panelController;
  int _currentCarouselIndex = 0;
  late final String departmentId;
  final InventoryController _inventoryController = Get.find<InventoryController>();
  


  Widget _buildHeader(DepartmentModel department) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 120,
              child: (department.imagePath != null &&
                      department.imagePath!.isNotEmpty)
                  ? Image.file(
                      File(department.imagePath!),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    )
                  : const SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  _buildOrganizationContainer(department.title, department.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationContainer(
      String organizationName, String organizationId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade700,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        organizationName,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCountersGrid() {
    _inventoryController.loadInventories();
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildCard('Inventários', _inventoryController.inventories.length,
              Icons.inventory_rounded, Colors.blueAccent),
          /*_buildCard('Domains', _panelController.domains.length,
              Icons.data_object, Colors.orangeAccent),
          _buildCard('Tags', _panelController.tags.length, Icons.tag,
              Colors.purpleAccent),
          _buildCard('Readers', _panelController.readers.length,
              Icons.device_hub_rounded, Colors.tealAccent),
          _buildCard('Members', _panelController.members.length,
              Icons.groups_rounded, Colors.redAccent),*/
        ],
      ),
    );
  }

  Widget _buildCard(String title, int count, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36.0, color: color),
            const SizedBox(height: 8.0),
            Text(
              count.toString(),
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              title,
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _panelController = Get.find<PanelController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: ListView(
        children: [
          _buildHeader(_panelController.getCurrentDepartment()!),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CarouselSlider(
                  items: [
                    StatusChart(inventories: _inventoryController.inventories.value),
                    UpdateChart(inventories: _inventoryController.inventories.value),
                  ],
                  options: CarouselOptions(
                    height: 350.0,
                    initialPage: 0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentCarouselIndex = index;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    2,
                    (index) => Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentCarouselIndex == index
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildCountersGrid(),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
