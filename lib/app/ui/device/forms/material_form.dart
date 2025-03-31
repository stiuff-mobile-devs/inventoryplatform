import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryplatform/app/controllers/material_controller.dart';
import 'package:intl/intl.dart';
import 'package:inventoryplatform/app/ui/device/theme/image_item.dart';
import 'package:permission_handler/permission_handler.dart';

class MaterialForm extends StatefulWidget {
  late final String cod;
  final String? barcode;

  MaterialForm({required this.cod, this.barcode});

  @override
  _MaterialFormState createState() => _MaterialFormState();
}

class _MaterialFormState extends State<MaterialForm> {
  final MaterialController controller = Get.find<MaterialController>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Map<String, String>? _currentPosition;

  Future<void> _captureGeolocation() async {
    setState(() {
      _isLoading = true;
    });
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      try {
// Position position = await Geolocator.getCurrentPosition(
         // locationSettings:
        //  const LocationSettings(accuracy: LocationAccuracy.high),
        //);
        setState(() {
          _currentPosition = {
            "Latitude": "${"-22.12321312"}",
            "Longitude": "${"-64.3232323"}",
            "Altitude": "${"6.323232322322"}"
          };
          _isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter localização: $e')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão de localização não concedida')),
      );
    }
  }

  String geolocationToStr() {
    String? geolocationStr = _currentPosition?.entries.map((e) => "${e.key}: ${e.value}").join(", ");
    return geolocationStr!;
  }

  @override
  void initState() {
    super.initState();
    _captureGeolocation();
    if (widget.barcode != null) {
      controller.barcodeController.text = widget.barcode!;
    }
    controller.dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Criar Novo Material",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Informações do Material",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.barcodeController,
                decoration: InputDecoration(
                  labelText: "Código de Barras",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: "Nome *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.descriptionController,
                decoration: InputDecoration(
                  labelText: "Descrição *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Descrição é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.dateController,
                decoration: InputDecoration(
                  labelText: "Data",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.locationController,
                decoration: InputDecoration(
                  labelText: "Localização *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Localização é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.observationsController,
                decoration: InputDecoration(
                  labelText: "Observações *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Observações são obrigatórias';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Latitude: ${_currentPosition?["Latitude"] ?? "N/A"}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Longitude: ${_currentPosition?["Longitude"] ?? "N/A"}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Altitude: ${_currentPosition?["Altitude"] ?? "N/A"}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: GetBuilder<MaterialController>(
                  builder: (controller) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ImageItem(
                          imagePath: index < controller.images.length
                              ? controller.images[index]
                              : null,
                          onRemove: index < controller.images.length
                              ? () {
                                  controller.images.removeAt(index);
                                  controller.update();
                                }
                              : null,
                          onAddImage: index >= controller.images.length
                              ? () => controller.addImage(context)
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.saveMaterial(context, geolocationToStr());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Salvar Material",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
