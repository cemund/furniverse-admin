import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/productvariants_model.dart';
import 'package:furniverse_admin/widgets/addproductwidget.dart';
import 'package:furniverse_admin/widgets/editproductwidget.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

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

  UploadTask? uploadTask;
  File? file;
  List<ProductVariants> list = [];
  @override
  void dispose() {
    _productnameController.dispose();
    _materialController.dispose();
    _dimensionController.dispose();
    _priceController.dispose();
    _fileController.dispose();
    
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
        backgroundColor:  const Color(0xFFF0F0F0),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Product Name',
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _materialController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Material',
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _dimensionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Product Dimension/Size',
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Price',
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _fileController,
                  onTap: selectFile,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Upload Variant',
                  ),
                ),

                const SizedBox(height: 20),

                variant.isEmpty
        ? Column(
          children: [
            Center(
                child: Text(
                  'No todos.',
                  style: TextStyle(fontSize: 20),
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
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 8),
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
                      IconButton(onPressed: (){
                        showDialog(builder: (context) => EditProductWidget(productVariants: variants,), context: context, barrierDismissible: false);
                      }, icon: Icon(Icons.edit)),
                      IconButton(onPressed: (){
                        final provider = Provider.of<VariantsProvider>(context, listen: false);
                        provider.removeVariant(variants);
                      }, icon: Icon(Icons.delete))
                      
                      
                    ],
                  ),
                  Text(
                    variants.productname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  
                    Text(
                      variants.material,
                      style: TextStyle(fontSize: 20, height: 1.5),
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

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:(){saveproduct(context);},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                    ),
                    child: const Text("Save Product",
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
                  const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:(){showDialog(builder: (context) => const AddProductWidget(), context: context, barrierDismissible: false);},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                    ),
                    child: const Text("Add Product",
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
              ],
            ),
          ),
        ),
      ),
    );
  }


  //WRITE
  saveproduct(BuildContext context)async {
    final product = FirebaseFirestore.instance.collection('products').doc();

    final provider = Provider.of<VariantsProvider>(context, listen: false);
    provider.saveVariant(product.id);

     if (file == null) return;

    final fileName = basename(file!.path);
    final objectmodel =FirebaseStorage.instance.ref('threedifiles/$fileName');
    uploadTask = objectmodel.putFile(file!);
    final snapshot = await uploadTask!.whenComplete((){});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(product.path);
            
    final json = {
      'productname' : _productnameController.text,
      'material' : _materialController.text,
      'dimension' : _dimensionController.text,
      'price' : _priceController.text,
      'objectmodel': urlDownload,
      
    };

    await product.set(json);

    
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

