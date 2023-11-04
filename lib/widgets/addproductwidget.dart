import 'package:flutter/material.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/product_variants_model.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({super.key});

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _materialController = TextEditingController();
  final _colorController = TextEditingController();
  final _dimensionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stocksController = TextEditingController();
  String? image;
  String? model;

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {},
                    icon: const Icon(Icons.close))
              ],
            ),
            const Gap(20),

            SizedBox(
              height: 100,
              width: double.maxFinite,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      labelText: 'Variant Name',
                    ),
                  ),
                ],
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
              decoration: outlineInputBorder(label: 'Material'),
            ),

            const Gap(20),

            TextFormField(
              controller: _priceController,
              decoration: outlineInputBorder(label: 'Price'),
            ),

            const Gap(20),

            TextFormField(
              controller: _stocksController,
              decoration: outlineInputBorder(label: 'Stocks'),
            ),

            const Gap(20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // addVariant();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text(
                  "Add Variant",
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

  // addVariant() {
  //   final isValid = _formKey.currentState?.validate();

  //   if (!isValid!) {
  //     return;
  //   } else {
  //     final variant = ProductVariants(
  //         variantName: _productnameController.text,
  //         material: _materialController.text);

  //     final provider = Provider.of<VariantsProvider>(context, listen: false);
  //     provider.addVariant(variant);

  //     Navigator.of(context).pop();
  //   }
  // }
}
