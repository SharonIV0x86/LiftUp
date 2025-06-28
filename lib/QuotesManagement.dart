import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(text: json['q'], author: json['a']);
  }
}

class QuotesManager extends ChangeNotifier {
  final String apiUrl = 'https://zenquotes.io/api/random';
  Quote? current;
  bool loading = false;
  // ignore: non_constant_identifier_names
  List<Quote> quotes_list = [];
  Quote? get currentQuote => current;
  bool get isLoading => loading;

  Future<void> fetchQuotes() async {
    loading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        current = Quote.fromJson(data[0]);
        // ignore: avoid_print
        print(current!.author);
        // ignore: avoid_print
        print(current!.text);
      } else {
        throw Exception("Failed to decode");
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error occurred $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void toggleFavorites() {
    if (quotes_list.contains(current)) {
      quotes_list.remove(current);
    } else {
      quotes_list.add(current!);
    }
    notifyListeners();
  }

  void removeQuoteFromFavorite(Quote quote) {
    quotes_list.remove(quote);
    notifyListeners();
  }
}
