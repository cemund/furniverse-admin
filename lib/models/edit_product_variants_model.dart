import 'dart:io';

import 'package:image_picker/image_picker.dart';

class EditProductVariants {
  String id;
  String variantName;
  String color;
  String size;
  String material;
  double price;
  int stocks;
  String image;
  String model;
  XFile? selectedNewImage;
  File? selectedNewModel;

  EditProductVariants({
    required this.id,
    required this.variantName,
    required this.material,
    required this.color,
    required this.size,
    required this.price,
    required this.stocks,
    required this.image,
    required this.model,
    this.selectedNewImage,
    this.selectedNewModel,
  });
}
