import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/book_storage.dart';
import '../widgets/add_book_button.dart';
import 'book_detail_screen.dart';
import 'book_form_screen.dart';
import '../widgets/book_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    books = await BookStorage.loadBooks();
    DateTime oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    books = books.where((book) => book.status != BookStatus.read || (book.finishedDate != null && book.finishedDate!.isAfter(oneYearAgo))).toList();
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
    return Scaffold(
      appBar: AppBar(title: const Text('100 книг в год')),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return BookListTile(
            book: book,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailScreen(
                    book: book,
                    onDelete: () => deleteBook(index),
                    onEdit: (updatedBook) => editBook(index, updatedBook),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: AddBookButton(onBookAdded: addBook),

    );
  }
}
