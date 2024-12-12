import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal_mood_tracker/models/note.dart';
import 'package:journal_mood_tracker/screens/add_note/add_note_screen.dart';

class ItemNote extends StatelessWidget {
  final Note note;
  const ItemNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddNoteScreen(note: note))),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200]
        ),
        child: Row(
          children: [
            Container(
              // дата
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[200]
              ),
              child: Column(
                children: [
                  Text(DateFormat(DateFormat.ABBR_MONTH).format(note.createdAt), style: TextStyle(color: Colors.white70),),
                  const SizedBox(height: 3,),
                  Text(DateFormat(DateFormat.DAY).format(note.createdAt), style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                  const SizedBox(height: 3,),
                  Text(note.createdAt.year.toString(), style: TextStyle(color: Colors.white70),)
                ],
              ),
            ),
            const SizedBox(width: 15,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          note.title, 
                          style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis,)
                      ),
                    ],
                  ),
                  Text(
                    note.description, 
                    style: TextStyle(fontWeight: FontWeight.w300, height: 1.5),
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ) 
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(note.moodIndex.toString()),
            )

          ],
        ),
      ),
    );
  }
}