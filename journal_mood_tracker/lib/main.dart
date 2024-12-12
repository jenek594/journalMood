import 'package:flutter/material.dart';
import 'package:journal_mood_tracker/navigation_widget.dart';
import 'package:journal_mood_tracker/providers/notes/notes_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MaterialApp(home: const MyApp()) );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyDiary',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const NavigationWidget()
      ),
    );
  }
}

