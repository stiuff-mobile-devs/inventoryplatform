class DepartmentModel {
  String _id;
  String _title;
  String? _description;
  String? _imagePath;

  List<String>? _memberIds;
  List<String>? _readerIds;
  List<String>? _entityIds;
  List<String>? _tagIds;
  List<String>? _inventoryIds;
  List<String>? _domainIds;

  DepartmentModel({
    required String id,
    required String title,
    String? description,
    String? imagePath,
  })  : _id = id,
        _title = title,
        _description = description,
        _imagePath = imagePath,
        _memberIds = [],
        _readerIds = [],
        _entityIds = [],
        _tagIds = [],
        _inventoryIds = [],
        _domainIds = [];

  String get id => _id;
  String get title => _title;
  String? get description => _description;
  String? get imagePath => _imagePath;

  List<String>? get members => _memberIds;
  List<String>? get readers => _readerIds;
  List<String>? get entities => _entityIds;
  List<String>? get tags => _tagIds;
  List<String>? get inventories => _inventoryIds;
  List<String>? get domains => _domainIds;

  set id(String id) => _id = id;
  set title(String title) => _title = title;
  set description(String? description) => _description = description;
  set imagePath(String? imagePath) => _imagePath = imagePath;

  set members(List<String>? members) => _memberIds = members;
  set readers(List<String>? readers) => _readerIds = readers;
  set entities(List<String>? entities) => _entityIds = entities;
  set tags(List<String>? tags) => _tagIds = tags;
  set inventories(List<String>? inventories) => _inventoryIds = inventories;
  set domains(List<String>? domains) => _domainIds = domains;
}
