import 'package:flutter/material.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/productvariants_model.dart';
import 'package:provider/provider.dart';

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({super.key});

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {

  final _formKey = GlobalKey<FormState>();
  final _productnameController = TextEditingController();
  final _materialController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Variant"),
      
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
      
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:(){addVariant();},
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
      
            // sampelwidget(
            //   OnChangeTitle
            // )
          ],
        ),
      ),
    );
  }

  addVariant(){
    final isValid = _formKey.currentState?.validate();

    if (!isValid!) {
      return;
    } else {
      final variant = ProductVariants(
        productname: _productnameController.text,
        material: _materialController.text
      );

      final provider = Provider.of<VariantsProvider>(context, listen: false);
      provider.addVariant(variant);

      Navigator.of(context).pop();
  }
}

}