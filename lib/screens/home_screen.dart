import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/item_bloc/item_bloc.dart';
import '../blocs/item_bloc/item_event.dart';
import '../blocs/item_bloc/item_state.dart';
import '../models/user_model.dart';
import '../repository/item_repository.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel? user;

  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ItemBloc(ItemRepository())..add(FetchItemsEvent()),
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Home"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
            body: BlocBuilder<ItemBloc, ItemState>(
              builder: (context, state) {
                if (state is ItemLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ItemLoadedState) {
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(item.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            BlocProvider.of<ItemBloc>(context)
                                .add(DeleteItemEvent(item.id));
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No items found"));
                }
              },
            ),
            floatingActionButton:
                BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
              return FloatingActionButton(
                onPressed: () => _showAddItemDialog(context),
                child: const Icon(Icons.add),
              );
            })));
  }

  void _showAddItemDialog(BuildContext blocContext) {
    TextEditingController itemController = TextEditingController();
    showDialog(
      context: blocContext,
      builder: (context) => AlertDialog(
        title: const Text("Add Item"),
        content: TextField(
            controller: itemController,
            decoration: const InputDecoration(hintText: "Enter item")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (itemController.text.isNotEmpty) {
                BlocProvider.of<ItemBloc>(blocContext)
                    .add(AddItemEvent(itemController.text));
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
