import 'package:flutter/material.dart';
import '../../services/book_service.dart';
import '../../models/book.dart';
import '../../utils/custom_Alert_box.dart';

class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({super.key});

  @override
  State<ManageBooksScreen> createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
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
      if (mounted) {
        CustomAlertBox.showError(context, 'Error', e.toString());
        setState(() => loading = false);
      }
    }
  }

  Future<void> handleDelete(String bookId, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Book'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "$title"?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        await BookService.deleteBook(bookId);
        
        // Close loading dialog
        if (mounted) {
          Navigator.pop(context);
        }
        
        if (mounted) {
          CustomAlertBox.showSuccess(
            context,
            'Success',
            'Book "$title" deleted successfully',
          );
          // Reload books list
          await loadBooks();
        }
      } catch (e) {
        // Close loading dialog
        if (mounted) {
          Navigator.pop(context);
        }
        
        if (mounted) {
          String errorMessage = e.toString();
          if (errorMessage.contains('Exception:')) {
            errorMessage = errorMessage.replaceAll('Exception:', '').trim();
          }
          CustomAlertBox.showError(
            context,
            'Delete Failed',
            errorMessage.isEmpty ? 'Failed to delete book. Please try again.' : errorMessage,
          );
        }
      }
    }
  }

  Future<void> handleEdit(Book book) async {
    final titleController = TextEditingController(text: book.title);
    final authorController = TextEditingController(text: book.author);
    final quantityController = TextEditingController(text: book.quantity.toString());

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Book'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      final title = titleController.text.trim();
      final author = authorController.text.trim();
      final qtyText = quantityController.text.trim();

      if (title.isEmpty || author.isEmpty || qtyText.isEmpty) {
        CustomAlertBox.showError(context, 'Error', 'All fields are required');
        return;
      }

      final quantity = int.tryParse(qtyText);
      if (quantity == null || quantity < 0) {
        CustomAlertBox.showError(context, 'Error', 'Quantity must be a valid number');
        return;
      }

      try {
        await BookService.updateBook(
          id: book.id,
          title: title,
          author: author,
          quantity: quantity,
        );
        CustomAlertBox.showSuccess(context, 'Success', 'Book updated successfully');
        loadBooks();
      } catch (e) {
        CustomAlertBox.showError(context, 'Error', e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Manage Books')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (books.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Manage Books')),
        body: const Center(child: Text('No books available')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Books')),
      body: RefreshIndicator(
        onRefresh: loadBooks,
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.book),
                title: Text(book.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Author: ${book.author}'),
                    Text('Quantity: ${book.quantity}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => handleEdit(book),
                      tooltip: 'Edit Book',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => handleDelete(book.id, book.title),
                      tooltip: 'Delete Book',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
