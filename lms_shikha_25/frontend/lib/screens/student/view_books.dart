import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';

class ViewBooksScreen extends StatefulWidget {
  const ViewBooksScreen({super.key});

  @override
  State<ViewBooksScreen> createState() => _ViewBooksScreenState();
}

class _ViewBooksScreenState extends State<ViewBooksScreen> {
  List<Book> books = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      final allBooks = await BookService.getAllBooks();
      setState(() {
        books = allBooks;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('All Books')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (books.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('All Books')),
        body: const Center(child: Text('No books available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Books'),
      ),
      body: RefreshIndicator(
        onRefresh: loadBooks,
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            final isAvailable = book.quantity > 0;

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListTile(
                leading: Icon(
                  Icons.book,
                  color: isAvailable ? Colors.blue : Colors.grey,
                ),
                title: Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Author: ${book.author}'),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          isAvailable ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAvailable
                              ? 'Available (${book.quantity} copies)'
                              : 'Out of Stock',
                          style: TextStyle(
                            color: isAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Chip(
                  label: Text('Qty: ${book.quantity}'),
                  backgroundColor: isAvailable ? Colors.green.shade100 : Colors.grey.shade300,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
