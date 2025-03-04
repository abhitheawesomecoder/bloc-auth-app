class ItemModel {
  final String id;
  final String title;

  ItemModel({required this.id, required this.title});

  // Convert Firestore document to model
  factory ItemModel.fromMap(Map<String, dynamic> map, String id) {
    return ItemModel(
      id: id,
      title: map['title'] ?? '',
    );
  }

  // Convert model to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }
}
