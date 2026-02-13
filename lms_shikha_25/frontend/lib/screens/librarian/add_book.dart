import 'package:flutter/material.dart';
import '../../services/book_service.dart';
import '../../utils/custom_Alert_box.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  bool loading = false;

  void handleAddBook() async {
    final title = titleController.text.trim();
    final author = authorController.text.trim();
    final qtyText = quantityController.text.trim();

    // 🔐 VALIDATION
    if (title.isEmpty || author.isEmpty || qtyText.isEmpty) {
      CustomAlertBox.showError(
        context,
        'Error',
        'All fields are required',
      );
      return;
    }

    final int? quantity = int.tryParse(qtyText);
    if (quantity == null || quantity <= 0) {
      CustomAlertBox.showError(
        context,
        'Error',
        'Quantity must be a valid number',
      );
      return;
    }

    setState(() => loading = true);

    try {
      // ✅ FIX: NAMED PARAMETERS
      await BookService.addBook(
        title: title,
        author: author,
        quantity: quantity,
      );

      if (mounted) {
        // Show success alert
        CustomAlertBox.showSuccess(
          context,
          'Success',
          'Book "$title" added successfully',
        );

        // Wait a moment for the alert to be visible, then navigate to dashboard
        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          // Navigate to librarian dashboard
          Navigator.pushReplacementNamed(context, '/librarian_dashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();
        if (errorMessage.contains('Exception:')) {
          errorMessage = errorMessage.replaceAll('Exception:', '').trim();
        }
        CustomAlertBox.showError(
          context,
          'Error',
          errorMessage.isEmpty ? 'Failed to add book. Please try again.' : errorMessage,
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            const Spacer(),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: handleAddBook,
                    child: const Text('Add Book'),
                  ),
          ],
        ),
      ),
    );
  }
}
