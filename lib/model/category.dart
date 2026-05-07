
class Category {
  final int id;
  final String name;
  final String image;
  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    image: json["image"] ?? "",
  );
}
