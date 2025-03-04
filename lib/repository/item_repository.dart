import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class ItemRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fetch all items from Firestore
  Future<List<ItemModel>> fetchItems() async {
    try {
      QuerySnapshot snapshot = await firestore.collection("items").get();
      return snapshot.docs
          .map((doc) =>
              ItemModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Error fetching items");
    }
  }

  // Add a new item
  Future<void> addItem(String title) async {
    try {
      await firestore.collection("items").add({'title': title});
    } catch (e) {
      throw Exception("Error adding item");
    }
  }

  // Delete an item
  Future<void> deleteItem(String itemId) async {
    try {
      await firestore.collection("items").doc(itemId).delete();
    } catch (e) {
      throw Exception("Error deleting item");
    }
  }
}
