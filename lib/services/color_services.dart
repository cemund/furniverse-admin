import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/color_model.dart';

class ColorService {
  final CollectionReference _colorCollection =
      FirebaseFirestore.instance.collection('colors');

  Future<void> addColor(Map<String, dynamic> colorsData) async {
    try {
      final colorTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      colorsData['timestamp'] =
          colorTimestamp; // Add the timestamp to your data
      colorsData['sales'] = 0;

      DocumentReference productDocRef = await _colorCollection.add(colorsData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> deleteColor(String colorId) async {
    try {
      // delete file in firestorage

      await _colorCollection.doc(colorId).delete();
    } catch (e) {
      print('Error deleting material: $e');
    }
  }

  Stream<DocumentSnapshot<Object?>> editColor(String colorId) {
    // delete file in firestorage
    return _colorCollection.doc(colorId).snapshots();
  }

  Future<void> updateColor(
      Map<String, dynamic> colorData, String colorId) async {
    try {
      final materialTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      colorData['timestamp'] =
          materialTimestamp; // Add the timestamp to your data

      await _colorCollection.doc(colorId).set(colorData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> reducedQuantity(String colorId, double quantity) async {
    try {
      final colors = await _colorCollection.doc(colorId).get();
      if (colors.exists) {
        double currentStocks = (colors.data() as Map)['stocks'].toDouble() ?? 0;

        if (currentStocks >= quantity.ceil()) {
          await _colorCollection
              .doc(colorId)
              .update({'stocks': FieldValue.increment(-quantity.ceil())});
        } else {
          // Handle the case where there are not enough stocks
          print('Not enough stocks available for ColorId: $colorId.');
        }

        await _colorCollection
            .doc(colorId)
            .update({'sales': FieldValue.increment(1)});
      } else {
        print("Color Id: $colorId does not exist.");
      }
    } catch (e) {
      print('Error updating color quantity: $e');
    }
  }

  Future<void> addQuantity(String colorId, double quantity) async {
    try {
      final colors = await _colorCollection.doc(colorId).get();
      if (colors.exists) {
        await _colorCollection
            .doc(colorId)
            .update({'stocks': FieldValue.increment(quantity.ceil())});

        int sales = (colors.data() as Map)['sales'] ?? 0;
        if (sales > 0) {
          await _colorCollection
              .doc(colorId)
              .update({'sales': FieldValue.increment(-1)});
        }
      } else {
        print("Color Id: $colorId does not exist.");
      }

      //TODO: add sales
    } catch (e) {
      print('Error updating color quantity: $e');
    }
  }

  Stream<QuerySnapshot> getAllcolor() {
    return _colorCollection.snapshots();
  }

  // Stream<QuerySnapshot> getProductVariations(String productId) {
  //   return _materialsCollection
  //       .doc(productId)
  //       .collection('variations')
  //       .snapshots();
  // }

  // Query a subcollection
  Stream<List<ColorModel>> streamColor() {
    return _colorCollection.orderBy('color').snapshots().map(
          (event) => event.docs
              .map(
                (e) => ColorModel.fromFirestore(e),
              )
              .toList()
              .cast(),
        );
  }

  Future<List<ColorModel>> getTopColors() async {
    List<ColorModel> listColors = [];
    try {
      final colors =
          await _colorCollection.orderBy("sales", descending: true).get();
      for (var color in colors.docs) {
        final col = ColorModel.fromFirestore(color);
        if (col.sales > 0) listColors.add(col);
      }
    } catch (e) {
      print("Error getting top colors:$e");
    }

    return listColors;
  }
}
