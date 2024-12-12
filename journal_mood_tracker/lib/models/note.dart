



class Note {
  int? id;
  String title, description;
  DateTime createdAt;
  int moodIndex;
  
  Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.moodIndex
  });



  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt.toString(),
      'moodIndex' : moodIndex
    };
  }
}