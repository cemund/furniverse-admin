import 'package:flutter/material.dart';
import 'package:furniverse_admin/inventory_pdf_page.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

Future<DateTime?> _showDatePicker({required BuildContext context}) async {
  DateTime? dateTime;
  await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(DateTime.now().year + 1))
      .then((value) {
    if (value != null) {
      dateTime = value;
    }
  });
  return dateTime;
}

showModalReport({required BuildContext context}) {
  int selectedIndex = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, StateSetter setModalState) {
          return Wrap(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0))),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf_rounded),
                            Gap(5),
                            Text(
                              "Generate PDF Reports",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (() {
                                  setModalState(
                                    () {
                                      selectedIndex = 0;
                                    },
                                  );
                                }),
                                child: CategorySelection(
                                  selectedIndex: selectedIndex,
                                  title: "Sales",
                                  index: 0,
                                ),
                              ),
                            ),
                            Gap(20),
                            Expanded(
                              child: GestureDetector(
                                onTap: (() {
                                  setModalState(
                                    () {
                                      selectedIndex = 1;
                                    },
                                  );
                                }),
                                child: CategorySelection(
                                  selectedIndex: selectedIndex,
                                  title: "Inventory",
                                  index: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(20),
                        if (selectedIndex == 0)
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                    onTap: () async {
                                      startDate = await _showDatePicker(
                                              context: context) ??
                                          DateTime.now();
                                      setModalState(
                                        () {},
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.date_range),
                                        Gap(5),
                                        Text(
                                          "From: ${formatter.format(startDate)}",
                                        ),
                                      ],
                                    )),
                              ),
                              // Expanded(
                              //   child: Text(
                              //     "-",
                              //     style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: 16,
                              //       fontFamily: 'Nunito Sans',
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                              Expanded(
                                child: GestureDetector(
                                    onTap: () async {
                                      endDate = await _showDatePicker(
                                              context: context) ??
                                          DateTime.now();
                                      setModalState(
                                        () {},
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.date_range),
                                        Gap(5),
                                        Text(
                                            "To: ${formatter.format(endDate)}"),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        if (selectedIndex == 0) Gap(20),
                        GeneratePDFButton(
                          selectedIndex: selectedIndex,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

class GeneratePDFButton extends StatelessWidget {
  const GeneratePDFButton({
    super.key,
    required this.selectedIndex,
  });
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (selectedIndex == 0) {
            print("Generate Sales");
          } else {
            print("Generate Inventory");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InventoryPDFPreviewPage(year: DateTime.now().year),
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_rounded,
              color: Colors.white,
            ),
            Gap(5),
            Text(
              "Generate",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class CategorySelection extends StatelessWidget {
  const CategorySelection({
    super.key,
    required this.selectedIndex,
    required this.title,
    required this.index,
  });

  final int selectedIndex;
  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: selectedIndex == index ? const Color(0xFFF6BE2C) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: selectedIndex == index ? Colors.white : Colors.black,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
