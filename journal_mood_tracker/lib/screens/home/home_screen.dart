
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:journal_mood_tracker/providers/notes/notes_provider.dart';
import 'package:journal_mood_tracker/quote.dart';
import 'package:journal_mood_tracker/screens/add_note/add_note_screen.dart';
import 'package:journal_mood_tracker/timeline.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Future<Quote> futureAlbum;
  @override
  void initState() {
    futureAlbum = fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotesProvider>(
        builder: (context, provider, child){
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 152, 170, 179),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [

                    ],
                  ) 
                  
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 245, 245),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      Text('Расскажите, как прошел ваш день?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i<5; i++)
                            IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => Provider.value(value: i, child: AddNoteScreen(isMoodIndex: true))));
                              }, 
                              icon: Text(i.toString())
                            )
                        ],
                      )
                    ],
                  ) 
                  
                ),
                Expanded(
                  child: (provider.notes.isNotEmpty)? ListView(
                  children: provider.notes.reversed.map((note) => MyTimelineWidget(isFirst: (provider.notes.last==note), isLast: (provider.notes.first==note), note: note)).toList(),
                  ) : Center(child: Text('Еще ни одной записи :('))
                )
                
              ],
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddNoteScreen()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_outlined),),
    );
  }


  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }
  
}



