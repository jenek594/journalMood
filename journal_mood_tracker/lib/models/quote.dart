class Quote {
  final String quoteText;
  final String author;

  Quote({
    required this.quoteText,
    required this.author
  });



  factory Quote.fromJson(Map<String, dynamic> json) {
      // Use the correct keys from the API response
      return Quote(
        quoteText: json['q'],  // 'q' is the key for quote text
        author: json['a'],     // 'a' is the key for author
      );
    }

}