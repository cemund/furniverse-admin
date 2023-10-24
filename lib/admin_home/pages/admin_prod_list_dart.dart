import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AdminProdList extends StatefulWidget {
  const AdminProdList({super.key});

  @override
  State<AdminProdList> createState() => _AdminProdListState();
}

class _AdminProdListState extends State<AdminProdList> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      'Action 1',
      'Action 22',
    ];
    String? selectedValue;
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
                              selectedValue ?? "All Products",
                              style: const TextStyle(
                                color: Color(0xFF44444F),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            items: items
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
                            value: selectedValue,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 40,
                              width: 100,
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
                    Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xffF6BE2C)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ))
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
                        items: items
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
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 100,
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
            Expanded(
                child: ListView(
              children: [
                const ProductDetailCard(),
                const ProductDetailCard(),
                const ProductDetailCard(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        '1-10 of 195 items',
                        style: TextStyle(
                          color: Color(0xFF44444F),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 1, color: const Color(0xFFE2E2EA))),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        size: 24,
                        color: Color(0xff92929D),
                      ),
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(width: 1, color: Color(0xFFE2E2EA))),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        size: 24,
                        color: Color(0xff92929D),
                      ),
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class ProductDetailCard extends StatefulWidget {
  const ProductDetailCard({
    super.key,
  });

  @override
  State<ProductDetailCard> createState() => _ProductDetailCardState();
}

class _ProductDetailCardState extends State<ProductDetailCard> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color:
                  isChecked ?? false ? const Color(0xff3DD598) : Colors.white)),
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
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/table.jpeg'),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const Text(
                              "Coffee Table",
                              style: TextStyle(
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
                        const Text(
                          "₱200.00",
                          style: TextStyle(
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "ID",
                              style: TextStyle(
                                color: Color(0xFF686873),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "123456",
                              style: TextStyle(
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
                            Text(
                              "STOCK",
                              style: TextStyle(
                                color: Color(0xFF686873),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "98",
                              style: TextStyle(
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
                            Text(
                              "VAR",
                              style: TextStyle(
                                color: Color(0xFF686873),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "2",
                              style: TextStyle(
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
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: const Icon(
              Icons.more_horiz,
            ),
          )
        ],
      ),
    );
  }
}
