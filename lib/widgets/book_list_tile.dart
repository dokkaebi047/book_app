import 'package:flutter/material.dart';
import '../models/book.dart';

class BookListTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookListTile({
    super.key,
    required this.book,
    required this.onTap,
  });

  String _getStatusIcon(BookStatus status) {
    switch (status) {
      case BookStatus.onShelf:
        return 'assets/images/on_shelf.png';
      case BookStatus.reading:
        return 'assets/images/reading.png';
      case BookStatus.read:
        return 'assets/images/read.png';
      case BookStatus.postponed:
        return 'assets/images/postponed.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        _getStatusIcon(book.status),
        width: 40,
        height: 40,
      ),
      title: Text(book.title),
      subtitle: Text('${book.author} - ${book.status.toString().split('.').last}'),
      onTap: onTap,
    );
  }
}
