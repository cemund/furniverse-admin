import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/product_variants_model.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class EditProductWidget extends StatefulWidget {
  final ProductVariants productVariants;

  const EditProductWidget({super.key, required this.productVariants});

  @override
  State<EditProductWidget> createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget> {
  String name = "";
  String material = "";
  String color = "";
  String size = "";
  String id = "";
  double price = 0.0;
  int stocks = 0;
  XFile? selectedImage;
  File? selectedModel;

  @override
  void initState() {
    name = widget.productVariants.variantName;
    material = widget.productVariants.material;
    color = widget.productVariants.color;
    size = widget.productVariants.size;
    price = widget.productVariants.price;
    stocks = widget.productVariants.stocks;
    selectedImage = widget.productVariants.image;
    selectedModel = widget.productVariants.model;
    id = widget.productVariants.id;
    super.initState();
  }

  // final _formKey = GlobalKey<FormState>();
  // final _productnameController = TextEditingController();
  // final _materialController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _materialController = TextEditingController();
  final _colorController = TextEditingController();
  final _dimensionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stocksController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String error = '';

  @override
  void dispose() {
    _nameController.dispose();
    _materialController.dispose();
    _colorController.dispose();
    _dimensionController.dispose();
    _priceController.dispose();
    _stocksController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,

      // for GLB files only
      // type: FileType.any,
      // allowedExtensions: ['glb'],
    );
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() => selectedModel = File(path));
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = name;
    _materialController.text = material;
    _colorController.text = color;
    _dimensionController.text = size;
    _priceController.text = price.toString();
    _stocksController.text = stocks.toString();
    var fileName = selectedModel != null
        ? basename(selectedModel!.path)
        : "Upload 3D Model";

    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Add Variant"),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const Gap(20),
            SizedBox(
              height: 250,
              width: double.maxFinite,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  selectedImage == null
                      ? Center(
                          child: GestureDetector(
                            onTap: () async {
                              await pickImage();
                              setState(() {});
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: const Color(0xFFA9ADB2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add_a_photo_rounded,
                                color: foregroundColor,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Stack(
                          children: [
                            Container(
                              width: 80,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.file(
                                File(selectedImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImage = null;
                                  });
                                },
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: backgroundColor,
                                ),
                              ),
                            ),
                          ],
                        )),
                  const Gap(20),
                  TextFormField(
                    controller: _nameController,
                    decoration: outlineInputBorder(label: 'Variant Name'),
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: _colorController,
                    decoration: outlineInputBorder(label: 'Color'),
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: _materialController,
                    decoration: outlineInputBorder(label: 'Material'),
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: _dimensionController,
                    decoration: outlineInputBorder(label: 'Dimension/Size'),
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: _priceController,
                    decoration: outlineInputBorder(label: 'Price'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: _stocksController,
                    decoration: outlineInputBorder(label: 'Stocks'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const Gap(20),
                  GestureDetector(
                    onTap: selectFile,
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 2, color: borderColor)),
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/model.svg'),
                                const Gap(8),
                                Text(
                                  fileName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: foregroundColor,
                                    fontSize: 16,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedModel != null)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 18,
                                constraints: const BoxConstraints(),
                                color: foregroundColor,
                                onPressed: () {
                                  setState(() {
                                    selectedModel = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        editVariant(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // editVariant() {
  //   final isValid = _formKey.currentState?.validate();

  //   if (!isValid!) {
  //     return;
  //   } else {
  //     final provider = Provider.of<VariantsProvider>(context, listen: false);
  //     provider.updateVariant(widget.productVariants,
  //         _productnameController.text, _materialController.text);

  //     Navigator.of(context).pop();
  //   }
  // }
  editVariant(BuildContext context) {
    final isValid = _formKey.currentState?.validate();

    if (!isValid! && selectedImage == null && selectedModel == null) {
      setState(() {
        error = "Input values are invalid";
      });
      print("Input values are invalid");
      return;
    } else {
      setState(() {
        error = "";
      });
      final newVariant = ProductVariants(
          id: widget.productVariants.id,
          variantName: _nameController.text,
          material: _materialController.text,
          color: _colorController.text,
          image: selectedImage!,
          size: _dimensionController.text,
          model: selectedModel!,
          price: double.parse(_priceController.text),
          stocks: int.parse(_stocksController.text));

      final provider = Provider.of<VariantsProvider>(context, listen: false);
      provider.updateVariant(widget.productVariants, newVariant);

      Navigator.of(context).pop();
    }
  }
}
