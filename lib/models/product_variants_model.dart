class ProductVariants {
  String id;
  String variantName;
  String color;
  String size;
  String material;
  String metric;
  double price;
  int stocks;
  dynamic image;
  dynamic model;

  ProductVariants({
    required this.id,
    required this.variantName,
    required this.material,
    required this.color,
    required this.size,
    required this.metric,
    required this.price,
    required this.stocks,
    required this.image,
    required this.model,
  });
}
