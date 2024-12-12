
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:journal_mood_tracker/providers/notes/notes_provider.dart';
import 'package:journal_mood_tracker/models/quote.dart';

import 'package:journal_mood_tracker/screens/add_note/add_note_screen.dart';
import 'package:journal_mood_tracker/timeline.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Future<Quote> futureQuote;
  
  @override
  void initState() {
    futureQuote = fetchQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotesProvider>(
        builder: (context, provider, child){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 224, 244, 253),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: FutureBuilder(
                    future: futureQuote, 
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        return Column(
                          children: [
                            Text('" ${snapshot.data!.quoteText} "',
                              style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic, //Optional
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  snapshot.data!.author,
                                  style: TextStyle(
                                  fontSize: 14,
                                        
                                ),),
                              ],
                            )
                          ],
                        );
                      } else if (snapshot.hasError){
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    })
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: MediaQuery.sizeOf(context).width - 10,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 245, 245),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Text('Расскажите, как прошел ваш день?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i<5; i++)
                            IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => Provider.value(value: i, child: AddNoteScreen(isMoodIndex: i))));
                              }, 
                              icon: Image.asset('assets/mood_$i.png')
                            )
                        ],
                      )
                    ],
                  ) 
                  
                ),
                SizedBox(height: 15,),
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
  

  Future<Quote> fetchQuote() async{

    const url = 'https://zenquotes.io/api/random';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200){

      List<dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> quoteData = jsonResponse[0];

       return Quote.fromJson(quoteData);
    } else{
      throw Exception('Failed to load quote');
    }
  }
}



