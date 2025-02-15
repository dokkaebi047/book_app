import 'package:flutter/material.dart';
import '../models/book.dart';
import 'book_form_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  final VoidCallback onDelete;
  final Function(Book) onEdit;

  const BookDetailScreen({
    super.key,
    required this.book,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Автор: ${book.author}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Жанр: ${book.genre}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Страниц: ${book.pages}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Статус: ${book.status.toString().split('.').last}', style: const TextStyle(fontSize: 16)),
            if (book.status == BookStatus.read) ...[
              const SizedBox(height: 10),
              Text('Дата завершения: ${book.finishedDate?.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Оценка: ${book.rating ?? 'Нет'}', style: const TextStyle(fontSize: 16)),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookFormScreen(
                          book: book,
                          onSave: (editedBook) {
                            onEdit(editedBook);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('Редактировать'),
                ),
                ElevatedButton(
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Удалить', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
