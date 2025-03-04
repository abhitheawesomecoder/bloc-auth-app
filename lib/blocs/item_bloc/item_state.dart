import 'package:equatable/equatable.dart';

import '../../models/item_model.dart';

abstract class ItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state
class ItemInitialState extends ItemState {}

// Loading state (e.g., when fetching data)
class ItemLoadingState extends ItemState {}

// Loaded state with a list of items
class ItemLoadedState extends ItemState {
  final List<ItemModel> items;

  ItemLoadedState(this.items);

  @override
  List<Object?> get props => [items];
}

// Error state in case of failure
class ItemErrorState extends ItemState {
  final String message;

  ItemErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
