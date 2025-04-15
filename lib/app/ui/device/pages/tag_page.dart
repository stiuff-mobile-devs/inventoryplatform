import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/data/models/tag_model.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/ui/device/theme/temporary_message_display.dart';

class TagPage extends StatefulWidget {
  const TagPage({super.key});

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  final DepartmentModel department = Get.arguments;
  List<TagModel> _allTags = [];

  @override
  void initState() {
    super.initState();
    _loadTags(); // Carrega as tags (simulação)
  }

  Future<void> _onRefresh() async {
    await _loadTags();
  }

  Future<void> _loadTags() async {
    // Simulação de carregamento de tags
    setState(() {
      //_allTags =  // Substituir por lógica real
    });
  }

    String formatDatePortuguese(DateTime? date) {
    return date != null
        ? DateFormat("dd/MM/yyyy").format(date)
        : "Data Indisponível";
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
         // _buildInventoryOption(),
          _allTags.isNotEmpty ? _buildItemList() :
          const TemporaryMessageDisplay(
            message: "Não há itens para serem listados.",
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tags',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(Routes.TAG_FORM);
                },
                icon: const Icon(Icons.label),
                label: const Text('Adicionar Tag'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text("ID",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text("Tipo",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text("Adicionado",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(
              color: Colors.black, thickness: 1, indent: 1, endIndent: 1),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _allTags.length,
            itemBuilder: (context, index) {
              return InkWell (
                onTap: () {
                  print("TAG SELECIONADA");
                },
                child: Row(children: [
                  const SizedBox(height: 30),
                  Expanded(flex: 2, child: Text(_allTags[index].id)),
                  Expanded(child: Text(_allTags[index].type)),
                  Expanded(
                      child:
                      Text(formatDatePortuguese(_allTags[index].date))),
                ])
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 1,
                endIndent: 1,
              );
            },
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
  /*Widget _buildInventoryOption() {
    return Padding(
        padding: const EdgeInsets.symmetric(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              color: Colors.deepPurple,
              onPressed: print("oi"), //_backInventoryOption,
              icon: const Icon(Icons.arrow_back)),
          const SizedBox(width: 20),
          Text(_handleInventoryTitle()),
          const SizedBox(width: 20),
          IconButton(
              color: Colors.deepPurple,
              onPressed: _forwardInventoryOption,
              icon: const Icon(Icons.arrow_forward))
        ]));
  }*/

  
}