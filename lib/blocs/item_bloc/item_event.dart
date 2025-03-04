import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Fetch items from Firestore
class FetchItemsEvent extends ItemEvent {}

// Add a new item
class AddItemEvent extends ItemEvent {
  final String title;

  AddItemEvent(this.title);

  @override
  List<Object?> get props => [title];
}

// Delete an item
class DeleteItemEvent extends ItemEvent {
  final String itemId;

  DeleteItemEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}
