class BotQuery {
  final String query;
  final String response; // Static response or key to fetch dynamic content

  BotQuery({
    required this.query,
    required this.response,
  });

  Map<String, dynamic> toMap() {
    return {
      'query': query,
      'response': response,
    };
  }

  static BotQuery fromMap(Map<String, dynamic> map) {
    return BotQuery(
      query: map['query'],
      response: map['response'],
    );
  }
}
