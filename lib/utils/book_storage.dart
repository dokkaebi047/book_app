import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class BookStorage {
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/books.json');
  }

  static Future<List<Book>> loadBooks() async {
    final file = await _getFile();
    if (!file.existsSync()) return [];

    final data = jsonDecode(await file.readAsString()) as List;
    return data.map((e) => Book.fromJson(e)).toList();
  }

  static Future<void> saveBooks(List<Book> books) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(books.map((e) => e.toJson()).toList()));
  }
}
