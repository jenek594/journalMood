import 'package:flutter/material.dart';
import 'package:journal_mood_tracker/models/note.dart';
import 'package:journal_mood_tracker/repository/notes_repository.dart';
import 'package:journal_mood_tracker/widgets/item_note.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Note>> _selectedEvents;
  // ignore: prefer_final_fields
  Map<DateTime, List<Note>> _events = {}; // Cached events
  bool _eventsLoaded = false; // Flag to track if events are loaded

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _loadEvents().then((_) {
    setState(() {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }); // Load events when the widget is initialized
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // Asynchronous function to load all notes and process them
  Future<void> _loadEvents() async {
    if (_eventsLoaded) return;
    List<Note> allNotes = await NotesRepository.getNotes();
    // Print all loaded notes

    // Group notes by date
    for (Note note in allNotes) {
      DateTime date = DateTime(
          note.createdAt.year, note.createdAt.month, note.createdAt.day);
      if (!_events.containsKey(date)) {
        _events[date] = [];
      }
      _events[date]!.add(note);
    }
     // Print all events
    _eventsLoaded = true;
    setState(() {});
   _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  List<Note> _getEventsForDay(DateTime day) {
      DateTime date = DateTime(day.year, day.month, day.day);
       // Print what day we are trying to get
      return _events[date] ?? []; // Return an empty list if no notes found for the day
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Print the selected day
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
         _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2018, 3, 14),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          eventLoader: (day) =>
              _getEventsForDay(day), // Pass the function itself
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          onDaySelected: _onDaySelected,
          calendarStyle: const CalendarStyle(outsideDaysVisible: false),
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            thickness: 1,
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<List<Note>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return value.isEmpty
                  ? const Center(child: Text("No notes for this day"))
                  : ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final note = value[index];
                        return  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ItemNote(note: note),
                        );
                      });
            },
          ),
        ),
      ],
    );
  }
}