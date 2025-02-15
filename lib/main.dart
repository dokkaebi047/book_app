import 'package:flutter/material.dart';

import 'dart:convert';

import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'models/book.dart';

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

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/books.json');

    if (file.existsSync()) {

      final data = jsonDecode(file.readAsStringSync()) as List;

      setState(() {

        books = data.map((e) => Book.fromJson(e)).toList();

      });

    }

  }

  Future<void> _saveBooks() async {

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/books.json');

    file.writeAsStringSync(jsonEncode(books.map((e) => e.toJson()).toList()));

  }

  void addBook(Book book) {

    setState(() {

      books.add(book);

    });

    _saveBooks();

  }

  void editBook(int index, Book book) {

    setState(() {

      books[index] = book;

    });

    _saveBooks();

  }

  void deleteBook(int index) {

    setState(() {

      books.removeAt(index);

    });

    _saveBooks();

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