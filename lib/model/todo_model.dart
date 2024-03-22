class ToDoModel {
  String? id;
  String? title;
  String? description;
  DateTime? createdAt;
  String? image;
  String? status;

  ToDoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.image,
    this.status = 'IN_PROGRESS',
  });

  ToDoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        createdAt = DateTime.parse(json['createdAt']),
        image = json['image'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt!.toIso8601String(),
        'image': image,
        'status': status,
      };
}
