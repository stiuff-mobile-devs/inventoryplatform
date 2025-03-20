import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/data/models/departments_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';

class MaterialsTab extends StatefulWidget {
  const MaterialsTab({super.key});

  @override
  State<MaterialsTab> createState() => _MaterialsTabState();
}

class _MaterialsTabState extends State<MaterialsTab> {
  final List<MaterialModel> _allMaterials = [];
  final DepartmentsModel department = Get.arguments;

  //final OrganizationRepository _organizationRepository = Get.find<OrganizationRepository>();

  @override
  void initState() {
    super.initState();
    //_loadItems();
  }

  /*Future<void> _loadItems() async {
    final items = await _organizationRepository
        .getItemsForOrganization(organization.id);
    setState(() {
      _allItems = items;
    });
  }*/

  Future<void> _onRefresh() async {
    //await _loadItems();
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

  Widget _buildHeader(String organizationName) {
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
          const SizedBox(width: 8),
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
                  organizationName,
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
              Expanded(child: Text("Identificador", style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width:50),
              Expanded(child: Text("Título", style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 40),
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
                    Expanded(child: Text(_allMaterials[index].id)),
                    const SizedBox(width: 50),
                    Expanded(child: Text(_allMaterials[index].title)),
                    const SizedBox(width: 40),
                    const Expanded(child: Text("Data")),
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
}