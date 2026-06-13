class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      // DummyJSON sometimes returns ints for price/rating, so we parse to double
      price: json['price']?.toDouble() ?? 0.0,
      rating: json['rating']?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'],
    );
  }
}