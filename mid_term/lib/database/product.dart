class Product {
  String id;
  String name;
  int price;
  String category;
  String img;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.img,
  });

  Map<String, dynamic> toMap() {
     return {
      'id': id,
      'name': name,
      'price': price,
      'image': img,
      'category': category,
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? 'No Name',
      price: data['price'] ?? 0,
      img: data['image'] ?? 'No Image',
      category: data['category'] ?? 'No Category',
    );
  }
}