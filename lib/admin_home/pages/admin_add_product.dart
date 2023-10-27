import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

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

  // Add widgets variables
  // List<Widget> contatos = [];
  // int _count = 1;
  

  @override
  void dispose() {
    _productnameController.dispose();
    _materialController.dispose();
    _dimensionController.dispose();
    _priceController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Add widget list
    // contatos = List.generate(_count, (int i) => addnewvariant());

    var fileName = file != null ? basename(file!.path) : "No file is selected";
    _fileController.text = fileName;

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

                SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:(){saveproduct();},
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
                    )

                // Add widget BUTTON
                // ElevatedButton(onPressed: _addNewContactRow, child: Text("data")),

                // Add widgets output
                //   Container(
                //   child: Column(
                //     children: [
                //       Text(contatos.indexed.toString()),
                //       Container(
                //         child: Column(
                //           children: contatos,
                //         ),
                //       )
                //     ], 
                //   ),
                // ),  
              ],
            ),
          ),
        ),
      ),
    );
  }


  //WRITE
  saveproduct()async {
    final product = FirebaseFirestore.instance.collection('products');

     if (file == null) return;

    final fileName = basename(file!.path);
    final objectmodel =FirebaseStorage.instance.ref('threedifiles/$fileName');
    uploadTask = objectmodel.putFile(file!);
    final snapshot = await uploadTask!.whenComplete((){});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);
            
    final json = {
      'productname' : _productnameController.text,
      'material' : _materialController.text,
      'dimension' : _dimensionController.text,
      'price' : _priceController.text,
      'objectmodel': urlDownload,
      
    };

    await product.add(json);
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


  // ADD WIDGETS
  // void _addNewContactRow() {
  //   setState(() {
  //     _count = _count + 1;
  //   });
  // }

  // Widget addnewvariant(){
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //        Text(contatos.indexed.toString()),
  //       TextFormField(
  //                   controller: _productnameController,
  //                   decoration: const InputDecoration(
  //                     border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  //                     labelText: 'Product Name',
  //                   ),
  //                 ),

  //       TextFormField(
  //                   controller: _productnameController,
  //                   decoration: const InputDecoration(
  //                     border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  //                     labelText: 'Product Name',
  //                   ),
  //                 ),
  //     ],
  //   );
  // }
}

