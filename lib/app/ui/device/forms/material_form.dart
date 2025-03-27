import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  Map<String,String>? _currentPosition;

  Future<void> _captureGeolocation() async {
    setState(() {
      _isLoading = true;
    });
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.high),
        );
        setState(() {
          _currentPosition = {
            "Latitude": "${position.latitude}",
            "Longitude": "${position.longitude}",
            "Altitude": "${position.altitude}"
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.barcodeController,
                decoration:
                    const InputDecoration(labelText: "Código de Barras"),
              ),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "Nome *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: "Descrição *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Descrição é obrigatória';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.dateController,
                decoration: const InputDecoration(labelText: "Data"),
              ),
              TextFormField(
                controller: controller.locationController,
                decoration: const InputDecoration(labelText: "Localização *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Localização é obrigatória';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.observationsController,
                decoration: const InputDecoration(labelText: "Observações *"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Observações são obrigatórias';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _isLoading ? const CircularProgressIndicator() :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Latitude: ${_currentPosition?["Latitude"]}",),
                  Text("Longitude: ${_currentPosition?["Longitude"]}"),
                  Text("Altitude: ${_currentPosition?["Altitude"]}"),
                ],
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
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.saveMaterial(context,geolocationToStr());
                        }
                      },
                      child: const Text("Salvar Material"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
