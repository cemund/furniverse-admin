import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/edit_product_variants_model.dart';
import 'package:furniverse_admin/models/product_variants_model.dart';
import 'package:furniverse_admin/models/products.dart';
import 'package:furniverse_admin/services/delete_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/services/upload_image_services.dart';
import 'package:furniverse_admin/services/upload_model_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/addvariantwidget.dart';
import 'package:furniverse_admin/widgets/edit_old_variant_widget.dart';
import 'package:furniverse_admin/widgets/editvariantwidget.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:readmore/readmore.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, this.id, required this.product});
  final id;
  final Product? product;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  // String id = "";
  // String name = "";
  // String category = "";
  // List<dynamic>? images;
  // String description = "";
  // List<dynamic>? variants;

  final _productnameController = TextEditingController();
  final _materialController = TextEditingController();
  final _dimensionController = TextEditingController();
  final _priceController = TextEditingController();
  final _fileController = TextEditingController();
  final _stocksController = TextEditingController();
  final _colorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  String categoryHintText = "";

  UploadTask? uploadTask;
  File? file;
  // List<ProductVariants> list = [];
  List<Map<String, dynamic>> listItems = [];
  List<String> productImages = [];
  List<dynamic> originalProductImages = [];
  List<dynamic> toDeleteOriginalProductImages = [];

  //image picker
  XFile? selectedImage;
  List<XFile> listSelectedImage = [];
  String? imageUrl;
  bool imageIsUploaded = false;
  final ImagePicker _picker = ImagePicker();
  bool isSaving = false;

  //dropdown
  final List<String> items = [
    'Living Room',
    'Bedroom',
    'Dining Room',
    'Office',
    'Outdoor',
    'Kids\' Furniture',
    'Storage and Organization',
    'Accent Furniture',
  ];
  String? selectedCategory;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
        listSelectedImage.add(image);
      });
    }
  }

  Future<List<String>> uploadSelectedImages() async {
    productImages = [];
    for (int i = 0; i < originalProductImages.length; i++) {
      productImages.add(originalProductImages[i]);
    }
    for (int i = 0; i < listSelectedImage.length; i++) {
      String? downloadUrl = await uploadImageToFirebase(listSelectedImage[i]);
      imageUrl = downloadUrl;
      productImages.add(downloadUrl!);
    }

    if (productImages.isEmpty) {
      return [
        imagePlaceholder,
      ];
    }

    return productImages;
  }

  @override
  void initState() {
    super.initState();

    _productnameController.text = widget.product!.name;
    selectedCategory = widget.product!.category;
    _descriptionController.text = widget.product!.description;

    // put original product images
    originalProductImages = widget.product!.images;

    for (int i = 0; i < originalProductImages.length; i++) {
      final id = const Uuid().v4();

      listItems.insert(0, {
        'id': id,
        'image': originalProductImages[i],
        'widget': Stack(
          children: [
            Container(
              width: 80,
              clipBehavior: Clip.hardEdge,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    originalProductImages[i] ?? imagePlaceholder,
                  ),
                  fit: BoxFit.cover,
                ),
                // image: AssetImage(product.image), fit: BoxFit.cover),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // Use firstWhere to find the map with a specific element
                    Map<String, dynamic>? result = listItems.firstWhere(
                      (map) => map['id'] == id,
                      orElse: () => {},
                    );

                    // Check if the map was found
                    if (result != {}) {
                      if (result['image'] != imagePlaceholder) {
                        toDeleteOriginalProductImages.add(result['image']);
                      }

                      originalProductImages.remove(result['image']);
                      print(originalProductImages);

                      print('Original image found: $result');
                    } else {
                      print('Original image not found');
                    }

                    // remove item in list of map
                    listItems.removeWhere((element) {
                      return element['id'] == id;
                    });
                  });
                },
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: backgroundColor),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: foregroundColor,
                  ),
                ),
              ),
            ),
          ],
        )
      });
    }

    listItems.add({
      // "imageID": 1,
      "widget": GestureDetector(
        onTap: () async {
          final id = const Uuid().v4();
          // final loadingID = const Uuid().v4();
          await pickImage();

          setState(() {
            listItems.insert(0, {
              'id': id,
              'widget': Stack(
                children: [
                  Container(
                    width: 80,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      // border:
                      //     Border.all(width: 2, color: const Color(0xFFA9ADB2)),
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
                          listItems.removeWhere((element) {
                            return element['id'] == id;
                          });
                          listSelectedImage.remove(selectedImage);
                        });
                      },
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: const ShapeDecoration(
                            shape: CircleBorder(), color: backgroundColor),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: foregroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            });
          });
        },
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: const Color(0xFFA9ADB2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    });
  }

  @override
  void dispose() {
    _productnameController.dispose();
    _materialController.dispose();
    _dimensionController.dispose();
    _priceController.dispose();
    _stocksController.dispose();
    _fileController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final products = [Container(), Container(),];

    var fileName = file != null ? basename(file!.path) : "Upload 3D Model";
    _fileController.text = fileName;

    final provider = Provider.of<VariantsProvider>(context);
    final variants = provider.variant;

    return isSaving
        ? const Loading()
        : MultiProvider(
            providers: [
              StreamProvider.value(
                  value: ProductService().editProduct(widget.id),
                  initialData: null)
            ],
            child: SafeArea(
              child: Scaffold(
                backgroundColor: backgroundColor,
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text(
                    "EDIT PRODUCT",
                    // style: TextStyle(color: Colors.black),
                  ),
                  titleTextStyle: const TextStyle(
                    color: Color(0xFF303030),
                    fontSize: 16,
                    fontFamily: 'Avenir Next LT Pro',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                  elevation: 0,
                  backgroundColor: const Color(0xFFF0F0F0),
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _productnameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Product Name',
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField2<String>(
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          hint: Text(
                            selectedCategory!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: items
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          isExpanded: true,
                          value: selectedCategory,
                          onChanged: (String? value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                        const Gap(20),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 3,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: 'Enter Product Description',
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Product Images',
                          style: TextStyle(
                            color: Color(0xFF43464B),
                            fontSize: 13,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listItems.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return listItems[index]['widget'];
                                    // return null;
                                  },
                                  // children: [

                                  // ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Original Product Variants',
                          style: TextStyle(
                            color: Color(0xFF43464B),
                            fontSize: 13,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // show original variants
                        if (widget.product!.variants.isNotEmpty) ...[
                          Builder(builder: (context) {
                            final variants = Provider.of<VariantsProvider>(
                                context,
                                listen: false);

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  Container(height: 8),
                              itemCount: widget.product!.variants.length,
                              itemBuilder: (context, index) {
                                // final variant = widget.product!.variants[index];

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: ShapeDecoration(
                                            image: variants.oldvariants[index]
                                                        .selectedNewImage ==
                                                    null
                                                ? DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            variants
                                                                .oldvariants[
                                                                    index]
                                                                .image),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: variants.oldvariants[index]
                                                      .selectedNewImage !=
                                                  null
                                              ? Image.file(
                                                  File(variants
                                                      .oldvariants[index]
                                                      .selectedNewImage!
                                                      .path),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        const Gap(10),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                variants.oldvariants[index]
                                                    .variantName,
                                                style: const TextStyle(
                                                  color: foregroundColor,
                                                  fontSize: 16,
                                                  fontFamily: 'Nunito Sans',
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Text(
                                                "Prices: ₱${variants.oldvariants[index].price.toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                  color: foregroundColor,
                                                  fontSize: 12,
                                                  fontFamily: 'Nunito Sans',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "Stocks: ${variants.oldvariants[index].stocks}",
                                                style: const TextStyle(
                                                  color: foregroundColor,
                                                  fontSize: 12,
                                                  fontFamily: 'Nunito Sans',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  variants.oldvariants[index]
                                                              .selectedNewModel ==
                                                          null
                                                      ? "3D Model: ${variants.oldvariants[index].variantName} model"
                                                      : "3D Model: ${basename(variants.oldvariants[index].selectedNewModel!.path)}",
                                                  style: const TextStyle(
                                                    color: foregroundColor,
                                                    fontSize: 12,
                                                    fontFamily: 'Nunito Sans',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: ReadMoreText(
                                                  "Size: ${variants.oldvariants[index].size}, Color: ${variants.oldvariants[index].color}, Material: ${variants.oldvariants[index].material} ",
                                                  style: const TextStyle(
                                                    color: foregroundColor,
                                                    fontSize: 12,
                                                    fontFamily: 'Nunito Sans',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  trimLines: 1,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText: 'More',
                                                  trimExpandedText: ' Less',
                                                  moreStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  lessStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            showDialog(
                                                builder: (context) =>
                                                    EditOldVariantWidget(
                                                      productVariants: variants
                                                          .oldvariants[index],
                                                    ),
                                                context: context,
                                                barrierDismissible: false);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: foregroundColor,
                                          ),
                                        ),
                                        // DELETE ORIGINAL VARIANT, FOR DEVELOPMENT
                                        // IconButton(
                                        //   padding: EdgeInsets.zero,
                                        //   constraints: const BoxConstraints(),
                                        //   onPressed: () {
                                        //     final provider =
                                        //         Provider.of<VariantsProvider>(context,
                                        //             listen: false);
                                        //     provider.removeVariant(variant);
                                        //   },
                                        //   icon: const Icon(
                                        //     Icons.delete,
                                        //     color: foregroundColor,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                        ],
                        const Gap(20),
                        const Text(
                          'New Product Variants',
                          style: TextStyle(
                            color: Color(0xFF43464B),
                            fontSize: 13,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        if (variants.isNotEmpty)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                Container(height: 8),
                            itemCount: variants.length,
                            itemBuilder: (context, index) {
                              final variant = variants[index];

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          color: foregroundColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Image.file(
                                          File(variant.image.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const Gap(10),
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              variant.variantName,
                                              style: const TextStyle(
                                                color: foregroundColor,
                                                fontSize: 16,
                                                fontFamily: 'Nunito Sans',
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              "Price: ₱${variant.price.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                color: foregroundColor,
                                                fontSize: 12,
                                                fontFamily: 'Nunito Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              "Stocks: ${variant.stocks}",
                                              style: const TextStyle(
                                                color: foregroundColor,
                                                fontSize: 12,
                                                fontFamily: 'Nunito Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              "3D Model: ${basename(variant.model.path)}",
                                              style: const TextStyle(
                                                color: foregroundColor,
                                                fontSize: 12,
                                                fontFamily: 'Nunito Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              width: 200,
                                              child: ReadMoreText(
                                                "Size: ${variant.size}; Color: ${variant.color}; Material: ${variant.material}; ",
                                                style: const TextStyle(
                                                  color: foregroundColor,
                                                  fontSize: 12,
                                                  fontFamily: 'Nunito Sans',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                trimLines: 1,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: 'More',
                                                trimExpandedText: ' Less',
                                                moreStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                lessStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            showDialog(
                                                builder: (context) =>
                                                    EditVariantWidget(
                                                      productVariants: variant,
                                                    ),
                                                context: context,
                                                barrierDismissible: false);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: foregroundColor,
                                          )),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            final provider =
                                                Provider.of<VariantsProvider>(
                                                    context,
                                                    listen: false);
                                            provider.removeVariant(variant);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: foregroundColor,
                                          ))
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        const Gap(10),
                        const AddVariantButton(),
                        const Gap(20),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isSaving = true;
                              });
                              final currentContext =
                                  context; // Capture the context outside the async block
                              saveproduct(currentContext).then((_) {
                                setState(() {
                                  isSaving =
                                      false; // Set the flag back to false when saving is complete
                                });

                                // Show the "Upload Complete" snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Product Updated'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pop(currentContext);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Update Product",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  //WRITE
  saveproduct(BuildContext context) async {
    ProductService productService = ProductService();

    final provider = Provider.of<VariantsProvider>(context, listen: false);

    final images = await uploadSelectedImages();
    final productMaps = await provider.getMap();
    final toDeleteFiles = provider.getToDeleteFiles();

    Map<String, dynamic> productData = {
      'product_name': _productnameController.text,
      'product_images': images,
      'category': selectedCategory,
      'description': _descriptionController.text,
      'variants': productMaps,
    };

    // Add the product to Firestore
    await productService.updateProduct(productData, widget.id);
    // await productService.addProduct(productData, productMaps);

    for (String file in toDeleteFiles) {
      deleteFileByUrl(file);
    }

    for (var file in toDeleteOriginalProductImages) {
      print("To delete: $file");
      deleteFileByUrl(file);
    }

    // provider.clearVariant();
    // provider.clearOldVariant();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() => file = File(path));
  }
}

class AddVariantButton extends StatelessWidget {
  const AddVariantButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          showDialog(
              builder: (context) => const AddVariantWidget(),
              context: context,
              barrierDismissible: false);
        },
        child: DottedBorder(
          color: foregroundColor,
          radius: const Radius.circular(8),
          borderType: BorderType.RRect,
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: foregroundColor),
                Text(
                  "Add Variant",
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}