import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:inventoryplatform/app/ui/device/theme/temporary_message_display.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:inventoryplatform/app/controllers/material_controller.dart';
import 'package:inventoryplatform/app/data/models/department_model.dart';
import 'package:inventoryplatform/app/data/models/inventory_model.dart';
import 'package:inventoryplatform/app/data/models/material_model.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:share_plus/share_plus.dart';

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

  int _inventoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _loadInventories();
  }

  Future<void> _onRefresh() async {
    await _loadItems();
    await _loadInventories();
  }

  Future<void> _loadItems() async {
    List<MaterialModel> items;
    if (_inventoryIndex == 0) {
      items = controller.getMaterials();
    } else {
      items = controller
          .getMaterialsByInventory(_allInventories[_inventoryIndex - 1].id);
    }

    setState(() {
      _allMaterials = items;
    });
  }

  Future<void> _loadInventories() async {
    final inventories = controller.getInventories();
    setState(() {
      _allInventories = inventories;
    });
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
          _buildInventoryOption(),
          _allMaterials.isNotEmpty
              ? _buildItemList()
              : const TemporaryMessageDisplay(
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
                'Relatório de Materiais',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(Routes.ALT_CAMERA, arguments: _allInventories[0]);
                },
                icon: const Icon(Icons.search),
                label: const Text('Buscar Material'),
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
                  child: Text("Código de Barras",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text("Título",
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
            itemCount: _allMaterials.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    expandMaterialDetails(_allMaterials[index]);
                  },
                  child: Row(children: [
                    const SizedBox(height: 30),
                    Expanded(flex: 2, child: Text(_allMaterials[index].tag!)),
                    Expanded(child: Text(_allMaterials[index].name)),
                    Expanded(
                        child: Text(formatDatePortuguese(
                            _allMaterials[index].createdAt))),
                  ]));
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
          Center(
              child: ElevatedButton(
            onPressed: openDialog,
            child: const Text("Gerar PDF"),
          ))
        ],
      ),
    );
  }

  Future<void> savePdf() async {
    /*PermissionStatus status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      return;
    }*/

    final pdf = generatePdf();
    final Uint8List pdfData = await pdf.save();
    String? directory = await FilePicker.platform.getDirectoryPath();

    if (directory != null) {
      final filePath = p.join(directory, "relatório.pdf");
      final file = File(filePath);
      await file.writeAsBytes(pdfData);
    }
  }

  Future<void> sharePdf() async {
    final pdf = generatePdf();
    final Uint8List pdfData = await pdf.save();

    final temp = await getTemporaryDirectory();
    final filePath = "${temp.path}/relatorio.pdf";
    final file = File(filePath);
    await file.writeAsBytes(pdfData);

    await Share.shareXFiles([XFile(filePath)]);
  }

  pw.Document generatePdf() {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Wrap(children: [
            pw.Column(
              children: [
                pw.Center(child: pw.Text("RELATÓRIO DE MATERIAIS")),
                _inventoryIndex != 0
                    ? pw.Center(
                        child:
                            pw.Text(_allInventories[_inventoryIndex - 1].title))
                    : pw.Center(child: pw.Text("")),
                pw.SizedBox(height: 20.0),
                pw.Row(
                  children: [
                    pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          "Código de Barras",
                        )),
                    pw.Expanded(
                        child: pw.Text(
                      "Título",
                    )),
                    pw.Expanded(
                        child: pw.Text(
                      "Adicionado",
                    )),
                  ],
                ),
                pw.Divider(thickness: 1, indent: 1, endIndent: 1),
                pw.ListView.builder(
                  itemCount: _allMaterials.length,
                  itemBuilder: (context, index) {
                    return pw.Row(children: [
                      pw.Expanded(
                          flex: 2, child: pw.Text(_allMaterials[index].tag!)),
                      pw.Expanded(child: pw.Text(_allMaterials[index].name)),
                      pw.Expanded(
                          child: pw.Text(formatDatePortuguese(
                              _allMaterials[index].createdAt))),
                    ]);
                  },
                )
              ],
            ),
          ]);
        },
      ),
    );

    return pdf;
  }

  Widget _buildInventoryOption() {
    return Padding(
        padding: const EdgeInsets.symmetric(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              color: Colors.deepPurple,
              onPressed: _backInventoryOption,
              icon: const Icon(Icons.arrow_back)),
          const SizedBox(width: 20),
          Text(_handleInventoryTitle()),
          const SizedBox(width: 20),
          IconButton(
              color: Colors.deepPurple,
              onPressed: _forwardInventoryOption,
              icon: const Icon(Icons.arrow_forward))
        ]));
  }

  void _backInventoryOption() {
    final length = _allInventories.length;
    if (_inventoryIndex == 0) {
      if (length > 0) {
        setState(() {
          _inventoryIndex = length;
        });
      }
    } else {
      setState(() {
        _inventoryIndex--;
      });
    }
    _onRefresh();
  }

  void _forwardInventoryOption() {
    final length = _allInventories.length;
    if (_inventoryIndex == length) {
      setState(() {
        _inventoryIndex = 0;
      });
    } else {
      setState(() {
        _inventoryIndex++;
      });
    }
    _onRefresh();
  }

  String _handleInventoryTitle() {
    if (_inventoryIndex == 0) {
      return "Todos";
    }
    return _allInventories[_inventoryIndex - 1].title;
  }

  String formatDatePortuguese(DateTime? date) {
    return date != null
        ? DateFormat("dd/MM/yyyy").format(date)
        : "Data Indisponível";
  }

  Future<void> expandMaterialDetails(MaterialModel material) async {
    if (material.id.isEmpty || material.tag == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Material inválido ou não encontrado.')),
      );
      return;
    }

    await controller.navigateToMaterialDetails(context, material);
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("O que fazer com o PDF?"),
        actions: [
          Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 40),
                ),
                onPressed: () async {
                  await savePdf();

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Relatório salvo com sucesso.')),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Salvar"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 40),
                ),
                onPressed: () {
                  sharePdf();
                },
                child: const Text("Compartilhar"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 40),
                ),
                onPressed: () {},
                child: const Text("Salvar no Google Drive"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fechar"),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
