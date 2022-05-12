class BookFields {
  static final List<String> values = [
    id,
    title,
    author,
    pages,
    price,
  ];

  static const id = 'id';
  static const title = 'title';
  static const author = 'author';
  static const pages = 'pages';
  static const price = 'price';
}

class Book {
  final int id;
  final String title;
  final String? author;
  final String? pages;
  final String? price;

  const Book({
    required this.id,
    required this.title,
    this.author,
    this.pages,
    this.price,
  });

  Book copy({
    final int? id,
    final String? title,
    final String? author,
    final String? pages,
    final String? price,
  }) =>
      Book(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        pages: pages ?? this.pages,
        price: price ?? this.price,
      );

  static Book fromJson(Map<String, dynamic> json) => Book(
        id: json[BookFields.id] as int,
        title: json[BookFields.title] as String,
        author: json[BookFields.author] as String,
        pages: json[BookFields.pages] as String,
        price: json[BookFields.price] as String,
      );

  Map<String, Object?> toJson() => {
    BookFields.id: id,
    BookFields.title: title,
    BookFields.author: author,
    BookFields.pages: pages,
    BookFields.price: price,
  };
}
