import 'package:flutter/material.dart';
import '../../services/issue_book_service.dart';

class MyIssuedBooksScreen extends StatefulWidget {
  final String studentId;
  const MyIssuedBooksScreen({super.key, required this.studentId});

  @override
  State<MyIssuedBooksScreen> createState() => _MyIssuedBooksScreenState();
}

class _MyIssuedBooksScreenState extends State<MyIssuedBooksScreen> {
  List<dynamic> issuedBooks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      final books = await IssueBookService.getMyIssuedBooks(widget.studentId);
      setState(() {
        issuedBooks = books;
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

  String formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  Color getStatusColor(bool returned, DateTime? returnDate) {
    if (returned) return Colors.green;
    if (returnDate != null && DateTime.now().isAfter(returnDate)) {
      return Colors.red;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Issued Books')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (issuedBooks.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Issued Books')),
        body: const Center(
          child: Text('No books issued yet'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Issued Books')),
      body: RefreshIndicator(
        onRefresh: loadBooks,
        child: ListView.builder(
          itemCount: issuedBooks.length,
          itemBuilder: (context, index) {
            final issue = issuedBooks[index];
            final book = issue['book'];
            final isReturned = issue['returned'] ?? false;
            final returnDate = issue['returnDate'] != null
                ? DateTime.parse(issue['returnDate'])
                : null;
            final issueDate = issue['issueDate'] != null
                ? DateTime.parse(issue['issueDate'])
                : null;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isReturned ? Colors.grey.shade200 : null,
              child: ListTile(
                leading: Icon(
                  isReturned ? Icons.check_circle : Icons.book,
                  color: getStatusColor(isReturned, returnDate),
                ),
                title: Text(
                  book['title'] ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Author: ${book['author'] ?? 'Unknown'}'),
                    if (issueDate != null)
                      Text('Issued: ${formatDate(issue['issueDate'])}'),
                    if (returnDate != null)
                      Text(
                        'Due: ${formatDate(issue['returnDate'])}',
                        style: TextStyle(
                          color: !isReturned && DateTime.now().isAfter(returnDate)
                              ? Colors.red
                              : null,
                          fontWeight: !isReturned && DateTime.now().isAfter(returnDate)
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    if (isReturned && issue['actualReturnDate'] != null)
                      Text(
                        'Returned: ${formatDate(issue['actualReturnDate'])}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                trailing: isReturned
                    ? const Chip(
                        label: Text('Returned'),
                        backgroundColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.white),
                      )
                    : returnDate != null && DateTime.now().isAfter(returnDate)
                        ? const Chip(
                            label: Text('Overdue'),
                            backgroundColor: Colors.red,
                            labelStyle: TextStyle(color: Colors.white),
                          )
                        : const Chip(
                            label: Text('Active'),
                            backgroundColor: Colors.blue,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
              ),
            );
          },
        ),
      ),
    );
  }
}
