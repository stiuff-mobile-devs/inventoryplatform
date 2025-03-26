import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventoryplatform/app/controllers/material_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';

class MaterialPage extends StatefulWidget {
  const MaterialPage({super.key});

  @override
  State<MaterialPage> createState() => _MaterialPageState();
}

class _MaterialPageState extends State<MaterialPage> {
  final DepartmentModel department = Get.arguments;
  final MaterialController controller = MaterialController();
  List<MaterialModel> _allMaterials = [];
  List<InventoryModel> _allInventories = [];

  //final OrganizationRepository _organizationRepository = Get.find<OrganizationRepository>();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _loadInventories();
  }

  Future<void> _loadItems() async {
    //final items = controller.getMaterialsByInventory("b95d651b-9e02-4674-98d5-49a3dd5add47");
    List<> items = controller.getMaterials();
    final items = allItems.where((item) => item.departmentId == department.id).toList();
    setState(() {
      _allMaterials = items;
    });
  }

  Future<void> _loadInventories() async {
    final inventories = controller.getInventories();
    setState(() {
      _allInventories = inventories;
      for (var i in _allInventories) {
        print(i.title);
      }

    });
  }

  Future<void> _onRefresh() async {
    await _loadItems();
    await _loadInventories();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(department.title),
          _buildItemList(),
        ],
      ),
    );
  }

  Widget _buildHeader(String departmentName) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 20.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Relatório de Materiais',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade700,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  departmentName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemList() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
      child:
      Column (
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row (
            children: [
              Expanded(flex: 2, child: Text("Código de Barras", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text("Título", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text("Adicionado", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(color: Colors.black, thickness: 1, indent: 1, endIndent: 1),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _allMaterials.length,
            itemBuilder: (context, index) {
              return Row (
                  children: [
                    Expanded(flex: 2, child: Text(_allMaterials[index].barcode)),
                    Expanded(child: Text(_allMaterials[index].name)),
                    Expanded(child: Text(formatDatePortuguese(_allMaterials[index].date))),
                  ]
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(color: Colors.grey, thickness: 1, indent: 1, endIndent: 1,);
            },
          )
        ],
      ),
    );
  }

  String formatDatePortuguese(DateTime? date) {
    return date != null
        ? DateFormat("dd/MM/yyyy").format(date)
        : "Data Indisponível";
  }
}