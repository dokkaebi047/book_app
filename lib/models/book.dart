import 'dart:convert';

enum BookStatus { onShelf, reading, read, postponed }

class Book {

  String title;

  String author;

  String genre;

  int pages;

  BookStatus status;

  DateTime? finishedDate;

  int? rating;

  Book({

    required this.title,

    required this.author,

    required this.genre,

    required this.pages,

    required this.status,

    this.finishedDate,

    this.rating,

  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(

      title: json['title'],

      author: json['author'],

      genre: json['genre'],

      pages: json['pages'],

      status: BookStatus.values[json['status']],

      finishedDate: json['finishedDate'] != null

          ? DateTime.parse(json['finishedDate'])

          : null,

      rating: json['rating'],

    );
  }

  Map<String, dynamic> toJson() {
    return {

      'title': title,

      'author': author,

      'genre': genre,

      'pages': pages,

      'status': status.index,

      'finishedDate': finishedDate?.toIso8601String(),

      'rating': rating,

    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}