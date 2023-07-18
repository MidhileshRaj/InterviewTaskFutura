import 'dart:convert';

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  static List<Product> parseProducts(String responseBody) {
    final parsed = jsonDecode(responseBody)['products'].cast<Map<String, dynamic>>();
    return parsed.map<Product>((i) {
      return Product(
        id: i['id'],
        title: i['title'],
        description: i['description'],
        price: i['price'].toDouble(),
        discountPercentage: i['discountPercentage'].toDouble(),
        rating: i['rating'].toDouble(),
        stock: i['stock'],
        brand: i['brand'],
        category: i['category'],
        thumbnail: i['thumbnail'],
        images: List<String>.from(i['images']),
      );
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
    };
  }
}


