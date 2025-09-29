class Faq {
  final String title;
  final String content;

  Faq({required this.title, required this.content});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(title: json['title'] ?? "", content: json['content'] ?? "");
  }
}
