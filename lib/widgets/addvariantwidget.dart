import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/models/color_model.dart';
import 'package:furniverse_admin/models/materials_model.dart';
import 'package:furniverse_admin/models/product_variants_model.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class AddVariantWidget extends StatefulWidget {
  const AddVariantWidget({super.key, required this.materials});
  final List<Materials> materials;

  @override
  State<AddVariantWidget> createState() => _AddVariantWidgetState();
}

class _AddVariantWidgetState extends State<AddVariantWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _materialController = TextEditingController();
  final _colorController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _priceController = TextEditingController();
  final _stocksController = TextEditingController();

  String? image;
  String? model;
  XFile? selectedImage;
  File? selectedModel;
  final ImagePicker _picker = ImagePicker();
  String error = '';

  final List<String> items = [
    'inch',
    'cm',
    'ft',
    'm',
  ];
  // final List<Map> itemMaterials = [];
  String? selectedCategory;
  String? selectedMaterial;
  String? selectedColor;

  @override
  void initState() {
    super.initState();
    // if (widget.materials.isNotEmpty) {
    //   // selectedMaterial = widget.materials[0].id;
    //   selectedMaterial = widget.materials[0].material;
    // }
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
      // type: FileType.custom,
      // allowedExtensions: ['glb'],
    );
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() => selectedModel = File(path));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _materialController.dispose();
    _colorController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _priceController.dispose();
    _stocksController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<List<ColorModel>?>(context);

    var fileName = selectedModel != null
        ? basename(selectedModel!.path)
        : "Upload 3D Model";
    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(10),
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
              height: 400,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isEmpty
                          ? 'Please input a variant name.'
                          : null),
                  const Gap(20),
                  // TextFormField(
                  //   controller: _colorController,
                  //   decoration: outlineInputBorder(label: 'Color'),
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) =>
                  //       value!.isEmpty ? 'Please input a color.' : null,
                  // ),
                  DropdownButtonFormField2<String>(
                    buttonStyleData: const ButtonStyleData(
                      height: 26,
                      padding: EdgeInsets.only(right: 8),
                    ),
                    hint: const Text(
                      'Select Color',
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: [
                      for (var color in colors ?? [])
                        DropdownMenuItem<String>(
                          value: color.color,
                          child: Row(
                            children: [
                              Icon(
                                Icons.brightness_1,
                                color: hexToColor(color.hexValue),
                              ),
                              Gap(10),
                              Text(
                                color.color,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],
                    isExpanded: true,
                    value: selectedColor,
                    onChanged: (String? value) {
                      setState(() {
                        selectedColor = value;
                      });
                    },
                  ),

                  const Gap(20),
                  // TextFormField(
                  //   controller: _materialController,
                  //   decoration: outlineInputBorder(label: 'Material'),
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) =>
                  //       value!.isEmpty ? 'Please input a material.' : null,
                  // ),
                  DropdownButtonFormField2<String>(
                    buttonStyleData: const ButtonStyleData(
                      height: 26,
                      padding: EdgeInsets.only(right: 8),
                    ),
                    hint: const Text(
                      'Select Material',
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: [
                      for (var material in widget.materials)
                        DropdownMenuItem<String>(
                          value: material.material,
                          child: Text(
                            material.material,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    isExpanded: true,
                    value: selectedMaterial,
                    onChanged: (String? value) {
                      setState(() {
                        selectedMaterial = value;
                      });
                    },
                  ),
                  const Gap(20),
                  DropdownButtonFormField2<String>(
                    buttonStyleData: const ButtonStyleData(
                      height: 26,
                      padding: EdgeInsets.only(right: 8),
                    ),
                    hint: const Text(
                      'Select Metric',
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) =>
                    //     value!.isEmpty ? 'Please select a metric length.' : null,
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
                  Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 100,
                          child: TextFormField(
                            controller: _lengthController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: 'Length',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value!.isEmpty
                                ? 'Please input a length.'
                                : null,
                          )),

                      Padding(
                          padding: EdgeInsets.only(top: 25), child: Text("X")),

                      Container(
                          width: 100,
                          child: TextFormField(
                            controller: _widthController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: 'Width',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value!.isEmpty ? 'Please input a width.' : null,
                          )),

                      Padding(
                          padding: EdgeInsets.only(top: 25), child: Text("X")),

                      Container(
                          width: 100,
                          child: TextFormField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: 'Height',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value!.isEmpty
                                ? 'Please input a height.'
                                : null,
                          )),

                      // Flexible(child: DropdownButtonFormField2<String>(
                      //   buttonStyleData: const ButtonStyleData(
                      //     height: 26,
                      //     padding: EdgeInsets.only(right: 8),
                      //   ),
                      //   hint: const Text(
                      //     'Select Metric Length',
                      //     style: TextStyle(fontSize: 16),
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      //   iconStyleData: const IconStyleData(
                      //     icon: Icon(
                      //       Icons.arrow_drop_down,
                      //     ),
                      //     iconSize: 24,
                      //   ),
                      //   dropdownStyleData: DropdownStyleData(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      //   menuItemStyleData: const MenuItemStyleData(
                      //     padding: EdgeInsets.symmetric(horizontal: 16),
                      //   ),
                      //   decoration: InputDecoration(
                      //     contentPadding:
                      //         const EdgeInsets.symmetric(vertical: 16),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      //   // autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   // validator: (value) =>
                      //   //     value!.isEmpty ? 'Please select a metric length.' : null,
                      //   items: items
                      //       .map((String item) => DropdownMenuItem<String>(
                      //             value: item,
                      //             child: Text(
                      //               item,
                      //               style: const TextStyle(
                      //                 fontSize: 16,
                      //                 // fontWeight: FontWeight.bold,
                      //                 // color: Colors.],
                      //               ),
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //           ))
                      //       .toList(),
                      //   isExpanded: true,
                      //   value: selectedCategory,
                      //   onChanged: (String? value) {
                      //     setState(() {
                      //       selectedCategory = value;
                      //     });
                      //   },
                      // ),)
                    ],
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value!.isEmpty ? 'Please input a price.' : null,
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: _stocksController,
                    decoration: outlineInputBorder(label: 'Stocks'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value!.isEmpty ? 'Please input a stock/s.' : null,
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
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) return;
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationAlertDialog(
                              title:
                                  "Are you sure you want to add this variant?",
                              onTapNo: () {
                                Navigator.pop(context);
                              },
                              onTapYes: () async {
                                // final currentContext = context; // Capture the context outside the async block
                                addVariant(context);
                                Navigator.pop(context);
                              },
                              tapNoString: "No",
                              tapYesString: "Yes"),
                        );
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
                  const Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  addVariant(BuildContext context) {
    final isValid = _formKey.currentState!.validate();
    //   if (!isValid) return;

    final id = const Uuid().v4();
    print(isValid.toString());

    if (validateInputs(isValid)) {
      setState(() {
        error = "Input values are invalid";
      });
      Fluttertoast.showToast(
        msg: "Please complete the information needed.",
        backgroundColor: Colors.grey,
      );
      print("Input values are invalid");
      return;
    } else {
      setState(() {
        error = "";
      });
      final variant = ProductVariants(
        variantName: _nameController.text,
        material: selectedMaterial ?? "",
        color: selectedColor ?? "",
        image: selectedImage!,
        length: double.parse(_lengthController.text),
        width: double.parse(_widthController.text),
        height: double.parse(_heightController.text),
        metric: selectedCategory.toString(),
        model: selectedModel!,
        price: double.parse(_priceController.text),
        stocks: int.parse(_stocksController.text),
        id: id,
      );

      final provider = Provider.of<VariantsProvider>(context, listen: false);
      provider.addVariant(variant);

      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Variant Added Successfully.",
        backgroundColor: Colors.grey,
      );
    }
  }

  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  bool validateInputs(bool isValid) =>
      !isValid ||
      selectedImage == null ||
      selectedModel == null ||
      selectedColor == null ||
      selectedCategory == null ||
      selectedMaterial == null;
}
