import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/book_storage.dart';
import 'book_detail_screen.dart';
import 'book_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];
  BookStatus? selectedStatus;

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

  String _getStatusText(BookStatus status) {
    switch (status) {
      case BookStatus.onShelf:
        return 'На полке';
      case BookStatus.reading:
        return 'Читаю';
      case BookStatus.read:
        return 'Прочитано';
      case BookStatus.postponed:
        return 'Отложено';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = selectedStatus == null
        ? books
        : books.where((book) => book.status == selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('100 книг в год'),
        actions: [
          DropdownButton<BookStatus?>(
            value: selectedStatus,
            onChanged: (newStatus) {
              setState(() {
                selectedStatus = newStatus;
              });
            },
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Все'),
              ),
              ...BookStatus.values.map(
                    (status) => DropdownMenuItem(
                  value: status,
                  child: Text(_getStatusText(status)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredBooks.length,
        itemBuilder: (context, index) {
          final book = filteredBooks[index];
          return ListTile(
            leading: Image.asset(
              _getStatusIcon(book.status),
              width: 40,
              height: 40,
            ),
            title: Text(book.title),
            subtitle: Text('${book.author} - ${_getStatusText(book.status)}'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookFormScreen(onSave: (newBook) => addBook(newBook)),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
