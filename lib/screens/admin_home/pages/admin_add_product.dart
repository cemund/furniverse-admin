import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/product_variants_model.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/services/upload_image_services.dart';
import 'package:furniverse_admin/services/upload_model_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/addvariantwidget.dart';
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

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _productnameController = TextEditingController();
  final _materialController = TextEditingController();
  final _dimensionController = TextEditingController();
  final _priceController = TextEditingController();
  final _fileController = TextEditingController();
  final _stocksController = TextEditingController();
  final _colorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  UploadTask? uploadTask;
  File? file;
  List<ProductVariants> list = [];
  List<Map<String, dynamic>> listItems = [];
  List<String> productImages = [];

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
    List<String> images = [];
    for (int i = 0; i < listSelectedImage.length; i++) {
      String? downloadUrl = await uploadImageToFirebase(listSelectedImage[i]);
      imageUrl = downloadUrl;
      images.add(downloadUrl!);
    }
    // listSelectedImage.forEach((element) async {
    //   String? downloadUrl = await uploadImageToFirebase(element);
    //   if (downloadUrl != null) {
    //     // Store the downloadUrl in your database or use it as needed.
    //     // You can display the uploaded image using this URL.
    //     imageUrl = downloadUrl;
    //     images.add(downloadUrl);
    //     print(downloadUrl);
    //   } else {
    //     // Handle upload failure.
    //   }
    // });
    // print("images");
    // print(images);
    return images;
    // if (selectedImage != null) {
    //   String? downloadUrl = await uploadImageToFirebase(selectedImage);
    //   if (downloadUrl != null) {
    //     // Store the downloadUrl in your database or use it as needed.
    //     // You can display the uploaded image using this URL.
    //     imageUrl = downloadUrl;
    //     imageIsUploaded = true;
    //   } else {
    //     // Handle upload failure.
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();

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
      )
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
    var fileName = file != null ? basename(file!.path) : "Upload 3D Model";
    _fileController.text = fileName;

    final provider = Provider.of<VariantsProvider>(context);
    final variants = provider.variant;

    return isSaving
        ? const Loading()
        : SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  "ADD PRODUCT",
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
                        hint: const Text(
                          'Select Product Category',
                          style: TextStyle(fontSize: 16),
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
                                      // fontWeight: FontWeight.bold,
                                      // color: Colors.],
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

                      // DONT DELETE for backup
                      // const SizedBox(height: 20),
                      // TextFormField(
                      //   controller: _categoryController,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(8))),
                      //     labelText: 'Category',
                      //   ),
                      // ),
                      const Gap(20),
                      // TextFormField(
                      //   controller: _colorController,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(8))),
                      //     labelText: 'Color',
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      // TextFormField(
                      //   controller: _materialController,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(8))),
                      //     labelText: 'Material',
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      // TextFormField(
                      //   controller: _dimensionController,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(8))),
                      //     labelText: 'Dimension/Size',
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      // TextFormField(
                      //   controller: _priceController,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(8))),
                      //     labelText: 'Price',
                      //   ),
                      //   keyboardType: const TextInputType.numberWithOptions(
                      //     signed: false,
                      //     decimal: true,
                      //   ),
                      //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      // ),
                      // const SizedBox(height: 20),
                      // TextFormField(
                      //   controller: _stocksController,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(8))),
                      //     labelText: 'Stocks',
                      //   ),
                      //   keyboardType: const TextInputType.numberWithOptions(
                      //     signed: false,
                      //     decimal: true,
                      //   ),
                      //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      // ),
                      // const SizedBox(height: 20),
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
                      // const Text(
                      //   'Product 3d Model',
                      //   style: TextStyle(
                      //     color: Color(0xFF43464B),
                      //     fontSize: 13,
                      //     fontFamily: 'Nunito Sans',
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      // const SizedBox(height: 10),
                      // TextFormField(
                      //   controller: _fileController,
                      //   onTap: selectFile,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(8))),
                      //     labelText: 'Upload 3d Model',
                      //   ),
                      // ),
                      // const Gap(10),
                      // GestureDetector(
                      //   onTap: selectFile,
                      //   child: Container(
                      //     height: 60,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8),
                      //         border: Border.all(width: 2, color: borderColor)),
                      //     child: Stack(
                      //       children: [
                      //         Center(
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               SvgPicture.asset('assets/icons/model.svg'),
                      //               const Gap(8),
                      //               Text(
                      //                 fileName,
                      //                 textAlign: TextAlign.center,
                      //                 style: const TextStyle(
                      //                   color: foregroundColor,
                      //                   fontSize: 16,
                      //                   fontFamily: 'Nunito Sans',
                      //                   fontWeight: FontWeight.w600,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         if (file != null)
                      //           Positioned(
                      //             top: 5,
                      //             right: 5,
                      //             child: IconButton(
                      //               padding: EdgeInsets.zero,
                      //               iconSize: 18,
                      //               constraints: const BoxConstraints(),
                      //               color: foregroundColor,
                      //               onPressed: () {
                      //                 setState(() {
                      //                   file = null;
                      //                 });
                      //               },
                      //               icon: const Icon(
                      //                 Icons.close,
                      //               ),
                      //             ),
                      //           ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      const Text(
                        'Product Variants',
                        style: TextStyle(
                          color: Color(0xFF43464B),
                          fontSize: 13,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: foregroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.file(
                                        File(variant.image.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Gap(10),
                                    Column(
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
                                                fontWeight: FontWeight.bold),
                                            lessStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
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
                            // Column(
                            //   children: [
                            //     Text(variants.productname),
                            //     Text(variants.material),
                            //   //   SizedBox(
                            //   //   width: double.infinity,
                            //   //   height: 50,
                            //   //   child: ElevatedButton(
                            //   //     onPressed:(){showDialog(builder: (context) => const AddProductWidget(), context: context, barrierDismissible: false);},
                            //   //     style: ElevatedButton.styleFrom(
                            //   //       backgroundColor: Colors.black,
                            //   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            //   //     ),
                            //   //     child: const Text("Add Product",
                            //   //       style: TextStyle(
                            //   //         color: Colors.white,
                            //   //         fontSize: 18,
                            //   //         fontFamily: 'Nunito Sans',
                            //   //         fontWeight: FontWeight.w600,
                            //   //         height: 0,
                            //   //       ),
                            //   //     ),
                            //   //   ),
                            //   // ),

                            //   ],
                            // );
                          },
                        ),
                      const Gap(10),
                      const AddVariantButton(),
                      // SizedBox(
                      //   width: double.infinity,
                      //   height: 60,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       showDialog(
                      //           builder: (context) => const AddProductWidget(),
                      //           context: context,
                      //           barrierDismissible: false);
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.black,
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(8))),
                      //     child: const Text(
                      //       "Add Variant",
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 18,
                      //         fontFamily: 'Nunito Sans',
                      //         fontWeight: FontWeight.w600,
                      //         height: 0,
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
                              // setState(() {
                              //   isSaving =
                              //       false; // Set the flag back to false when saving is complete
                              // });

                              // Show the "Upload Complete" snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product Saved'),
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
                            "Save Product",
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
          );
  }

  //WRITE
  saveproduct(BuildContext context) async {
    ProductService productService = ProductService();
    // final product = FirebaseFirestore.instance.collection('products').doc();

    final provider = Provider.of<VariantsProvider>(context, listen: false);
    // provider.saveVariant(product.id);
    // provider.getMap();

    final images = await uploadSelectedImages();
    // final model = await uploadModelToFirebase(file);
    final productMaps = await provider.getMap();

    Map<String, dynamic> productData = {
      'product_name': _productnameController.text,
      // 'material': _materialController.text,
      // 'dimension': _dimensionController.text,
      // 'price': _priceController.text,
      // 'product 3D model': model,
      'product_images': images,
      'category': selectedCategory,
      'description': _descriptionController.text,
      'variants': productMaps,
    };

    // Add the product to Firestore
    await productService.addProduct(productData);
    // await productService.addProduct(productData, productMaps);

    provider.clearVariant();
    // for insurance
    provider.clearOldVariant();

    // if (file == null) return;
    // if (file != null) {
    //   final fileName = basename(file!.path);
    //   final objectmodel =
    //       FirebaseStorage.instance.ref('threedifiles/$fileName');
    //   uploadTask = objectmodel.putFile(file!);
    //   final snapshot = await uploadTask!.whenComplete(() {});
    //   final urlDownload = await snapshot.ref.getDownloadURL();
    //   print(product.path);

    //   final json = {
    //     'productname': _productnameController.text,
    //     'material': _materialController.text,
    //     'dimension': _dimensionController.text,
    //     'price': _priceController.text,
    //     'objectmodel': urlDownload,
    //   };
    // }
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
