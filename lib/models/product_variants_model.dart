import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProductVariants {
  String variantName;
  String color;
  String size;
  String material;
  double price;
  int stocks;
  XFile image;
  File model;

  ProductVariants({
    required this.variantName,
    required this.material,
    required this.color,
    required this.size,
    required this.price,
    required this.stocks,
    required this.image,
    required this.model,
  });
}
