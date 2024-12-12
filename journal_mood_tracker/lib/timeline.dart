import 'package:flutter/material.dart';
import 'package:journal_mood_tracker/models/note.dart';
import 'package:journal_mood_tracker/widgets/item_note.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimelineWidget extends StatelessWidget {
  final Note note;
  final bool isFirst;
  final bool isLast;
  const MyTimelineWidget({super.key, required this.isFirst, required this.isLast, required this.note});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: TimelineTile(
        alignment: TimelineAlign.start,
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: const LineStyle( thickness: 2),
        indicatorStyle: IndicatorStyle(
          width: 5
        ),
        endChild: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: ItemNote(note: note),
        ),
      ),
    );
  }
}