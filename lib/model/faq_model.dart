class Faq {
  final int id;
  final int catid;
  final String title;
  final String content;

  Faq({
    required this.id,
    required this.catid,
    required this.title,
    required this.content,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      id: json['id'],
      catid: json['catid'],
      title: json['title'] ?? "",
      content: json['content'] ?? "",
    );
  }
}
