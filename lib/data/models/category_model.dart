class CategoryModel {
  final int? id;
  final String name;
  final String nameAr;
  final String type; // expense | income
  final String color;
  final String icon;
  final bool isCustom;

  final int? parentId;

  CategoryModel({
    this.id,
    required this.name,
    required this.nameAr,
    required this.type,
    this.color = '#102C26',
    this.icon = 'category',
    this.isCustom = false,
    this.parentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'type': type,
      'color': color,
      'icon': icon,
      'is_custom': isCustom ? 1 : 0,
      'parent_id': parentId,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      nameAr: map['name_ar'] ?? map['name'],
      type: map['type'],
      color: map['color'] ?? '#102C26',
      icon: map['icon'] ?? 'category',
      isCustom: (map['is_custom'] ?? 0) == 1,
      parentId: map['parent_id'],
    );
  }
}
