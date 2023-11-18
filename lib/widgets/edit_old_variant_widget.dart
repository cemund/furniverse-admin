import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/edit_product_variants_model.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class EditOldVariantWidget extends StatefulWidget {
  final EditProductVariants productVariants;

  const EditOldVariantWidget({super.key, required this.productVariants});

  @override
  State<EditOldVariantWidget> createState() => _EditOldVariantWidgetState();
}

class _EditOldVariantWidgetState extends State<EditOldVariantWidget> {
  String name = "";
  String material = "";
  String color = "";
  String size = "";
  String id = "";
  double price = 0.0;
  int stocks = 0;
  dynamic selectedImage;
  dynamic selectedModel;
  XFile? selectedNewImage;
  File? selectedNewModel;

  @override
  void initState() {
    var variant = widget.productVariants;

    name = variant.variantName;
    material = variant.material;
    color = variant.color;
    size = variant.size;
    price = variant.price;
    stocks = variant.stocks;
    selectedImage = variant.image;
    selectedModel = variant.model;
    id = variant.id;
    selectedNewImage = variant.selectedNewImage;
    selectedNewModel = variant.selectedNewModel;
    super.initState();
  }

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
        selectedNewImage = image;
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

    setState(() => selectedNewModel = File(path));
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = name;
    _materialController.text = material;
    _colorController.text = color;
    _dimensionController.text = size;
    _priceController.text = price.toString();
    _stocksController.text = stocks.toString();
    // var fileName = selectedModel != null
    //     ? basename(selectedModel!.path)
    //     : "Upload 3D Model";
    var fileName = selectedNewModel == null
        ? "$name's 3D Model"
        : basename(selectedNewModel!.path);

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
                const Text("Edit Variant"),
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
                  Center(
                      child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: selectedNewImage == null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    selectedImage ?? imagePlaceholder,
                                  ),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        child: selectedNewImage != null
                            ? Image.file(
                                File(selectedNewImage!.path),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () async {
                            if (selectedNewImage == null) {
                              await pickImage();
                            } else {
                              setState(() {
                                selectedNewImage = null;
                              });
                            }
                          },
                          child: Icon(
                            selectedNewImage == null
                                ? Icons.add_photo_alternate_rounded
                                : Icons.undo_rounded,
                            size: 18,
                            color: foregroundColor,
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
                    // onTap: selectFile,
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
                                  if (selectedNewModel == null) {
                                    selectFile();
                                  } else {
                                    setState(() {
                                      selectedNewModel = null;
                                    });
                                  }
                                },
                                icon: selectedNewModel == null
                                    ? const Icon(
                                        Icons.upload_file_rounded,
                                      )
                                    : const Icon(Icons.undo_rounded),
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
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationAlertDialog(
                            title: "Are you sure you want to save the changes in this variant?",
                            onTapNo: () {
                              Navigator.pop(context);
                            },
                            onTapYes: () async {
                            // final currentContext = context; // Capture the context outside the async block
                              editVariant(context);
                                    
                              Fluttertoast.showToast(
                                msg: "Variant Changed Successfully.",
                                backgroundColor: Colors.grey,
                              );
                              Navigator.pop(context);
                            },
                            tapNoString: "No",
                            tapYesString: "Yes"
                          ),
                        );
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
      final newVariant = EditProductVariants(
        id: widget.productVariants.id,
        variantName: _nameController.text,
        material: _materialController.text,
        color: _colorController.text,
        image: selectedImage!,
        size: _dimensionController.text,
        model: selectedModel!,
        price: double.parse(_priceController.text),
        stocks: int.parse(_stocksController.text),
        selectedNewImage: selectedNewImage,
        selectedNewModel: selectedNewModel,
      );

      final provider = Provider.of<VariantsProvider>(context, listen: false);
      provider.updateOldVariants(widget.productVariants, newVariant);

      Navigator.of(context).pop();
    }
  }
}
