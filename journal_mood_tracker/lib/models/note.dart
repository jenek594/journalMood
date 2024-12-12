

import 'package:flutter/foundation.dart';

class Note {
  int? id;
  String title, description;
  DateTime createdAt;
  int moodIndex;
  Uint8List? image; 
  
  Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.moodIndex,
    this.image
  });



  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt.toString(),
      'moodIndex': moodIndex,
      'image': image != null && image!.length > 0 ? image : null,
    };
  }
}