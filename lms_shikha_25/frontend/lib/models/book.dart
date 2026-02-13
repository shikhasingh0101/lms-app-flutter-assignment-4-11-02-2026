class Book {
  final String id;
  final String title;
  final String author;
  final int quantity;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.quantity,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'quantity': quantity,
    };
  }
}
