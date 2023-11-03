import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/productvariants_model.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/widgets/addproductwidget.dart';
import 'package:furniverse_admin/widgets/editproductwidget.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';
import 'package:dotted_border/dotted_border.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listItems.add({
      "imageID": 1,
      "widget": GestureDetector(
        onTap: () {
          final id = const Uuid().v4();
          setState(() {
            listItems.insert(
              0,
              {
                "imageID": id,
                "widget": Stack(children: [
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                          image: CachedNetworkImageProvider(
                            "https://firebasestorage.googleapis.com/v0/b/furniverse-5f170.appspot.com/o/assets%2Fimages%2Flamp.jpeg?alt=media&token=fabdd434-e15c-4b28-9d3e-640b26393950",
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          listItems.removeWhere((element) {
                            return element['imageID'] == id;
                          });
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 18,
                      ),
                    ),
                  ),
                ])
              },
            );
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
    // final products = [Container(), Container(),];

    var fileName = file != null ? basename(file!.path) : "No file is selected";
    _fileController.text = fileName;

    final provider = Provider.of<VariantsProvider>(context);
    final variant = provider.variant;

    // return variant.isEmpty
    //     ? Column(
    //       children: [
    //         Center(
    //             child: Text(
    //               'No todos.',
    //               style: TextStyle(fontSize: 20),
    //             ),
    //           ),

    //           SizedBox(
    //               width: double.infinity,
    //               height: 50,
    //               child: ElevatedButton(
    //                 onPressed:(){showDialog(builder: (context) => const AddProductWidget(), context: context, barrierDismissible: false);},
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: Colors.black,
    //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
    //                 ),
    //                 child: const Text("Add Product",
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 18,
    //                     fontFamily: 'Nunito Sans',
    //                     fontWeight: FontWeight.w600,
    //                     height: 0,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //       ],
    //     )
    //     : ListView.separated(
    //         physics: BouncingScrollPhysics(),
    //         padding: EdgeInsets.all(16),
    //         separatorBuilder: (context, index) => Container(height: 8),
    //         itemCount: variant.length,
    //         itemBuilder: (context, index) {
    //           final variants = variant[index];

    //           return Column(
    //             children: [
    //               Text(variants.productname),
    //               Text(variants.material),
    //               SizedBox(
    //               width: double.infinity,
    //               height: 50,
    //               child: ElevatedButton(
    //                 onPressed:(){showDialog(builder: (context) => const AddProductWidget(), context: context, barrierDismissible: false);},
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: Colors.black,
    //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
    //                 ),
    //                 child: const Text("Add Product",
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 18,
    //                     fontFamily: 'Nunito Sans',
    //                     fontWeight: FontWeight.w600,
    //                     height: 0,
    //                   ),
    //                 ),
    //               ),
    //             ),

    //             ],
    //           );
    //         },
    //       );

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "ADD PRODUCT",
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
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Product Name',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _productnameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Category',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Color',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _materialController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Material',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dimensionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Dimension/Size',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _stocksController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Stocks',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Enter your description',
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
                          separatorBuilder: (context, index) => const SizedBox(
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
                  'Product 3d Model',
                  style: TextStyle(
                    color: Color(0xFF43464B),
                    fontSize: 13,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _fileController,
                  onTap: selectFile,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Upload 3d Model',
                  ),
                ),
                const SizedBox(height: 20),
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
                variant.isEmpty
                    ? const Column(
                        children: [
                          Center(
                            child: Text(
                              'No variants',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),

                          // SizedBox(
                          //     width: double.infinity,
                          //     height: 50,
                          //     child: ElevatedButton(
                          //       onPressed:(){showDialog(builder: (context) => const AddProductWidget(), context: context, barrierDismissible: false);},
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: Colors.black,
                          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          //       ),
                          //       child: const Text("Add Product",
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 18,
                          //           fontFamily: 'Nunito Sans',
                          //           fontWeight: FontWeight.w600,
                          //           height: 0,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                        ],
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (context, index) =>
                            Container(height: 8),
                        itemCount: variant.length,
                        itemBuilder: (context, index) {
                          final variants = variant[index];
                          final indexes = variant.indexOf(variants) + 1;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(indexes.toString()),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            builder: (context) =>
                                                EditProductWidget(
                                                  productVariants: variants,
                                                ),
                                            context: context,
                                            barrierDismissible: false);
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        final provider =
                                            Provider.of<VariantsProvider>(
                                                context,
                                                listen: false);
                                        provider.removeVariant(variants);
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              ),
                              Text(
                                variants.productname,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                variants.material,
                                style:
                                    const TextStyle(fontSize: 20, height: 1.5),
                              )
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
                const SizedBox(
                  height: 10,
                ),
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
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        saveproduct(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        "Save Product",
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
                ),
                // const SizedBox(height: 20),
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
    final product = FirebaseFirestore.instance.collection('products').doc();

    final provider = Provider.of<VariantsProvider>(context, listen: false);
    // provider.saveVariant(product.id);
    provider.getMap();

    // if (file == null) return;
    if (file != null) {
      final fileName = basename(file!.path);
      final objectmodel =
          FirebaseStorage.instance.ref('threedifiles/$fileName');
      uploadTask = objectmodel.putFile(file!);
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print(product.path);

      final json = {
        'productname': _productnameController.text,
        'material': _materialController.text,
        'dimension': _dimensionController.text,
        'price': _priceController.text,
        'objectmodel': urlDownload,
      };
    }

    Map<String, dynamic> productData = {
      'productname': _productnameController.text,
      'material': _materialController.text,
      'dimension': _dimensionController.text,
      'price': _priceController.text,
      'objectmodel': "urlDownload",
      // 'variants': provider.getMap(),
    };

    // Add the product to Firestore
    productService.addProduct(productData, provider.getMap());

    // await product.set(json);

    // DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");

    // await ref.set({
    //   "name": "John",
    //   "age": 18,
    //   "address": {
    //     "line1": "100 Mountain View"
    //   }
    // });
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
              builder: (context) => const AddProductWidget(),
              context: context,
              barrierDismissible: false);
        },
        child: DottedBorder(
          color: foregroundColor,
          radius: const Radius.circular(8),
          borderType: BorderType.RRect,
          child: const Center(
            child: Text(
              "Add Variant",
              style: TextStyle(
                color: foregroundColor,
                fontSize: 16,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
