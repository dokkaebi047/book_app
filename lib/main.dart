import 'package:flutter/material.dart';
import 'models/book.dart';
import 'utils/book_storage.dart';

void main() {
  runApp(const BookTrackerApp());
}

class BookTrackerApp extends StatefulWidget {
  const BookTrackerApp({super.key});

  @override
  _BookTrackerAppState createState() => _BookTrackerAppState();
}

class _BookTrackerAppState extends State<BookTrackerApp> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    books = await BookStorage.loadBooks();
    setState(() {});
  }

  void addBook(Book book) {
    setState(() {
      books.add(book);
    });
    BookStorage.saveBooks(books);
  }

  void editBook(int index, Book book) {
    setState(() {
      books[index] = book;
    });
    BookStorage.saveBooks(books);
  }

  void deleteBook(int index) {
    setState(() {
      books.removeAt(index);
    });
    BookStorage.saveBooks(books);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text('100 книг в год')),
        body: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return ListTile(
              title: Text(book.title),
              subtitle: Text('${book.author} - ${book.status}'),
              onTap: () {},
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
