class Todo {
  final int id;
  final String name;
  final String imagePath;
  final String createdAt;

  Todo({
    required this.id,
    required this.name,
    required this.createdAt,
    this.imagePath = '',
  });

  Todo copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? imagePath,
  }) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'Todo{'
        'id: $id, '
        'name: $name, '
        'imagePath: $imagePath, '
        'createdAt: $createdAt}';
  }
}
