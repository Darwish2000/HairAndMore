class Product {
  String productId;
  double price;
  String productImage;
  String productDescription;

  Product(
      {required this.productId,
      required this.productImage,
      required this.price,
      required this.productDescription});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json["productId"],
      price: 0.0 + json["price"],
      productImage: json["productImage"],
      productDescription: json["productDescription"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "price": price,
      "productImage": productImage,
      "productDescription": productDescription,
    };
  }
}
