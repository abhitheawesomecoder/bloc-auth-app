import 'package:bloc_auth_app/db/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/item_model.dart';
import '../../repository/item_repository.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository itemRepository;
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  ItemBloc(this.itemRepository) : super(ItemInitialState()) {
    on<FetchItemsEvent>(_onFetchItems);
    on<AddItemEvent>(_onAddItem);
    on<DeleteItemEvent>(_onDeleteItem);
  }

  Future<void> _onFetchItems(
      FetchItemsEvent event, Emitter<ItemState> emit) async {
    emit(ItemLoadingState());
    try {
      List<ItemModel> items = [];
      const onlineStatus = false;
      if (onlineStatus) {
        items = await itemRepository.fetchItems();
        await databaseHelper.deleteAllItem();
        for (final item in items) {
          await databaseHelper.insertItem(item);
        }
      } else {
        items = await databaseHelper.getItems();
      }

      emit(ItemLoadedState(items));
    } catch (e) {
      emit(ItemErrorState("Failed to load items"));
    }
  }

  Future<void> _onAddItem(AddItemEvent event, Emitter<ItemState> emit) async {
    try {
      await itemRepository.addItem(event.title);
      add(FetchItemsEvent()); // Refresh list after adding item
    } catch (e) {
      emit(ItemErrorState("Failed to add item"));
    }
  }

  Future<void> _onDeleteItem(
      DeleteItemEvent event, Emitter<ItemState> emit) async {
    try {
      await itemRepository.deleteItem(event.itemId);
      add(FetchItemsEvent()); // Refresh list after deleting item
    } catch (e) {
      emit(ItemErrorState("Failed to delete item"));
    }
  }
}
