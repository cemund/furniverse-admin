import 'package:flutter/material.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/productvariants_model.dart';
import 'package:provider/provider.dart';

class EditProductWidget extends StatefulWidget {

  final ProductVariants productVariants;

  const EditProductWidget({
    super.key,
    required this.productVariants
  });

  @override
  State<EditProductWidget> createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget> {

  String productname = "";
  String material = "";

  @override
  void initState() {
    productname = widget.productVariants.productname;
    material = widget.productVariants.material;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _productnameController = TextEditingController();
  final _materialController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    _productnameController.text = productname;
    _materialController.text = material;
    
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Edit Variant"),
      
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
                onPressed:(){editVariant();},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                child: const Text("Save",
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
    );
  }

  editVariant(){
    final isValid = _formKey.currentState?.validate();

    if (!isValid!) {
      return;
    } else {
        
        final provider = Provider.of<VariantsProvider>(context, listen: false);
        provider.updateVariant(widget.productVariants, _productnameController.text, _materialController.text);

        Navigator.of(context).pop();
      }
  }
}