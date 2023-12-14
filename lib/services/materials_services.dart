import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/materials_model.dart';

class MaterialsServices {
  final CollectionReference _materialsCollection =
      FirebaseFirestore.instance.collection('materials');

  Future<void> addMaterials(Map<String, dynamic> materialsData) async {
    try {
      final materialsTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      materialsData['timestamp'] =
          materialsTimestamp; // Add the timestamp to your data
      materialsData['sales'] = 0;

      await _materialsCollection.add(materialsData);
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> deleteMaterial(String materialId) async {
    try {
      // delete file in firestorage

      await _materialsCollection.doc(materialId).delete();
    } catch (e) {
      print('Error deleting material: $e');
    }
  }

  Stream<DocumentSnapshot<Object?>> editMaterial(String materialId) {
    // delete file in firestorage
    return _materialsCollection.doc(materialId).snapshots();
  }

  Future<void> updateMaterial(
      Map<String, dynamic> materialData, String materialId) async {
    try {
      final materialTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      materialData['timestamp'] =
          materialTimestamp; // Add the timestamp to your data

      await _materialsCollection.doc(materialId).set(materialData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> reducedQuantity(String materialId, double quantity) async {
    try {
      final materials = await _materialsCollection.doc(materialId).get();
      if (materials.exists) {
        double currentStocks =
            (materials.data() as Map)['stocks'].toDouble() ?? 0;

        if (currentStocks >= quantity.ceil()) {
          await _materialsCollection
              .doc(materialId)
              .update({'stocks': FieldValue.increment(-quantity.ceil())});
        } else {
          // Handle the case where there are not enough stocks
          print('Not enough stocks available for Material Id: $materialId.');
        }

        await _materialsCollection
            .doc(materialId)
            .update({'sales': FieldValue.increment(1)});
      } else {
        print("Material Id: $materialId does not exist.");
      }
    } catch (e) {
      print('Error updating color quantity: $e');
    }
  }

  Future<void> addQuantity(String materialId, double quantity) async {
    try {
      final materials = await _materialsCollection.doc(materialId).get();
      if (materials.exists) {
        await _materialsCollection
            .doc(materialId)
            .update({'stocks': FieldValue.increment(quantity.ceil())});

        int sales = (materials.data() as Map)['sales'] ?? 0;
        if (sales > 0) {
          await _materialsCollection
              .doc(materialId)
              .update({'sales': FieldValue.increment(-1)});
        }
      } else {
        print("Material Id: $materialId does not exist.");
      }
    } catch (e) {
      print('Error updating color quantity: $e');
    }
  }

  Future<List<Materials>> getTopMaterials() async {
    List<Materials> listMaterials = [];
    try {
      final materials =
          await _materialsCollection.orderBy("sales", descending: true).get();
      for (var material in materials.docs) {
        final mat = Materials.fromFirestore(material);
        if (mat.sales > 0) listMaterials.add(mat);
      }
    } catch (e) {
      print("Error getting top materials");
    }
    return listMaterials;
  }

  Future<List<Materials>> getAllMaterials() async {
    List<Materials> listMaterials = [];
    try {
      final materials =
          await _materialsCollection.orderBy("sales", descending: true).get();
      for (var material in materials.docs) {
        final mat = Materials.fromFirestore(material);
        listMaterials.add(mat);
      }
    } catch (e) {
      print("Error getting all materials");
    }
    return listMaterials;
  }

  Stream<List<Materials>> streamMaterials() {
    return _materialsCollection.orderBy('material').snapshots().map(
          (event) => event.docs
              .map(
                (e) => Materials.fromFirestore(e),
              )
              .toList()
              .cast(),
        );
  }
}
