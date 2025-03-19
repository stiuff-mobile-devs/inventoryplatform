class MaterialModel {
  String _id;
  String _description;
  String? _barCode;
  DateTime? _createdAt;

  MaterialModel({
    required String id,
    required String description,
    String? barCode,
    DateTime? createdAt,
  })  : _id = id,
        _description = description,
        _createdAt = createdAt,
        _barCode = barCode;

  String get id => _id;
  String get description => _description;
  DateTime? get createdAt => _createdAt;
  String? get barCode => _barCode;

  set id(String id) => _id = id;
  set description(String description) => _description = description;
  set barCode(String? barCode) => _barCode = barCode;
}