import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/data/models/item_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';
import '../../../../../core/services/utils_service.dart';

class MaterialsTab extends StatefulWidget {
  const MaterialsTab({super.key});

  @override
  State<MaterialsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  List<ItemModel> _allItems = [];
  final OrganizationModel organization = Get.arguments;
  final _utilsService = UtilsService();

  final OrganizationRepository _organizationRepository =
  Get.find<OrganizationRepository>();

  final Map<String, bool> _groupExpansionState = {};

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _organizationRepository
        .getItemsForOrganization(organization.id);
    setState(() {
      _allItems = items;
    });
  }

  Future<void> _onRefresh() async {
    await _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(organization.title),
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
    return const Padding(
      padding: const EdgeInsets.only(
      left: 20,
      top: 20,
      right: 20,
      bottom: 20,
    ),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row (
            children: [
              Expanded(child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text("Descrição", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text("Adicionado", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
           SizedBox(height: 8),
           Divider(),
        ],
      )
    );
  }
}