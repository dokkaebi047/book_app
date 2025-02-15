import 'package:flutter/material.dart';
import '../models/book.dart';

class BookFormScreen extends StatefulWidget {
  final Book? book;
  final Function(Book) onSave;

  const BookFormScreen({super.key, this.book, required this.onSave});

  @override
  _BookFormScreenState createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _pagesController;
  String _selectedGenre = 'Научная фантастика';
  BookStatus _selectedStatus = BookStatus.onShelf;
  DateTime? _finishedDate;
  int? _rating;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _pagesController = TextEditingController(text: widget.book?.pages.toString() ?? '');
    _selectedGenre = widget.book?.genre ?? 'Научная фантастика';
    _selectedStatus = widget.book?.status ?? BookStatus.onShelf;
    _finishedDate = widget.book?.finishedDate;
    _rating = widget.book?.rating;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      final newBook = Book(
        title: _titleController.text,
        author: _authorController.text,
        genre: _selectedGenre,
        pages: int.parse(_pagesController.text),
        status: _selectedStatus,
        finishedDate: _selectedStatus == BookStatus.read ? _finishedDate : null,
        rating: _selectedStatus == BookStatus.read ? _rating : null,
      );

      widget.onSave(newBook);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book == null ? 'Добавить книгу' : 'Редактировать книгу')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Название книги'),
                validator: (value) => value!.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Автор'),
                validator: (value) => value!.isEmpty ? 'Введите автора' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedGenre,
                items: ['Научная фантастика', 'Роман', 'Детектив', 'Классическая литература', 'История']
                    .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedGenre = value!),
                decoration: const InputDecoration(labelText: 'Жанр'),
              ),
              TextFormField(
                controller: _pagesController,
                decoration: const InputDecoration(labelText: 'Количество страниц'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Введите количество страниц' : null,
              ),
              DropdownButtonFormField<BookStatus>(
                value: _selectedStatus,
                items: BookStatus.values
                    .map((status) => DropdownMenuItem(value: status, child: Text(status.toString().split('.').last)))
                    .toList(),
                onChanged: (value) => setState(() {
                  _selectedStatus = value!;
                  if (_selectedStatus != BookStatus.read) {
                    _finishedDate = null;
                    _rating = null;
                  }
                }),
                decoration: const InputDecoration(labelText: 'Статус'),
              ),
              if (_selectedStatus == BookStatus.read) ...[
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _finishedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _finishedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(_finishedDate == null ? 'Выбрать дату завершения' : 'Дата: ${_finishedDate!.toLocal()}'.split(' ')[0]),
                ),
                DropdownButtonFormField<int>(
                  value: _rating,
                  items: List.generate(5, (index) => index + 1)
                      .map((rating) => DropdownMenuItem(value: rating, child: Text('$rating')))
                      .toList(),
                  onChanged: (value) => setState(() => _rating = value),
                  decoration: const InputDecoration(labelText: 'Оценка'),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBook,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
