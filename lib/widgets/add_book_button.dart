import 'package:flutter/material.dart';
import '../screens/book_form_screen.dart';
import '../models/book.dart';

class AddBookButton extends StatelessWidget {
  final Function(Book) onBookAdded;

  const AddBookButton({super.key, required this.onBookAdded});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookFormScreen(onSave: onBookAdded),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
