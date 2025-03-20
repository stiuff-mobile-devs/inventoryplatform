class MaterialModel {
  String _id;
  String _title;
  String _description;
  String? _barCode;
  DateTime? _createdAt;

  MaterialModel({
    required String id,
    required String title,
    required String description,
    String? barCode,
    DateTime? createdAt,
  })  : _id = id,
        _title = title,
        _description = description,
        _createdAt = createdAt,
        _barCode = barCode;

  String get id => _id;
  String get title => _title;
  String get description => _description;
  DateTime? get createdAt => _createdAt;
  String? get barCode => _barCode;

  set id(String id) => _id = id;
  set title(String title) => _title = id;
  set description(String description) => _description = description;
  set barCode(String? barCode) => _barCode = barCode;
}