class Note {
  String id;
  String title;
  String content;
  String date;
  String priority; //
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: json['date'],
      priority: json['priority'] ?? "Low",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'priority': priority,
    };
  }
}
