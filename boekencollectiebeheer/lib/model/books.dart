class BookFields {
  static final List<String> values = [
    id,
    title,
    author,
    pages,
    price,
    chapters,
    volume,
  ];

  static const id = 'id';
  static const title = 'title';
  static const author = 'author';
  static const pages = 'pages';
  static const price = 'price';
  static const chapters = 'currentChapter';
  static const volume = 'currentVolume';
}

class Book {
  final int id;
  final String title;
  final String? author;
  final int? pages;
  final double? price;
  final int? chapters;
  final int? volume;

  const Book({
    required this.id,
    required this.title,
    this.author,
    this.pages,
    this.price,
    this.chapters,
    this.volume,
  });

  Book copy({
    final int? id,
    final String? title,
    final String? author,
    final int? pages,
    final double? price,
    final int? chapters,
    final int? volume,
  }) =>
      Book(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        pages: pages ?? this.pages,
        price: price ?? this.price,
        chapters: chapters ?? this.chapters,
        volume: volume ?? this.volume,
      );

  static Book fromJson(Map<String, dynamic> json) => Book(
        id: json[BookFields.id] as int,
        title: json[BookFields.title] as String,
        author: json[BookFields.author] as String,
        pages: json[BookFields.pages] as int,
        price: json[BookFields.price] as double,
        chapters: json[BookFields.chapters] as int,
        volume: json[BookFields.volume] as int,
      );

  Map<String, Object?> toJson() => {
        BookFields.id: id,
        BookFields.title: title,
        BookFields.author: author,
        BookFields.pages: pages,
        BookFields.price: price,
        BookFields.chapters: chapters,
        BookFields.volume: volume,
      };
}
