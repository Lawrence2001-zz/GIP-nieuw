class TagsFields {
  static final List<String> values = [
    id,
    tagName,
  ];

  static const id = 'id';
  static const tagName = 'tagName';
}

class Tags {
  final int id;
  final String tagName;
  const Tags({
    required this.id,
    required this.tagName,
  });

 Tags copy({
    final int? id,
    final String? tagName,
  }) =>
     Tags(
        id: id ?? this.id,
        tagName: tagName ?? this.tagName,
      );

  static Tags fromJson(Map<String, dynamic> json) => Tags(
        id: json[TagsFields.id] as int,
        tagName: json[TagsFields.tagName] as String,
      );

  Map<String, Object?> toJson() => {
        TagsFields.id: id,
        TagsFields.tagName: tagName,
      };
}
