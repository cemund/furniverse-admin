import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/models/products.dart';
import 'package:furniverse_admin/screens/admin_home/pages/admin_add_product.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class AdminProdList extends StatefulWidget {
  const AdminProdList({super.key});

  @override
  State<AdminProdList> createState() => _AdminProdListState();
}

class _AdminProdListState extends State<AdminProdList> {
  bool value = false;
  final List<String> categories = [
    'All Products',
    'Living Room',
    'Bedroom',
    'Dining Room',
    'Office',
    'Outdoor',
    'Kids\' Furniture',
    'Storage and Organization',
    'Accent Furniture',
  ];
  final List<String> actions = [
    'Delete',
  ];

  String? selectedCategory = 'All Products';
  String? selectedAction;
  int currentPage = 0;
  int itemsPerPage = 10;

  List<Product> highlightedProducts = [];

  void highlightProduct(Product product) {
    setState(() {
      highlightedProducts.add(product);
    });
  }

  void removeHighlight(Product product) {
    setState(() {
      highlightedProducts.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<List<Product>?>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Products List',
                      style: TextStyle(
                        color: Color(0xFF171725),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          "Show: ",
                          style: TextStyle(
                            color: Color(0xFF92929D),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.08,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              selectedCategory ?? "All Products",
                              style: const TextStyle(
                                color: Color(0xFF44444F),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            items: categories
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ))
                                .toList(),
                            value: selectedCategory,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 40,
                              width: 110,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.filter_alt),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const AddProduct();
                          },
                        ));
                      },
                      child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xffF6BE2C)),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xffD0D5DD), width: 1),
                          ),
                          hintText: "Search",
                          hintStyle: const TextStyle(
                            color: Color(0xFF667084),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Action',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: actions
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedAction,
                        onChanged: (String? value) async {
                          if (value == 'Delete') {
                            int i = highlightedProducts.length - 1;
                            while (highlightedProducts.isNotEmpty) {
                              await ProductService()
                                  .deleteProduct(highlightedProducts[i].id);
                              highlightedProducts.removeAt(i);
                              i--;
                            }
                          }
                          setState(() {
                            selectedAction = null;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 110,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            products == null
                ? const Loading()
                : Expanded(child: _createProductList(products)),

            // Expanded(child: _createProductList(products))
          ],
        ),
      ),
    );
  }

  _createProductList(List<Product> products) {
    var finalList = [];

    // filter
    if (selectedCategory == 'All Products') {
      finalList = products;
    } else {
      for (int i = 0; i < products.length; i++) {
        if (products[i].category == selectedCategory) {
          finalList.add(products[i]);
        }
      }
    }

    // pagination
    int start = currentPage * itemsPerPage;
    int end = (currentPage + 1) * itemsPerPage;

    if (end > finalList.length) {
      end = finalList.length;
    }

    if (finalList.isEmpty) {
      return const Center(child: Text("No Products"));
    } else {
      return ListView.builder(
        itemCount: end - start + 1,
        itemBuilder: (context, index) {
          if (index == end - start) {
            return _createPageNavigation(end, start, finalList);
          } else {
            return ProductDetailCard(
              product: finalList[start + index],
              highlight: highlightProduct,
              removeHighlight: removeHighlight,
              highlightedProd: highlightedProducts,
            );
          }
        },
      );
    }
  }

  Padding _createPageNavigation(int end, int start, List<dynamic> finalList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${start + 1} - ${end - start} of ${finalList.length} items',
                  style: const TextStyle(
                    color: Color(0xFF44444F),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (currentPage > 0) {
                    setState(() {
                      currentPage--;
                    });
                  }
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 1, color: const Color(0xFFE2E2EA))),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    size: 24,
                    color: Color(0xff92929D),
                  ),
                ),
              ),
              const SizedBox(
                width: 22,
              ),
              GestureDetector(
                onTap: () {
                  if (end < finalList.length) {
                    setState(() {
                      currentPage++;
                    });
                  }
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 1, color: const Color(0xFFE2E2EA))),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: Color(0xff92929D),
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
        ],
      ),
    );
  }
}

class ProductDetailCard extends StatefulWidget {
  final Product product;
  final Function highlight;
  final Function removeHighlight;
  final List<Product> highlightedProd;

  const ProductDetailCard({
    super.key,
    required this.product,
    required this.highlight,
    required this.removeHighlight,
    required this.highlightedProd,
  });

  @override
  State<ProductDetailCard> createState() => _ProductDetailCardState();
}

class _ProductDetailCardState extends State<ProductDetailCard> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    isChecked = widget.highlightedProd.contains(widget.product);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: isChecked ?? false ? const Color(0xff3DD598) : Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20),
              height: 16,
              width: 16,
              child: Checkbox(
                activeColor: const Color(0xff3DD598),
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value;
                    if (isChecked == true) {
                      widget.highlight(widget.product);
                    } else {
                      widget.removeHighlight(widget.product);
                    }
                  });
                },
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        widget.product.images[0] ??
                                            "http://via.placeholder.com/350x150",
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                color: Color(0xFF171625),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "₱${widget.product.getLeastPrice().toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Color(0xFF171625),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: 0.10,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "ID",
                              style: TextStyle(
                                color: Color(0xFF686873),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 100,
                              child: Text(
                                widget.product.id,
                                style: const TextStyle(
                                  color: Color(0xFF44444F),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: 0.20,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "STOCK",
                              style: TextStyle(
                                color: Color(0xFF686873),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.product.getNumStocks().toString(),
                              style: const TextStyle(
                                color: Color(0xFF44444F),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                                letterSpacing: 0.20,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "VAR",
                              style: TextStyle(
                                color: Color(0xFF686873),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.product.getNumVariants().toString(),
                              style: const TextStyle(
                                color: Color(0xFF44444F),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                                letterSpacing: 0.20,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                ProductService().deleteProduct(widget.product.id);
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            itemBuilder: (context) => [
              // popupmenu item 1
              const PopupMenuItem(
                value: 1,
                // row has two child icon and text.
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: foregroundColor,
                    ),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(color: foregroundColor),
                    )
                  ],
                ),
              ),
              // popupmenu item 2
              const PopupMenuItem(
                value: 2,
                // row has two child icon and text
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: foregroundColor,
                    ),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text("Edit", style: TextStyle(color: foregroundColor))
                  ],
                ),
              ),
            ],
            offset: const Offset(0, 50),
            color: backgroundColor,
            elevation: 3,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.more_horiz,
                color: foregroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
